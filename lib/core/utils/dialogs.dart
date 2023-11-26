import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fahem_business/core/error/failure.dart';
import 'package:fahem_business/core/network/firebase_constants.dart';
import 'package:fahem_business/core/resources/assets_manager.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/constants_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/services/notification_service.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/enums.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/core/utils/validator.dart';
import 'package:fahem_business/data/models/instant_consultations_comments/instant_consultation_comment_model.dart';
import 'package:fahem_business/domain/usecases/instant_consultations_comments/insert_instant_consultation_comment_usecase.dart';
import 'package:fahem_business/presentation/features/transactions/instant_consultations/controllers/instant_consultations_provider.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/custom_button.dart';
import 'package:fahem_business/presentation/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Dialogs {

  static Future<bool> showUpdateDialog(BuildContext context, String title, String text, {bool isMustUpdate = false}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return (
      await (showDialog(
        context: context,
        barrierDismissible: !isMustUpdate,
        builder: (context) => WillPopScope(
          onWillPop: () async => !isMustUpdate,
          child: Directionality(
            textDirection: Methods.getDirection(appProvider.isEnglish),
            child: AlertDialog(
              backgroundColor: ColorsManager.grey1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeManager.s10)),
              title: Text(
                Methods.getText(title, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
              ),
              titlePadding: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, top: SizeManager.s16, bottom: SizeManager.s8),
              content: Text(
                Methods.getText(text, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              contentPadding: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, bottom: SizeManager.s8),
              actionsPadding: const EdgeInsets.all(SizeManager.s16),
              actions: [
                if(!isMustUpdate) TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    backgroundColor: ColorsManager.grey300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeManager.s10)),
                  ),
                  child: Text(
                    Methods.getText(StringsManager.updateLater, appProvider.isEnglish).toCapitalized(),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeightManager.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    backgroundColor: ColorsManager.red700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeManager.s10)),
                  ),
                  child: Text(
                    Methods.getText(StringsManager.updateNow, appProvider.isEnglish).toCapitalized(),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ))
    ) ?? false;
  }

  static Future<void> _showBottomSheet({required BuildContext context, required Widget child, Function? thenMethod}) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      barrierColor: ColorsManager.black.withOpacity(0.8),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(SizeManager.s30),
          topEnd: Radius.circular(SizeManager.s30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Directionality(
            textDirection: Methods.getDirection(appProvider.isEnglish),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: SizeManager.s16, horizontal: SizeManager.s24),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) => thenMethod != null ? thenMethod() : null);
  }

  static Future<bool> showBottomSheetConfirmation({required BuildContext context, required String message, Function? thenMethod}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    bool result = false;

    await Dialogs._showBottomSheet(
      context: context,
      thenMethod: thenMethod,
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s18, fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(height: SizeManager.s20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonType: ButtonType.text,
                  onPressed: () {
                    Navigator.pop(context);
                    result = true;
                  },
                  text: Methods.getText(StringsManager.ok, appProvider.isEnglish).toUpperCase(),
                  height: SizeManager.s40,
                ),
              ),
              const SizedBox(width: SizeManager.s20),
              Expanded(
                child: CustomButton(
                  buttonType: ButtonType.text,
                  onPressed: () {
                    Navigator.pop(context);
                    result = false;
                  },
                  text: Methods.getText(StringsManager.cancel, appProvider.isEnglish).toUpperCase(),
                  height: SizeManager.s40,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Future.value(result);
  }

  static Widget messageWidget({required BuildContext context, required String message, ShowMessage showMessage = ShowMessage.failure}) {
    return Column(
      children: [
        Lottie.asset(
          showMessage == ShowMessage.success ? ImagesManager.animatedSuccess : ImagesManager.animatedFailure,
          width: showMessage == ShowMessage.success ? SizeManager.s200 : SizeManager.s150,
          height: showMessage == ShowMessage.success ? SizeManager.s200 : SizeManager.s150,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: SizeManager.s16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            color: showMessage == ShowMessage.success ? ColorsManager.success : ColorsManager.failure,
            fontSize: SizeManager.s20,
            fontWeight: FontWeightManager.bold,
          ),
        ),
      ],
    );
  }

  static Future<void> showBottomSheetMessage({required BuildContext context, required String message, ShowMessage showMessage = ShowMessage.failure, Function? thenMethod}) async {
    Timer timer = Timer(const Duration(seconds: ConstantsManager.bottomSheetClosedDuration), () => Navigator.pop(context));

    return Dialogs._showBottomSheet(
      context: context,
      thenMethod: () {
        if(thenMethod != null) thenMethod();
        timer.cancel();
      },
      child: messageWidget(context: context, message: message, showMessage: showMessage),
    );
  }

  static Future<void> failureOccurred(BuildContext context, Failure failure) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Dialogs.showBottomSheetMessage(
      context: context,
      message: appProvider.isEnglish ? failure.messageEn.toCapitalized() : failure.messageAr.toCapitalized(),
    );
  }

  static Future<void> showPermissionDialog({required BuildContext context, required String title, required String message}) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return Dialogs._showBottomSheet(
      context: context,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(ImagesManager.location, height: SizeManager.s200),
          ),
          Text(
            Methods.getText(title, appProvider.isEnglish).toCapitalized(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s24, fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(height: SizeManager.s10),
          Text(
            Methods.getText(message, appProvider.isEnglish).toCapitalized(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s18),
          ),
          const SizedBox(height: SizeManager.s10),
          CustomButton(
            buttonType: ButtonType.text,
            onPressed: () => Navigator.pop(context),
            text: Methods.getText(StringsManager.ok, appProvider.isEnglish).toUpperCase(),
          ),
        ],
      ),
    );
  }

  static Future<void> replyToTheConsultationDialog({
    required BuildContext context,
    required int transactionId,
    required int lawyerId,
    required String lawyerName,
    required int userAccountId,
  }) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController textEditingControllerReply = TextEditingController();
    bool isLoading = false;
    bool isDone = false;
    Timer? timer;

    Dialogs._showBottomSheet(
      context: context,
      thenMethod: () => timer?.cancel(),
      child: StatefulBuilder(
        builder: (context, setState) {
          return AbsorbPointerWidget(
            absorbing: isLoading,
            child: !isDone ? Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Methods.getText(StringsManager.typeYourReplyToTheInstantConsultation, appProvider.isEnglish).toCapitalized(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                  ),
                  const SizedBox(height: SizeManager.s20),
                  CustomTextFormField(
                    controller: textEditingControllerReply,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 5,
                    textDirection: Methods.getDirection(appProvider.isEnglish),
                    contentPadding: const EdgeInsets.all(SizeManager.s10),
                    suffixIcon: IconButton(
                      onPressed: () => textEditingControllerReply.clear(),
                      icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                    ),
                    validator: (val) {
                      if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                      return null;
                    },
                  ),
                  const SizedBox(height: SizeManager.s20),
                  CustomButton(
                    buttonType: ButtonType.text,
                    onPressed: () async {
                      InstantConsultationsProvider instantConsultationsProvider = Provider.of<InstantConsultationsProvider>(context, listen: false);
                      if(formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        InstantConsultationCommentModel instantConsultationCommentModel = InstantConsultationCommentModel(
                          instantConsultationCommentId: 0,
                          transactionId: transactionId,
                          lawyerId: lawyerId,
                          comment: textEditingControllerReply.text.trim(),
                          commentStatus: CommentStatus.pending,
                          createdAt: DateTime.now(),
                        );
                        InsertInstantConsultationCommentParameters parameters = InsertInstantConsultationCommentParameters(
                          instantConsultationCommentModel: instantConsultationCommentModel,
                        );
                        Either<Failure, InstantConsultationCommentModel> response = await instantConsultationsProvider.insertInstantConsultationCommentImpl(parameters);
                        response.fold((failure) async {
                          setState(() => isLoading = false);
                          Dialogs.failureOccurred(context, failure);
                        }, (instantConsultationComment) {
                          NotificationService.pushNotification(topic: FirebaseConstants.fahemAdminTopic, title: 'يوجد رد جديد من $lawyerName على استشارة فورية قم بمراجعة الرد الان', body: textEditingControllerReply.text.trim());
                          // NotificationService.pushNotification(topic: '$userAccountId${ConstantsManager.fahemKeyword}', title: 'الرد على الاستشارة الفورية', body: textEditingControllerReply.text.trim());
                          setState(() {
                            isLoading = false;
                            isDone = true;
                          });
                          timer = Timer(const Duration(seconds: ConstantsManager.bottomSheetClosedDuration), () => Navigator.pop(context));
                        });
                      }
                    },
                    text: Methods.getText(StringsManager.send, appProvider.isEnglish).toUpperCase(),
                  ),
                ],
              ),
            ) : messageWidget(
              context: context,
              message: Methods.getText(StringsManager.theReplyHasBeenSentSuccessfully, appProvider.isEnglish).toCapitalized(),
              showMessage: ShowMessage.success,
            ),
          );
        },
      ),
    );
  }
}