import 'package:fahem_business/core/resources/colors_manager.dart';
import 'package:fahem_business/core/resources/fonts_manager.dart';
import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/extensions.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadMore extends StatefulWidget {
  final bool hasMoreData;
  final int dataLength;
  final int limit;

  const LoadMore({super.key, required this.hasMoreData, required this.dataLength, required this.limit});

  @override
  State<LoadMore> createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: SizeManager.s16),
      child: Column(
        children: [
          if(widget.hasMoreData) const Center(
            child: SizedBox(
              width: SizeManager.s20,
              height: SizeManager.s20,
              child: CircularProgressIndicator(strokeWidth: SizeManager.s3, color: ColorsManager.primaryColor),
            ),
          ),
          if(!widget.hasMoreData && widget.dataLength > widget.limit) Text(
            Methods.getText(StringsManager.thereAreNoOtherResults, appProvider.isEnglish).toCapitalized(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeightManager.black),
          ),
        ],
      ),
    );
  }
}