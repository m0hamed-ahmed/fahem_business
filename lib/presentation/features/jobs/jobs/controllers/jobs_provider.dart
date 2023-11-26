import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/jobs/job_model.dart';
import 'package:fahem_business/domain/usecases/jobs/delete_job_usecase.dart';
import 'package:fahem_business/domain/usecases/jobs/edit_job_usecase.dart';
import 'package:fahem_business/domain/usecases/jobs/get_jobs_for_target_usecase.dart';
import 'package:fahem_business/domain/usecases/jobs/insert_job_usecase.dart';
import 'package:fahem_business/presentation/features/jobs/employment_applications/controllers/employment_applications_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobsProvider with ChangeNotifier {
  final GetJobsForTargetUseCase _getJobsForTargetUseCase;
  final InsertJobUseCase _insertJobUseCase;
  final EditJobUseCase _editJobUseCase;
  final DeleteJobUseCase _deleteJobUseCase;

  JobsProvider(this._getJobsForTargetUseCase, this._insertJobUseCase, this._editJobUseCase, this._deleteJobUseCase);

  Future<Either<Failure, List<JobModel>>> getJobsForTargetImpl(GetJobsForTargetParameters parameters) async {
    return await _getJobsForTargetUseCase.call(parameters);
  }

  Future<Either<Failure, JobModel>> insertJobImpl(InsertJobParameters parameters) async {
    return await _insertJobUseCase.call(parameters);
  }

  Future<Either<Failure, JobModel>> editJobImpl(EditJobParameters parameters) async {
    return await _editJobUseCase.call(parameters);
  }

  Future<Either<Failure, void>> deleteJobImpl(DeleteJobParameters parameters) async {
    return await _deleteJobUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  List<JobModel> _jobs = [];
  List<JobModel> get jobs => _jobs;
  setJobs(List<JobModel> jobs) => _jobs = jobs;

  List<JobModel> _selectedJobs = [];
  List<JobModel> get selectedJobs => _selectedJobs;
  setSelectedJobs(List<JobModel> selectedJobs) => _selectedJobs = selectedJobs;
  changeSelectedJobs(List<JobModel> selectedJobs) {
    _selectedJobs = selectedJobs;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  JobModel getJobWithId(int jobId) {
    return _jobs.firstWhere((element) => element.jobId == jobId);
  }
  addJob(JobModel jobModel) {
    _jobs.add(jobModel);
    changeSelectedJobs(_jobs);
  }
  editJob(JobModel jobModel) {
    int index1 = _jobs.indexWhere((element) => element.jobId == jobModel.jobId);
    int index2 = _selectedJobs.indexWhere((element) => element.jobId == jobModel.jobId);

    if(index1 != -1) {
      _jobs[index1] = jobModel;
    }
    if(index2 != -1) {
      _selectedJobs[index2] = jobModel;
    }

    notifyListeners();
  }
  deleteJob(int jobId) {
    int index1 = _jobs.indexWhere((element) => element.jobId == jobId);
    int index2 = _selectedJobs.indexWhere((element) => element.jobId == jobId);

    if(index1 != -1) {
      _jobs.removeWhere((element) => element.jobId == jobId);
    }
    if(index2 != -1) {
      _selectedJobs.removeWhere((element) => element.jobId == jobId);
    }

    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  void onChangeSearch(BuildContext context, String val) {
    changeSelectedJobs(_jobs.where((job) {
      return job.jobTitle.toLowerCase().contains(val.toLowerCase());
    }).toList());
  }

  void onClearSearch() {
    changeSelectedJobs(_jobs);
  }

  Future<void> onPressedDeleteJob(BuildContext context, DeleteJobParameters parameters) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    EmploymentApplicationsProvider employmentApplicationsProvider = Provider.of<EmploymentApplicationsProvider>(context, listen: false);
    changeIsLoading(true);

    // Delete Job
    Either<Failure, void> response = await deleteJobImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (_) {
      changeIsLoading(false);
      Dialogs.showBottomSheetMessage(
        context: context,
        message: Methods.getText(StringsManager.deletedSuccessfully, appProvider.isEnglish).toTitleCase(),
        showMessage: ShowMessage.success,
        thenMethod: () {
          deleteJob(parameters.jobId);
          employmentApplicationsProvider.deleteAllEmploymentApplicationsWithJobId(parameters.jobId);
        },
      );
    });
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
      List list = _selectedJobs;
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