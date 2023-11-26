import 'package:animate_do/animate_do.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/transactions/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingAppointmentItem extends StatefulWidget {
  final TransactionModel bookingAppointment;
  final int index;

  const BookingAppointmentItem({Key? key, required this.bookingAppointment, required this.index}) : super(key: key);

  @override
  State<BookingAppointmentItem> createState() => _BookingAppointmentItemState();
}

class _BookingAppointmentItemState extends State<BookingAppointmentItem> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
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
                widget.bookingAppointment.name,
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
                widget.bookingAppointment.phoneNumber,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            ListTile(
              title: Text(
                Methods.getText(StringsManager.emailAddress, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.black),
              ),
              subtitle: Text(
                widget.bookingAppointment.emailAddress ?? '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            ListTile(
              title: Text(
                Methods.getText(StringsManager.bookingPeriod, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.black),
              ),
              subtitle: Text(
                appProvider.isEnglish ? widget.bookingAppointment.textEn : widget.bookingAppointment.textAr,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            ListTile(
              title: Text(
                Methods.getText(StringsManager.bookingDate, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.black),
              ),
              subtitle: Text(
                Methods.formatDate(context: context, milliseconds: int.parse(widget.bookingAppointment.bookingDateTimeStamp!)),
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
                Methods.formatDate(context: context, milliseconds: widget.bookingAppointment.createdAt.millisecondsSinceEpoch),
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