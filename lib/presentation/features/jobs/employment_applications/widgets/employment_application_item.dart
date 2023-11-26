import 'package:animate_do/animate_do.dart';
import 'package:fahem_business/core/network/api_constants.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/employment_applications/employment_application_model.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/jobs_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmploymentApplicationItem extends StatefulWidget {
  final EmploymentApplicationModel employmentApplicationModel;
  final int index;

  const EmploymentApplicationItem({Key? key, required this.employmentApplicationModel, required this.index}) : super(key: key);

  @override
  State<EmploymentApplicationItem> createState() => _EmploymentApplicationItemState();
}

class _EmploymentApplicationItemState extends State<EmploymentApplicationItem> {
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
        padding: const EdgeInsets.all(SizeManager.s5),
        decoration: BoxDecoration(
          color: widget.index % 2 == 0 ? ColorsManager.secondaryColor.withOpacity(0.5) : ColorsManager.primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(SizeManager.s10),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                Methods.getText(StringsManager.name, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.black),
              ),
              subtitle: Text(
                widget.employmentApplicationModel.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            ListTile(
              title: Text(
                Methods.getText(StringsManager.phoneNumber, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.black),
              ),
              subtitle: Text(
                widget.employmentApplicationModel.phoneNumber,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            ListTile(
              title: Text(
                Methods.getText(StringsManager.cv, appProvider.isEnglish).toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.black),
              ),
              subtitle: Row(
                children: [
                  TextButton(
                    onPressed: () => Methods.openUrl(ApiConstants.fileUrl(fileName: '${ApiConstants.employmentApplicationsDirectory}/${widget.employmentApplicationModel.cv}')),
                    style: TextButton.styleFrom(
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      backgroundColor: widget.index % 2 == 0 ? ColorsManager.secondaryColor : ColorsManager.primaryColor,
                    ),
                    child: Text(
                      Methods.getText(StringsManager.showCv, appProvider.isEnglish),
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white),
                    ),
                  ),
                ],
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            ListTile(
              title: Text(
                Methods.getText(StringsManager.job, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.black),
              ),
              subtitle: Text(
                jobsProvider.getJobWithId(widget.employmentApplicationModel.jobId).jobTitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            ListTile(
              title: Text(
                Methods.getText(StringsManager.date, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.black),
              ),
              subtitle: Text(
                Methods.formatDate(context: context, milliseconds: widget.employmentApplicationModel.createdAt.millisecondsSinceEpoch),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
          ],
        ),
      ),
    );
  }
}