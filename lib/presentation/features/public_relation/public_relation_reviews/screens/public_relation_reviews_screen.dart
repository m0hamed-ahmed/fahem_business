import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_reviews/controllers/public_relation_reviews_provider.dart';
import 'package:fahem_business/presentation/features/public_relation/public_relation_reviews/widgets/public_relation_review_item.dart';
import 'package:fahem_business/presentation/shared/load_more.dart';
import 'package:fahem_business/presentation/shared/my_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublicRelationReviewsScreen extends StatefulWidget {

  const PublicRelationReviewsScreen({Key? key}) : super(key: key);

  @override
  State<PublicRelationReviewsScreen> createState() => _PublicRelationsReviewsScreenState();
}

class _PublicRelationsReviewsScreenState extends State<PublicRelationReviewsScreen> {
  late AppProvider appProvider;
  late PublicRelationReviewsProvider publicRelationReviewsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    publicRelationReviewsProvider = Provider.of<PublicRelationReviewsProvider>(context, listen: false);

    publicRelationReviewsProvider.initScrollController();
    publicRelationReviewsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PublicRelationReviewsProvider>(
      builder: (context, provider, _) {
        return MyTemplate(
          pageTitle: StringsManager.reviews,
          isSupportSearch: false,
          notFoundMessage: StringsManager.thereAreNoReviews,
          list: provider.publicRelationsReviews,
          listItemCount: provider.numberOfItems,
          scrollController: provider.scrollController,
          itemBuilder: (context, index) {
            return Column(
              children: [
                PublicRelationReviewItem(publicRelationReviewModel: provider.publicRelationsReviews[index], index: index),
                if(index == provider.numberOfItems-1) LoadMore(hasMoreData: provider.hasMoreData, dataLength: provider.publicRelationsReviews.length, limit: provider.limit),
              ],
            );
          },
        );
      }
    );
  }

  @override
  void dispose() {
    publicRelationReviewsProvider.disposeScrollController();
    super.dispose();
  }
}