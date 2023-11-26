import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropDownWidget extends StatefulWidget {
  final String hint;
  final bool isRequired;
  final Color color;
  final Object? currentValue;
  final List<Object> valuesObject;
  final List<String> valuesText;
  final Function(Object?)? onChanged;

  const DropDownWidget({
    Key? key,
    required this.hint,
    required this.isRequired,
    this.color = ColorsManager.white,
    required this.currentValue,
    required this.valuesObject,
    required this.valuesText,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsetsDirectional.fromSTEB(SizeManager.s30, SizeManager.s0, SizeManager.s20, SizeManager.s0),
              decoration: BoxDecoration(
                color: widget.color,
                border: Border.all(color: widget.isRequired ? ColorsManager.red700 : ColorsManager.primaryColor),
                borderRadius: BorderRadius.circular(SizeManager.s15),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: widget.currentValue,
                  onChanged: widget.onChanged,
                  onTap: () => FocusScope.of(context).unfocus(),
                  dropdownColor: ColorsManager.grey100,
                  borderRadius: BorderRadius.circular(SizeManager.s10),
                  iconEnabledColor: ColorsManager.primaryColor,
                  hint: Text(
                    Methods.getText(widget.hint, appProvider.isEnglish).toCapitalized(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  items: List.generate(widget.valuesObject.length, (index) => DropdownMenuItem(
                    value: widget.valuesObject[index],
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: const EdgeInsets.all(SizeManager.s8),
                          child: Text(
                            widget.valuesText[index],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
              ),
            ),
            if(widget.currentValue != null) PositionedDirectional(
              top: -8,
              start: 45,
              child: Text(
                Methods.getText(widget.hint, appProvider.isEnglish).toCapitalized(),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: SizeManager.s10),
              ),
            ),
          ],
        ),
        if(widget.isRequired) const SizedBox(height: SizeManager.s5),
        if(widget.isRequired) Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeManager.s8),
          child: Text(
            Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized(),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.red700),
          ),
        ),
      ],
    );
  }
}