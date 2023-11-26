import 'package:animate_do/animate_do.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/lawyers_reviews/lawyer_review_model.dart';
import 'package:fahem_business/presentation/shared/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LawyerReviewItem extends StatefulWidget {
  final LawyerReviewModel lawyerReviewModel;
  final int index;

  const LawyerReviewItem({Key? key, required this.lawyerReviewModel, required this.index}) : super(key: key);

  @override
  State<LawyerReviewItem> createState() => _LawyerReviewItemState();
}

class _LawyerReviewItemState extends State<LawyerReviewItem> {
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
                    '${widget.lawyerReviewModel.firstName} ${widget.lawyerReviewModel.familyName}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                  ),
                ),
                const SizedBox(width: SizeManager.s5),
                Text(
                  Methods.formatDate(context: context, milliseconds: widget.lawyerReviewModel.createdAt.millisecondsSinceEpoch),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: SizeManager.s5),
            Row(
              children: [
                RatingBar(numberOfStars: widget.lawyerReviewModel.rating),
                const SizedBox(width: SizeManager.s5),
                Text(
                  widget.lawyerReviewModel.rating.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: SizeManager.s10),
            Text(
              widget.lawyerReviewModel.comment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: SizeManager.s10),
            Text(
              appProvider.isEnglish ? widget.lawyerReviewModel.featuresEn.join(' - ') : widget.lawyerReviewModel.featuresAr.join(' - '),
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