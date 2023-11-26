import 'package:animate_do/animate_do.dart';
import 'package:fahem_business/core/network/api_constants.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/jobs/job_model.dart';
import 'package:fahem_business/domain/usecases/jobs/delete_job_usecase.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/jobs_provider.dart';
import 'package:fahem_business/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobItem extends StatefulWidget {
  final JobModel jobModel;
  final int index;
  
  const JobItem({Key? key, required this.jobModel, required this.index}) : super(key: key);

  @override
  State<JobItem> createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> {
  late AppProvider appProvider;
  late JobsProvider jobsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    jobsProvider = Provider.of<JobsProvider>(context, listen: false);
  }
  
  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      duration: const Duration(milliseconds: 500),
      child: Container(
        decoration: BoxDecoration(
          color: widget.index % 2 == 0 ? ColorsManager.secondaryColor.withOpacity(0.5) : ColorsManager.primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(SizeManager.s10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, Routes.jobDetailsRoute, arguments: {ConstantsManager.jobModelArgument: widget.jobModel, ConstantsManager.tagArgument: ConstantsManager.jobsTag});
            },
            borderRadius: BorderRadius.circular(SizeManager.s10),
            child: Padding(
              padding: const EdgeInsets.all(SizeManager.s10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        // tag: widget.jobModel.image + ConstantsManager.jobsTag,
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pushNamed(context, Routes.showFullImageRoute, arguments: {ConstantsManager.imageArgument: widget.jobModel.image, ConstantsManager.directoryArgument: ApiConstants.jobsDirectory});
                          },
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            width: SizeManager.s80,
                            height: SizeManager.s80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(SizeManager.s10),
                            ),
                            child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.jobsDirectory}/${widget.jobModel.image}')),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(SizeManager.s10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.jobModel.jobTitle,
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                                    ),
                                  ),
                                  const SizedBox(width: SizeManager.s5),
                                  Text(
                                    Methods.formatDate(context: context, milliseconds: widget.jobModel.createdAt.millisecondsSinceEpoch),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: SizeManager.s5),
                              Text(
                                widget.jobModel.companyName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                '${widget.jobModel.minSalary} - ${widget.jobModel.maxSalary} ${Methods.getText(StringsManager.egp, appProvider.isEnglish).toUpperCase()}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: SizeManager.s5),
                              Wrap(
                                spacing: SizeManager.s5,
                                runSpacing: SizeManager.s5,
                                children: List.generate(widget.jobModel.features.length > ConstantsManager.maxNumberToShowFeaturesInJob ? ConstantsManager.maxNumberToShowFeaturesInJob : widget.jobModel.features.length, (index2) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: SizeManager.s2, horizontal: SizeManager.s10),
                                    decoration: BoxDecoration(
                                      color: widget.index % 2 == 0 ? ColorsManager.secondaryColor.withOpacity(0.8) : ColorsManager.primaryColor.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(SizeManager.s5),
                                    ),
                                    child: Text(
                                      widget.jobModel.features[index2],
                                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.bold),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          buttonType: ButtonType.text,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pushNamed(context, Routes.editJobRoute, arguments: {ConstantsManager.jobModelArgument: widget.jobModel});
                          },
                          text: Methods.getText(StringsManager.edit, appProvider.isEnglish).toUpperCase(),
                          height: SizeManager.s35,
                        ),
                      ),
                      const SizedBox(width: SizeManager.s10),
                      Expanded(
                        child: CustomButton(
                          buttonType: ButtonType.text,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.areYouSureToDelete, appProvider.isEnglish).toCapitalized()).then((value) {
                              if(value) {
                                DeleteJobParameters parameters = DeleteJobParameters(
                                  jobId: widget.jobModel.jobId,
                                  targetId: widget.jobModel.targetId,
                                  targetName: widget.jobModel.targetName,
                                );
                                jobsProvider.onPressedDeleteJob(context, parameters);
                              }
                            });
                          },
                          text: Methods.getText(StringsManager.delete, appProvider.isEnglish).toUpperCase(),
                          height: SizeManager.s35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}