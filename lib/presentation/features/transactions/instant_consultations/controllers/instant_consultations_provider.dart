import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/instant_consultations_comments/instant_consultation_comment_model.dart';
import 'package:fahem_business/data/models/transactions/transaction_model.dart';
import 'package:fahem_business/domain/usecases/instant_consultations/get_all_instant_consultations_for_lawyer_usecase.dart';
import 'package:fahem_business/domain/usecases/instant_consultations_comments/insert_instant_consultation_comment_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstantConsultationsProvider with ChangeNotifier {
  final GetAllInstantConsultationsForLawyerUseCase _getAllInstantConsultationsForLawyerUseCase;
  final InsertInstantConsultationCommentUseCase _insertInstantConsultationCommentUseCase;

  InstantConsultationsProvider(this._getAllInstantConsultationsForLawyerUseCase, this._insertInstantConsultationCommentUseCase);

  Future<Either<Failure, List<TransactionModel>>> getAllInstantConsultationsForLawyerImpl(GetAllInstantConsultationsForLawyerParameters parameters) async {
    return await _getAllInstantConsultationsForLawyerUseCase.call(parameters);
  }

  Future<Either<Failure, InstantConsultationCommentModel>> insertInstantConsultationCommentImpl(InsertInstantConsultationCommentParameters parameters) async {
    return await _insertInstantConsultationCommentUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  List<TransactionModel> _instantConsultations = [];
  List<TransactionModel> get instantConsultations => _instantConsultations;
  setInstantConsultations(List<TransactionModel> instantConsultations) => _instantConsultations = instantConsultations;

  List<TransactionModel> _selectedInstantConsultations = [];
  List<TransactionModel> get selectedInstantConsultations => _selectedInstantConsultations;
  setSelectedInstantConsultations(List<TransactionModel> selectedInstantConsultations) => _selectedInstantConsultations = selectedInstantConsultations;
  changeSelectedInstantConsultations(List<TransactionModel> selectedInstantConsultations) {
    _selectedInstantConsultations = selectedInstantConsultations;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  void onChangeSearch(BuildContext context, String val) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Methods.getText(StringsManager.consultationClosed, appProvider.isEnglish).toLowerCase();
    changeSelectedInstantConsultations(_instantConsultations.where((instantConsultation) {
      String text = appProvider.isEnglish ? instantConsultation.textEn : instantConsultation.textAr;

      return instantConsultation.name.toLowerCase().contains(val.toLowerCase())
          || text.toLowerCase().contains(val.toLowerCase())
          || (instantConsultation.isDoneInstantConsultation == null && Methods.getText(StringsManager.available, appProvider.isEnglish).toLowerCase().contains(val.toLowerCase()))
          || (instantConsultation.isDoneInstantConsultation == null && Methods.getText(StringsManager.available, true).toLowerCase().contains(val.toLowerCase()))
          || (instantConsultation.isDoneInstantConsultation != null && Methods.getText(StringsManager.consultationClosed, appProvider.isEnglish).toLowerCase().contains(val.toLowerCase()))
          || (instantConsultation.isDoneInstantConsultation != null && Methods.getText(StringsManager.consultationClosed, true).toLowerCase().contains(val.toLowerCase()));
    }).toList());
  }

  void onClearSearch() {
    changeSelectedInstantConsultations(_instantConsultations);
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
      List list = _selectedInstantConsultations;
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