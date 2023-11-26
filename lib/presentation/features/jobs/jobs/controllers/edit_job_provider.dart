import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/network/api_constants.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/core/utils/upload_file_provider.dart';
import 'package:fahem_business/data/models/jobs/job_model.dart';
import 'package:fahem_business/domain/usecases/jobs/edit_job_usecase.dart';
import 'package:fahem_business/domain/usecases/shared/upload_file_usecase.dart';
import 'package:fahem_business/presentation/features/jobs/jobs/controllers/jobs_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditJobProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  bool _isButtonClicked = false;
  bool get isButtonClicked => _isButtonClicked;
  setIsButtonClicked(bool isButtonClicked) => _isButtonClicked = isButtonClicked;
  changeIsButtonClicked(bool isButtonClicked) {_isButtonClicked = isButtonClicked; notifyListeners();}

  XFile? _image;
  XFile? get image => _image;
  setImage(XFile? image) => _image = image;
  changeImage(XFile? image) {_image = image; notifyListeners();}

  String imageNameFromDatabase = '';

  List<String> _features = [];
  List<String> get features => _features;
  setFeatures(List<String> features) => _features = features;
  changeFeatures(List<String> features) {_features = features; notifyListeners();}
  addInFeatures(String feature) {
    if(!_features.contains(feature) && feature.isNotEmpty) {
      _features.add(feature);
      notifyListeners();
    }
  }
  removeFromFeatures(String feature) {
    _features.removeWhere((element) => element == feature);
    notifyListeners();
  }

  bool _isAvailable = true;
  bool get isAvailable => _isAvailable;
  setIsAvailable(bool isAvailable) => _isAvailable = isAvailable;
  changeIsAvailable(bool isAvailable) {_isAvailable = isAvailable; notifyListeners();}

  bool isAllDataValid(BuildContext context) {
    if(_features.isEmpty) {return false;}
    return true;
  }

  void resetAllData() {
    setIsButtonClicked(false);
    setImage(null);
    setFeatures([]);
    setIsAvailable(false);
  }

  Future<void> editJob({required BuildContext context, required JobModel jobModel}) async {
    if(_image == null) {
      _editJobWithoutImage(context, jobModel);
    }
    else {
      _editJobWithImage(context, jobModel);
    }
  }

  Future<void> _editJobWithImage(BuildContext context, JobModel jobModel) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UploadFileProvider uploadFileProvider = Provider.of<UploadFileProvider>(context, listen: false);
    JobsProvider jobsProvider = Provider.of<JobsProvider>(context, listen: false);

    changeIsLoading(true);

    // Upload Image
    UploadFileParameters uploadFileParameters = UploadFileParameters(
      file: File(_image!.path),
      directory: ApiConstants.jobsDirectory,
    );
    Either<Failure, String> response = await uploadFileProvider.uploadFileImpl(uploadFileParameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (image) async {
      // Edit Job
      jobModel.image = image;
      EditJobParameters parameters = EditJobParameters(
        jobModel: jobModel,
      );
      Either<Failure, JobModel> response = await jobsProvider.editJobImpl(parameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (job) {
        changeIsLoading(false);
        jobsProvider.editJob(job);
        resetAllData();
        Dialogs.showBottomSheetMessage(
          context: context,
          message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(),
          showMessage: ShowMessage.success,
          thenMethod: () {
            Navigator.pop(context);
          },
        );
      });
    });
  }

  Future<void> _editJobWithoutImage(BuildContext context, JobModel jobModel) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    JobsProvider jobsProvider = Provider.of<JobsProvider>(context, listen: false);

    changeIsLoading(true);

    // Edit Job
    EditJobParameters parameters = EditJobParameters(
      jobModel: jobModel,
    );
    Either<Failure, JobModel> response = await jobsProvider.editJobImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (job) {
      changeIsLoading(false);
      jobsProvider.editJob(job);
      resetAllData();
      Dialogs.showBottomSheetMessage(
        context: context,
        message: Methods.getText(StringsManager.modifiedSuccessfully, appProvider.isEnglish).toTitleCase(),
        showMessage: ShowMessage.success,
        thenMethod: () {
          Navigator.pop(context);
        },
      );
    });
  }

  Future<bool> onBackPressed() {
    resetAllData();
    return Future.value(true);
  }
}