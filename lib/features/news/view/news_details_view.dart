import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_four/features/news/manager/getNewsDetails/get_news_details_cubit.dart';
import 'package:twenty_four/features/news/models/news_details_model.dart';
import 'package:twenty_four/features/news/view/widgets/news_header.dart';
import 'package:twenty_four/features/news/view/widgets/news_content.dart';
import 'package:twenty_four/features/news/view/widgets/floating_comment_button.dart';
import 'package:twenty_four/features/news/view/widgets/news_loading.dart';
import 'package:twenty_four/features/news/view/widgets/news_error.dart';

class NewsDetailsView extends StatefulWidget {
  final int id;
  const NewsDetailsView({super.key, required this.id});

  @override
  State<NewsDetailsView> createState() => _NewsDetailsViewState();
}

class _NewsDetailsViewState extends State<NewsDetailsView> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    BlocProvider.of<GetNewsDetailsCubit>(context).getNewsDetails(id: widget.id);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<GetNewsDetailsCubit, GetNewsDetailsState>(
      listener: (context, state) {
        if (state is GetNewsDetailsSuccess) {
          print("data is ${state.newsDetailsModel}");
        }
      },
      builder: (context, state) {
        if (state is GetNewsDetailsLoading) {
          return const NewsLoading();
        }

        if (state is GetNewsDetailsFailure) {
          return NewsError(
            message: state.message,
            onBackPressed: () => Navigator.pop(context),
          );
        }

        if (state is GetNewsDetailsSuccess) {
          return _buildSuccessState(state.newsDetailsModel, theme);
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Center(
            child: Text(
              'حدث خطأ غير متوقع',
              style: theme.textTheme.titleMedium,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessState(NewsDetailsModel newsDetails, ThemeData theme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                NewsHeader(
                  newsDetails: newsDetails,
                  scrollOffset: _scrollOffset,
                  onBackPressed: () => Navigator.pop(context),
                ),
                NewsContent(newsDetails: newsDetails, isDarkMode: isDarkMode),
              ],
            ),
            FloatingCommentButton(
              newsId: newsDetails.id!,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }
}
