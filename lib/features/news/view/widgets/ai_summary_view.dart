import 'package:flutter/material.dart';
import 'package:twenty_four/core/themes/themes.dart';

class AiSummaryView extends StatefulWidget {
  final String summary;
  final bool isDarkMode;

  const AiSummaryView({
    super.key,
    required this.summary,
    required this.isDarkMode,
  });

  @override
  State<AiSummaryView> createState() => _AiSummaryViewState();
}

class _AiSummaryViewState extends State<AiSummaryView> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppThemes.getCardColor(widget.isDarkMode),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade400,
                                Colors.blue.shade400,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'ملخص الخبر بالذكاء الاصطناعي',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppThemes.getTextColor(widget.isDarkMode),
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppThemes.getIconColor(widget.isDarkMode),
                          ),
                        ),
                      ],
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Container(
                        margin: const EdgeInsets.only(top: 12, right: 40),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              widget.isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.smart_toy_rounded,
                              color: Colors.purple.shade400,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.summary,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color:
                                      widget.isDarkMode
                                          ? Colors.white70
                                          : Colors.grey[800],
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      crossFadeState:
                          _isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
