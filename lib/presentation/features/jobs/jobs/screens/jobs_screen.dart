import 'package:fahem_business/core/resources/routes_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/jobs_provider.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/widgets/job_item.dart';
import 'package:fahem_business/presentation/shared/load_more.dart';
import 'package:fahem_business/presentation/shared/my_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobsScreen extends StatefulWidget {

  const JobsScreen({Key? key}) : super(key: key);

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  late AppProvider appProvider;
  late JobsProvider jobsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    jobsProvider = Provider.of<JobsProvider>(context, listen: false);

    jobsProvider.setSelectedJobs(jobsProvider.jobs);
    jobsProvider.initScrollController();
    jobsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsProvider>(
      builder: (context, provider, _) {
        return MyTemplate(
          pageTitle: StringsManager.jobs,
          isSupportSearch: true,
          labelText: StringsManager.searchByJobTitle,
          onChanged: (val) => provider.onChangeSearch(context, val.trim()),
          onClearSearch: () => provider.onClearSearch(),
          notFoundMessage: StringsManager.thereAreNoJobs,
          list: provider.selectedJobs,
          listItemCount: provider.numberOfItems,
          scrollController: provider.scrollController,
          itemBuilder: (context, index) {
            return Column(
              children: [
                JobItem(jobModel: provider.selectedJobs[index], index: index),
                if(index == provider.numberOfItems-1) LoadMore(hasMoreData: provider.hasMoreData, dataLength: provider.selectedJobs.length, limit: provider.limit),
              ],
            );
          },
          isLoading: provider.isLoading,
          addRoute: Routes.addJobRoute,
        );
      },
    );
  }

  @override
  void dispose() {
    jobsProvider.disposeScrollController();
    super.dispose();
  }
}