import 'package:animate_do/animate_do.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem_business/presentation/shared/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublicRelationReviewItem extends StatefulWidget {
  final PublicRelationReviewModel publicRelationReviewModel;
  final int index;
  
  const PublicRelationReviewItem({Key? key, required this.publicRelationReviewModel, required this.index}) : super(key: key);

  @override
  State<PublicRelationReviewItem> createState() => _PublicRelationReviewItemState();
}

class _PublicRelationReviewItemState extends State<PublicRelationReviewItem> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }
  
  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(SizeManager.s10),
        decoration: BoxDecoration(
          color: widget.index % 2 == 0 ? ColorsManager.secondaryColor.withOpacity(0.5) : ColorsManager.primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(SizeManager.s10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '${widget.publicRelationReviewModel.firstName} ${widget.publicRelationReviewModel.familyName}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                  ),
                ),
                const SizedBox(width: SizeManager.s5),
                Text(
                  Methods.formatDate(context: context, milliseconds: widget.publicRelationReviewModel.createdAt.millisecondsSinceEpoch),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: SizeManager.s5),
            Row(
              children: [
                RatingBar(numberOfStars: widget.publicRelationReviewModel.rating),
                const SizedBox(width: SizeManager.s5),
                Text(
                  widget.publicRelationReviewModel.rating.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: SizeManager.s10),
            Text(
              widget.publicRelationReviewModel.comment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: SizeManager.s10),
            Text(
              appProvider.isEnglish ? widget.publicRelationReviewModel.featuresEn.join(' - ') : widget.publicRelationReviewModel.featuresAr.join(' - '),
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: widget.index % 2 == 0 ? ColorsManager.secondaryColor : ColorsManager.primaryColor,
                fontWeight: FontWeightManager.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}