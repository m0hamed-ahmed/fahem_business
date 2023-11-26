import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_reviews/controllers/legal_accountant_reviews_provider.dart';
import 'package:fahem_business/presentation/features/legal_accountant/legal_accountant_reviews/widgets/legal_accountant_review_item.dart';
import 'package:fahem_business/presentation/shared/load_more.dart';
import 'package:fahem_business/presentation/shared/my_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LegalAccountantReviewsScreen extends StatefulWidget {

  const LegalAccountantReviewsScreen({Key? key}) : super(key: key);

  @override
  State<LegalAccountantReviewsScreen> createState() => _LegalAccountantsReviewsScreenState();
}

class _LegalAccountantsReviewsScreenState extends State<LegalAccountantReviewsScreen> {
  late AppProvider appProvider;
  late LegalAccountantReviewsProvider legalAccountantReviewsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    legalAccountantReviewsProvider = Provider.of<LegalAccountantReviewsProvider>(context, listen: false);

    legalAccountantReviewsProvider.initScrollController();
    legalAccountantReviewsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LegalAccountantReviewsProvider>(
      builder: (context, provider, _) {
        return MyTemplate(
          pageTitle: StringsManager.reviews,
          isSupportSearch: false,
          notFoundMessage: StringsManager.thereAreNoReviews,
          list: provider.legalAccountantsReviews,
          listItemCount: provider.numberOfItems,
          scrollController: provider.scrollController,
          itemBuilder: (context, index) {
            return Column(
              children: [
                LegalAccountantReviewItem(legalAccountantReviewModel: provider.legalAccountantsReviews[index], index: index),
                if(index == provider.numberOfItems-1) LoadMore(hasMoreData: provider.hasMoreData, dataLength: provider.legalAccountantsReviews.length, limit: provider.limit),
              ],
            );
          },
        );
      }
    );
  }

  @override
  void dispose() {
    legalAccountantReviewsProvider.disposeScrollController();
    super.dispose();
  }
}