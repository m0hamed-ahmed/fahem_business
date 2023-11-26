import 'package:fahem_business/core/resources/assets_manager.dart';
import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/presentation/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHeader extends StatefulWidget {
  final String title;
  final bool isSupportSearch;
  final String? labelText;
  final void Function(String)? onChanged;
  final Function? onClearSearch;
  final int? resultsLength;
  final void Function()? onBackPressed;

  const MyHeader({
    Key? key,
    required this.title,
    this.isSupportSearch = false,
    this.labelText,
    this.onChanged,
    this.onClearSearch,
    this.resultsLength,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<MyHeader> createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  late AppProvider appProvider;
  final TextEditingController _textEditingControllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AppProvider, bool>(
      selector: (context, provider) => provider.isEnglish,
      builder: (context, isEnglish, _) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PreviousButton(onBackPressed: widget.onBackPressed),
                const SizedBox(width: SizeManager.s10),
                Expanded(
                  child: Text(
                    Methods.getText(widget.title, appProvider.isEnglish).toTitleCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                  ),
                ),
                const SizedBox(width: SizeManager.s10),
                GestureDetector(
                  onTap: () {
                    appProvider.changeIsEnglish(!appProvider.isEnglish);
                    FocusScope.of(context).unfocus();
                  },
                  child: Image.asset(appProvider.isEnglish ? ImagesManager.ar : ImagesManager.en, width: SizeManager.s35, height: SizeManager.s35),
                ),
              ],
            ),
            const SizedBox(height: SizeManager.s16),
            if(widget.isSupportSearch) CustomTextFormField(
              controller: _textEditingControllerSearch,
              textInputAction: TextInputAction.search,
              textDirection: Methods.getDirection(appProvider.isEnglish),
              labelText: widget.labelText == null ? null : Methods.getText(widget.labelText!, appProvider.isEnglish).toCapitalized(),
              onChanged: widget.onChanged,
              prefixIcon: Image.asset(ImagesManager.searchOutlineIc, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
              suffixIcon: IconButton(
                onPressed: () {
                  _textEditingControllerSearch.clear();
                  if(widget.onClearSearch != null) widget.onClearSearch!();
                },
                icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
              ),
            ),
            if(widget.isSupportSearch) const SizedBox(height: SizeManager.s16),
            if(widget.resultsLength != null) Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Methods.getText(StringsManager.results, appProvider.isEnglish).toCapitalized(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${widget.resultsLength} ${Methods.getText(StringsManager.result, appProvider.isEnglish)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            if(widget.resultsLength != null) const SizedBox(height: SizeManager.s8),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _textEditingControllerSearch.dispose();
    super.dispose();
  }
}

class _PreviousButton extends StatelessWidget {
  final void Function()? onBackPressed;

  const _PreviousButton({Key? key, this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeManager.s35,
      height: SizeManager.s35,
      decoration: const BoxDecoration(
        color: ColorsManager.primaryColor,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onBackPressed ?? () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(SizeManager.s35),
          child: const Icon(Icons.arrow_back_ios_rounded, color: ColorsManager.white, size: SizeManager.s20),
        ),
      ),
    );
  }
}