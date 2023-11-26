import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/presentation/features/transactions/booking_appointments/controllers/booking_appointments_provider.dart';
import 'package:fahem_business/presentation/features/transactions/booking_appointments/widgets/booking_appointment_item.dart';
import 'package:fahem_business/presentation/shared/load_more.dart';
import 'package:fahem_business/presentation/shared/my_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingAppointmentsScreen extends StatefulWidget {

  const BookingAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<BookingAppointmentsScreen> createState() => _BookingAppointmentsScreenState();
}

class _BookingAppointmentsScreenState extends State<BookingAppointmentsScreen> {
  late AppProvider appProvider;
  late BookingAppointmentsProvider bookingAppointmentsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    bookingAppointmentsProvider = Provider.of<BookingAppointmentsProvider>(context, listen: false);

    bookingAppointmentsProvider.setSelectedBookingAppointments(bookingAppointmentsProvider.bookingAppointments);
    bookingAppointmentsProvider.initScrollController();
    bookingAppointmentsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingAppointmentsProvider>(
      builder: (context, provider, _) {
        return MyTemplate(
          pageTitle: StringsManager.bookingAppointments,
          isSupportSearch: true,
          labelText: StringsManager.searchByNameOrReservationDate,
          onChanged: (val) => provider.onChangeSearch(context, val.trim()),
          onClearSearch: () => provider.onClearSearch(),
          notFoundMessage: StringsManager.thereAreNoBookingAppointments,
          list: provider.selectedBookingAppointments,
          listItemCount: provider.numberOfItems,
          scrollController: provider.scrollController,
          itemBuilder: (context, index) {
            return Column(
              children: [
                BookingAppointmentItem(bookingAppointment: provider.selectedBookingAppointments[index], index: index),
                if(index == provider.numberOfItems-1) LoadMore(hasMoreData: provider.hasMoreData, dataLength: provider.selectedBookingAppointments.length, limit: provider.limit),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    bookingAppointmentsProvider.disposeScrollController();
    super.dispose();
  }
}