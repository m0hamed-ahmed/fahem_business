import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/presentation/features/transactions/instant_consultations/controllers/instant_consultations_provider.dart';
import 'package:fahem_business/presentation/features/transactions/instant_consultations/widgets/instant_consultation_item.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/load_more.dart';
import 'package:fahem_business/presentation/shared/my_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstantConsultationsScreen extends StatefulWidget {
  
  const InstantConsultationsScreen({Key? key}) : super(key: key);

  @override
  State<InstantConsultationsScreen> createState() => _InstantConsultationsScreenState();
}

class _InstantConsultationsScreenState extends State<InstantConsultationsScreen> {
  late AppProvider appProvider;
  late InstantConsultationsProvider instantConsultationsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    instantConsultationsProvider = Provider.of<InstantConsultationsProvider>(context, listen: false);

    instantConsultationsProvider.setSelectedInstantConsultations(instantConsultationsProvider.instantConsultations);
    instantConsultationsProvider.initScrollController();
    instantConsultationsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InstantConsultationsProvider>(
      builder: (context, provider, _) {
        return AbsorbPointerWidget(
          absorbing: provider.isLoading,
          child: MyTemplate(
            pageTitle: StringsManager.instantConsultations,
            isSupportSearch: true,
            labelText: StringsManager.searchByName,
            onChanged: (val) => provider.onChangeSearch(context, val.trim()),
            onClearSearch: () => provider.onClearSearch(),
            notFoundMessage: StringsManager.thereAreNoInstantConsultations,
            list: provider.selectedInstantConsultations,
            listItemCount: provider.numberOfItems,
            scrollController: provider.scrollController,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InstantConsultationItem(instantConsultation: provider.selectedInstantConsultations[index], index: index),
                  if(index == provider.numberOfItems-1) LoadMore(hasMoreData: provider.hasMoreData, dataLength: provider.selectedInstantConsultations.length, limit: provider.limit),
                ],
              );
            },
            isLoading: provider.isLoading,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    instantConsultationsProvider.disposeScrollController();
    super.dispose();
  }
}