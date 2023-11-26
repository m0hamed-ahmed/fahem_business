import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/data/models/transactions/transaction_model.dart';
import 'package:fahem_business/domain/usecases/transaction_type_show_numbers/get_transaction_type_show_numbers_for_target_usecase.dart';
import 'package:flutter/material.dart';

class RequestThePhoneNumberProvider with ChangeNotifier {
  final GetRequestThePhoneNumberForTargetUseCase _getRequestThePhoneNumberForTargetUseCase;

  RequestThePhoneNumberProvider(this._getRequestThePhoneNumberForTargetUseCase);

  Future<Either<Failure, List<TransactionModel>>> getRequestThePhoneNumberForTargetImpl(GetRequestThePhoneNumberForTargetParameters parameters) async {
    return await _getRequestThePhoneNumberForTargetUseCase.call(parameters);
  }

  List<TransactionModel> _requestThePhoneNumber = [];
  List<TransactionModel> get requestThePhoneNumber => _requestThePhoneNumber;
  setRequestThePhoneNumber(List<TransactionModel> requestThePhoneNumber) => _requestThePhoneNumber = requestThePhoneNumber;

  List<TransactionModel> _selectedRequestThePhoneNumber = [];
  List<TransactionModel> get selectedRequestThePhoneNumber => _selectedRequestThePhoneNumber;
  setSelectedRequestThePhoneNumber(List<TransactionModel> selectedRequestThePhoneNumber) => _selectedRequestThePhoneNumber = selectedRequestThePhoneNumber;
  changeSelectedRequestThePhoneNumber(List<TransactionModel> selectedRequestThePhoneNumber) {
    _selectedRequestThePhoneNumber = selectedRequestThePhoneNumber;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  void onChangeSearch(BuildContext context, String val) {
    changeSelectedRequestThePhoneNumber(_requestThePhoneNumber.where((requestThePhoneNumber) {
      return requestThePhoneNumber.name.toLowerCase().contains(val.toLowerCase());
    }).toList());
  }

  void onClearSearch() {
    changeSelectedRequestThePhoneNumber(_requestThePhoneNumber);
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
      List list = _selectedRequestThePhoneNumber;
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