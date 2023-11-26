import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/data/models/static/main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainItem extends StatefulWidget {
  final MainModel mainModel;

  const MainItem({Key? key, required this.mainModel}) : super(key: key);

  @override
  State<MainItem> createState() => _MainItemState();
}

class _MainItemState extends State<MainItem> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !Methods.isAccountAcceptable(),
      child: Opacity(
        opacity: Methods.isAccountAcceptable() ? 1 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: ColorsManager.white,
            border: Border.all(color: ColorsManager.grey300),
            borderRadius: BorderRadius.circular(SizeManager.s10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async => Navigator.pushNamed(context, widget.mainModel.route),
              borderRadius: BorderRadius.circular(SizeManager.s10),
              child: Padding(
                padding: const EdgeInsets.all(SizeManager.s10),
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: SizeManager.s60,
                        maxHeight: SizeManager.s60,
                      ),
                      child: Image.asset(widget.mainModel.image),
                    ),
                    const SizedBox(height: SizeManager.s10),
                    FittedBox(
                      child: Text(
                        appProvider.isEnglish ? widget.mainModel.textEn : widget.mainModel.textAr,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.semiBold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}