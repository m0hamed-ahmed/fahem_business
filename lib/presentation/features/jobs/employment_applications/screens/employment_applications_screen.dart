import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/presentation/features/jobs/employment_applications/controllers/employment_applications_provider.dart';
import 'package:fahem_business/presentation/features/jobs/employment_applications/widgets/employment_application_item.dart';
import 'package:fahem_business/presentation/shared/load_more.dart';
import 'package:fahem_business/presentation/shared/my_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmploymentApplicationsScreen extends StatefulWidget {

  const EmploymentApplicationsScreen({Key? key}) : super(key: key);

  @override
  State<EmploymentApplicationsScreen> createState() => _EmploymentApplicationsScreenState();
}

class _EmploymentApplicationsScreenState extends State<EmploymentApplicationsScreen> {
  late AppProvider appProvider;
  late EmploymentApplicationsProvider employmentApplicationsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    employmentApplicationsProvider = Provider.of<EmploymentApplicationsProvider>(context, listen: false);

    employmentApplicationsProvider.setSelectedEmploymentApplications(employmentApplicationsProvider.employmentApplications);
    employmentApplicationsProvider.initScrollController();
    employmentApplicationsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmploymentApplicationsProvider>(
      builder: (context, provider, _) {
        return MyTemplate(
          pageTitle: StringsManager.employmentApplications,
          isSupportSearch: true,
          labelText: StringsManager.searchByNameOrJob,
          onChanged: (val) => provider.onChangeSearch(context, val.trim()),
          onClearSearch: () => provider.onClearSearch(),
          notFoundMessage: StringsManager.thereAreNoEmploymentApplications,
          list: provider.selectedEmploymentApplications,
          listItemCount: provider.numberOfItems,
          scrollController: provider.scrollController,
          itemBuilder: (context, index) {
            return Column(
              children: [
                EmploymentApplicationItem(employmentApplicationModel: provider.selectedEmploymentApplications[index], index: index),
                if(index == provider.numberOfItems-1) LoadMore(hasMoreData: provider.hasMoreData, dataLength: provider.selectedEmploymentApplications.length, limit: provider.limit),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    employmentApplicationsProvider.disposeScrollController();
    super.dispose();
  }
}