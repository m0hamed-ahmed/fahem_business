import 'package:fahem_business/core/resources/strings_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/presentation/features/transactions/request_the_phone_number/controllers/request_the_phone_number_provider.dart';
import 'package:fahem_business/presentation/features/transactions/request_the_phone_number/widgets/request_the_phone_number_item.dart';
import 'package:fahem_business/presentation/shared/load_more.dart';
import 'package:fahem_business/presentation/shared/my_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestThePhoneNumberScreen extends StatefulWidget {

  const RequestThePhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<RequestThePhoneNumberScreen> createState() => _RequestThePhoneNumberScreenState();
}

class _RequestThePhoneNumberScreenState extends State<RequestThePhoneNumberScreen> {
  late AppProvider appProvider;
  late RequestThePhoneNumberProvider requestThePhoneNumberProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    requestThePhoneNumberProvider = Provider.of<RequestThePhoneNumberProvider>(context, listen: false);

    requestThePhoneNumberProvider.setSelectedRequestThePhoneNumber(requestThePhoneNumberProvider.requestThePhoneNumber);
    requestThePhoneNumberProvider.initScrollController();
    requestThePhoneNumberProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestThePhoneNumberProvider>(
      builder: (context, provider, _) {
        return MyTemplate(
          pageTitle: StringsManager.requestThePhoneNumber,
          isSupportSearch: true,
          labelText: StringsManager.searchByName,
          onChanged: (val) => provider.onChangeSearch(context, val.trim()),
          onClearSearch: () => provider.onClearSearch(),
          notFoundMessage: StringsManager.thereAreNoRequestThePhoneNumber,
          list: provider.selectedRequestThePhoneNumber,
          listItemCount: provider.numberOfItems,
          scrollController: provider.scrollController,
          itemBuilder: (context, index) {
            return Column(
              children: [
                RequestThePhoneNumberItem(requestThePhoneNumber: provider.selectedRequestThePhoneNumber[index], index: index),
                if(index == provider.numberOfItems-1) LoadMore(hasMoreData: provider.hasMoreData, dataLength: provider.selectedRequestThePhoneNumber.length, limit: provider.limit),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    requestThePhoneNumberProvider.disposeScrollController();
    super.dispose();
  }
}