import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_reviews/controllers/lawyer_reviews_provider.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer_reviews/widgets/lawyer_review_item.dart';
import 'package:fahem_business/presentation/shared/load_more.dart';
import 'package:fahem_business/presentation/shared/my_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LawyerReviewsScreen extends StatefulWidget {

  const LawyerReviewsScreen({Key? key}) : super(key: key);

  @override
  State<LawyerReviewsScreen> createState() => _LawyersReviewsScreenState();
}

class _LawyersReviewsScreenState extends State<LawyerReviewsScreen> {
  late AppProvider appProvider;
  late LawyerReviewsProvider lawyerReviewsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    lawyerReviewsProvider = Provider.of<LawyerReviewsProvider>(context, listen: false);

    lawyerReviewsProvider.initScrollController();
    lawyerReviewsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LawyerReviewsProvider>(
      builder: (context, provider, _) {
        return MyTemplate(
          pageTitle: StringsManager.reviews,
          isSupportSearch: false,
          notFoundMessage: StringsManager.thereAreNoReviews,
          list: provider.lawyersReviews,
          listItemCount: provider.numberOfItems,
          scrollController: provider.scrollController,
          itemBuilder: (context, index) {
            return Column(
              children: [
                LawyerReviewItem(lawyerReviewModel: provider.lawyersReviews[index], index: index),
                if(index == provider.numberOfItems-1) LoadMore(hasMoreData: provider.hasMoreData, dataLength: provider.lawyersReviews.length, limit: provider.limit),
              ],
            );
          },
        );
      }
    );
  }

  @override
  void dispose() {
    lawyerReviewsProvider.disposeScrollController();
    super.dispose();
  }
}