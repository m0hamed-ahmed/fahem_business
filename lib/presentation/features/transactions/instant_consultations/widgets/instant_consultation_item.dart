import 'package:animate_do/animate_do.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/dialogs.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/transactions/transaction_model.dart';
import 'package:fahem_business/presentation/features/lawyer/lawyer/controllers/lawyer_provider.dart';
import 'package:fahem_business/presentation/features/transactions/instant_consultations/controllers/instant_consultations_provider.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstantConsultationItem extends StatefulWidget {
  final TransactionModel instantConsultation;
  final int index;

  const InstantConsultationItem({Key? key, required this.instantConsultation, required this.index}) : super(key: key);

  @override
  State<InstantConsultationItem> createState() => _InstantConsultationItemState();
}

class _InstantConsultationItemState extends State<InstantConsultationItem> {
  late AppProvider appProvider;
  late InstantConsultationsProvider instantConsultationsProvider;
  late LawyerProvider lawyerProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    instantConsultationsProvider = Provider.of<InstantConsultationsProvider>(context, listen: false);
    lawyerProvider = Provider.of<LawyerProvider>(context, listen: false);
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
                widget.instantConsultation.name,
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
                widget.instantConsultation.phoneNumber,
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
                widget.instantConsultation.emailAddress ?? '-',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            ListTile(
              title: Text(
                Methods.getText(StringsManager.consultation, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.black),
              ),
              subtitle: Text(
                appProvider.isEnglish ? widget.instantConsultation.textEn : widget.instantConsultation.textAr,
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
                Methods.formatDate(context: context, milliseconds: widget.instantConsultation.createdAt.millisecondsSinceEpoch),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            IgnorePointer(
              ignoring: widget.instantConsultation.isDoneInstantConsultation != null ? true : false,
              child: Opacity(
                opacity: widget.instantConsultation.isDoneInstantConsultation != null ? 0.5 : 1,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
                  child: CustomButton(
                    buttonType: ButtonType.text,
                    onPressed: () {
                      Dialogs.replyToTheConsultationDialog(
                        context: context,
                        transactionId: widget.instantConsultation.transactionId,
                        lawyerId: lawyerProvider.lawyer.lawyerId,
                        lawyerName: lawyerProvider.lawyer.name,
                        userAccountId: widget.instantConsultation.userAccountId,
                      );
                    },
                    text: Methods.getText(widget.instantConsultation.isDoneInstantConsultation != null ? StringsManager.consultationClosed : StringsManager.replyToTheConsultation, appProvider.isEnglish).toTitleCase(),
                    height: SizeManager.s35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}