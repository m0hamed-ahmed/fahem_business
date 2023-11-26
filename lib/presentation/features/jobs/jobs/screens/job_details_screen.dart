import 'package:fahem_business/core/network/api_constants.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/jobs/job_model.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/job_details_provider.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobDetailsScreen extends StatefulWidget {
  final JobModel jobModel;
  final String tag;
  
  const JobDetailsScreen({Key? key, required this.jobModel, required this.tag}) : super(key: key);

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  late AppProvider appProvider;
  late JobDetailsProvider jobDetailsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    jobDetailsProvider = Provider.of<JobDetailsProvider>(context, listen: false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        body: Background(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(SizeManager.s16),
              child: Selector<JobDetailsProvider, JobDetailsMode>(
                selector: (context, provider) => provider.jobDetailsMode,
                builder: (context, jobDetailsMode, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyHeader(title: StringsManager.jobDetails),
                      const SizedBox(height: SizeManager.s20),
                      Center(
                        child: SizedBox(
                          // tag: widget.jobModel.image + widget.tag,
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, Routes.showFullImageRoute, arguments: {ConstantsManager.imageArgument: widget.jobModel.image, ConstantsManager.directoryArgument: ApiConstants.jobsDirectory}),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              width: SizeManager.s100,
                              height: SizeManager.s100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.jobsDirectory}/${widget.jobModel.image}')),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s10),
                      Center(
                        child: Text(
                          widget.jobModel.jobTitle,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                        ),
                      ),
                      Center(
                        child: Text(
                          widget.jobModel.companyName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Center(
                        child: Text(
                          widget.jobModel.jobLocation,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: SizeManager.s10),
                      Center(
                        child: Wrap(
                          spacing: SizeManager.s5,
                          runSpacing: SizeManager.s5,
                          alignment: WrapAlignment.center,
                          children: List.generate(widget.jobModel.features.length, (index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: SizeManager.s1, horizontal: SizeManager.s10),
                              decoration: BoxDecoration(
                                color: ColorsManager.white,
                                borderRadius: BorderRadius.circular(SizeManager.s10),
                                border: Border.all(color: ColorsManager.primaryColor),
                              ),
                              child: Text(
                                widget.jobModel.features[index],
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: ColorsManager.primaryColor,
                                  fontWeight: FontWeightManager.bold,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s10),
                      const Divider(color: ColorsManager.grey),
                      const SizedBox(height: SizeManager.s10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonType: ButtonType.text,
                              onPressed: () => jobDetailsProvider.changeJobDetailsMode(JobDetailsMode.jobDetails),
                              text: Methods.getText(StringsManager.jobDetails, appProvider.isEnglish).toTitleCase(),
                              height: SizeManager.s35,
                              textFontWeight: FontWeightManager.medium,
                              buttonColor: jobDetailsMode == JobDetailsMode.jobDetails ? ColorsManager.secondaryColor : ColorsManager.white,
                              borderColor: jobDetailsMode == JobDetailsMode.jobDetails ? ColorsManager.secondaryColor : ColorsManager.primaryColor,
                              textColor: jobDetailsMode == JobDetailsMode.jobDetails ? ColorsManager.white : ColorsManager.primaryColor,
                              borderRadius: SizeManager.s10,
                            ),
                          ),
                          const SizedBox(width: SizeManager.s10),
                          Expanded(
                            child: CustomButton(
                              buttonType: ButtonType.text,
                              onPressed: () => jobDetailsProvider.changeJobDetailsMode(JobDetailsMode.aboutCompany),
                              text: Methods.getText(StringsManager.aboutCompany, appProvider.isEnglish).toTitleCase(),
                              height: SizeManager.s35,
                              textFontWeight: FontWeightManager.medium,
                              buttonColor: jobDetailsMode == JobDetailsMode.aboutCompany ? ColorsManager.secondaryColor : ColorsManager.white,
                              borderColor: jobDetailsMode == JobDetailsMode.aboutCompany ? ColorsManager.secondaryColor : ColorsManager.primaryColor,
                              textColor: jobDetailsMode == JobDetailsMode.aboutCompany ? ColorsManager.white : ColorsManager.primaryColor,
                              borderRadius: SizeManager.s10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SizeManager.s20),
                      Text(
                        Methods.getText(jobDetailsMode == JobDetailsMode.jobDetails ? StringsManager.jobDetails : StringsManager.aboutCompany, appProvider.isEnglish).toTitleCase(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                      ),
                      const SizedBox(height: SizeManager.s10),
                      Text(
                        jobDetailsMode == JobDetailsMode.jobDetails ? widget.jobModel.details : widget.jobModel.aboutCompany,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}