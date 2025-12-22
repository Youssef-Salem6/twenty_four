import 'package:flutter/material.dart';
import 'package:twenty_four/core/themes/themes.dart';
import 'package:twenty_four/features/news/models/faq_model.dart';

class FaqView extends StatefulWidget {
  final List faqs;
  final bool isDarkMode;

  const FaqView({super.key, required this.faqs, required this.isDarkMode});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.faqs.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.faqs.length,
            itemBuilder: (context, index) {
              return _buildFaqItem(
                FaqModel.fromJson(widget.faqs[index]),
                index,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline_rounded,
            size: 80,
            color: AppThemes.getHintColor(widget.isDarkMode),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد أسئلة شائعة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppThemes.getTextColor(widget.isDarkMode),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم إضافة أي أسئلة بعد',
            style: TextStyle(
              fontSize: 14,
              color: AppThemes.getHintColor(widget.isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(FaqModel faq, int index) {
    final isExpanded = _expandedIndex == index;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
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
        margin: const EdgeInsets.only(bottom: 12),
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
                  _expandedIndex = isExpanded ? null : index;
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
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.question_answer_rounded,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            faq.question ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppThemes.getTextColor(widget.isDarkMode),
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
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
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                faq.answer ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color:
                                      widget.isDarkMode
                                          ? Colors.white70
                                          : Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      crossFadeState:
                          isExpanded
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
