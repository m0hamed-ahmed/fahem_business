import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/data/models/transactions/transaction_model.dart';
import 'package:fahem_business/domain/usecases/booking_appointments/get_booking_appointments_for_target__usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingAppointmentsProvider with ChangeNotifier {
  final GetBookingAppointmentsForTargetUseCase _getBookingAppointmentsForTargetUseCase;

  BookingAppointmentsProvider(this._getBookingAppointmentsForTargetUseCase);

  Future<Either<Failure, List<TransactionModel>>> getBookingAppointmentsForTargetImpl(GetBookingAppointmentsForTargetParameters parameters) async {
    return await _getBookingAppointmentsForTargetUseCase.call(parameters);
  }

  List<TransactionModel> _bookingAppointments = [];
  List<TransactionModel> get bookingAppointments => _bookingAppointments;
  setBookingAppointments(List<TransactionModel> bookingAppointments) => _bookingAppointments = bookingAppointments;

  List<TransactionModel> _selectedBookingAppointments = [];
  List<TransactionModel> get selectedBookingAppointments => _selectedBookingAppointments;
  setSelectedBookingAppointments(List<TransactionModel> selectedBookingAppointments) => _selectedBookingAppointments = selectedBookingAppointments;
  changeSelectedBookingAppointments(List<TransactionModel> selectedBookingAppointments) {
    _selectedBookingAppointments = selectedBookingAppointments;
    showDataInList(isResetData: true, isRefresh: true, isScrollUp: true);
    notifyListeners();
  }

  void onChangeSearch(BuildContext context, String val) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    changeSelectedBookingAppointments(_bookingAppointments.where((bookingAppointments) {
      String text = appProvider.isEnglish ? bookingAppointments.textEn : bookingAppointments.textAr;
      return bookingAppointments.name.toLowerCase().contains(val.toLowerCase())
          || text.toLowerCase().contains(val.toLowerCase());
    }).toList());
  }

  void onClearSearch() {
    changeSelectedBookingAppointments(_bookingAppointments);
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
      List list = _selectedBookingAppointments;
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