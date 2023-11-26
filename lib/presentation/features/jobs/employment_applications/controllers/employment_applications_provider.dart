import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/employment_applications/employment_application_model.dart';
import 'package:fahem_business/domain/usecases/employment_applications/get_employment_applications_for_target_usecase.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/jobs_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmploymentApplicationsProvider with ChangeNotifier {
  final GetEmploymentApplicationsForTargetUseCase _getEmploymentApplicationsForTargetUseCase;

  EmploymentApplicationsProvider(this._getEmploymentApplicationsForTargetUseCase);

  Future<Either<Failure, List<EmploymentApplicationModel>>> getEmploymentApplicationsForTargetImpl(GetEmploymentApplicationsForTargetParameters parameters) async {
    return await _getEmploymentApplicationsForTargetUseCase.call(parameters);
  }

  List<EmploymentApplicationModel> _employmentApplications = [];
  List<EmploymentApplicationModel> get employmentApplications => _employmentApplications;
  setEmploymentApplications(List<EmploymentApplicationModel> employmentApplications) => _employmentApplications = employmentApplications;

  List<EmploymentApplicationModel> _selectedEmploymentApplications = [];
  List<EmploymentApplicationModel> get selectedEmploymentApplications => _selectedEmploymentApplications;
  setSelectedEmploymentApplications(List<EmploymentApplicationModel> selectedEmploymentApplications) => _selectedEmploymentApplications = selectedEmploymentApplications;
  changeSelectedEmploymentApplications(List<EmploymentApplicationModel> selectedEmploymentApplications) {
    _selectedEmploymentApplications = selectedEmploymentApplications;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  void deleteAllEmploymentApplicationsWithJobId(int jobId) {
    _employmentApplications.removeWhere((element) => element.jobId == jobId);
    _selectedEmploymentApplications.removeWhere((element) => element.jobId == jobId);
  }

  void onChangeSearch(BuildContext context, String val) {
    JobsProvider jobsProvider = Provider.of<JobsProvider>(context, listen: false);

    changeSelectedEmploymentApplications(_employmentApplications.where((employmentApplication) {
      String jobTitle = jobsProvider.getJobWithId(employmentApplication.jobId).jobTitle;

      return employmentApplication.name.toLowerCase().contains(val.toLowerCase())
          || jobTitle.contains(val.toLowerCase());
    }).toList());
  }

  void onClearSearch() {
    changeSelectedEmploymentApplications(_employmentApplications);
  }

  // Start Pagination //
  int _numberOfItems = 0;
  int get numberOfItems => _numberOfItems;
  setNumberOfItems(int numberOfItems) => _numberOfItems = numberOfItems;
  changeNumberOfItems(int numberOfItems) {_numberOfItems = numberOfItems; notifyListeners();}

  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;
  setHasMoreData(bool hasMoreData) => _hasMoreData = hasMoreData;
  changeHasMoreData(bool hasMoreData) {_hasMoreData = hasMoreData;  notifyListeners();}

  late ScrollController _scrollController;
  ScrollController get scrollController => _scrollController;
  initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent) {
        showDataInList(isResetData: false, isRefresh: true, isScrollUp: false);
      }
    });
  }
  disposeScrollController() => _scrollController.dispose();
  _scrollUp() => _scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);

  int limit = 10;

  void showDataInList({required bool isResetData, required bool isRefresh, required bool isScrollUp}) async {
    try { // Check scrollController created or not & hasClients or not
      if(_scrollController.hasClients) {
        if(isScrollUp) {_scrollUp();}
      }
    }
    catch(error) {
      debugPrint(error.toString());
    }

    if(isResetData) {
      setNumberOfItems(0);
      setHasMoreData(true);
    }

    if(_hasMoreData) {
      List list = _selectedEmploymentApplications;
      if(isRefresh) {changeNumberOfItems(_numberOfItems += (list.length - numberOfItems) >= limit ? limit : (list.length - numberOfItems));}
      if(!isRefresh) {setNumberOfItems(_numberOfItems += (list.length - numberOfItems) >= limit ? limit : (list.length - numberOfItems));}
      debugPrint('numberOfItems: $_numberOfItems');

      if(numberOfItems == list.length) {
        if(isRefresh) {changeHasMoreData(false);}
        if(!isRefresh) {setHasMoreData(false);}
      }
    }
  }
  // End Pagination //
}