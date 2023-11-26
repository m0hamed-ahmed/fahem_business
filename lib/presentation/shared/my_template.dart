import 'package:fahem_business/core/resources/values_manager.dart';
import 'package:fahem_business/core/utils/app_provider.dart';
import 'package:fahem_business/core/utils/methods.dart';
import 'package:fahem_business/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem_business/presentation/shared/background.dart';
import 'package:fahem_business/presentation/shared/my_header.dart';
import 'package:fahem_business/presentation/shared/not_found.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTemplate extends StatefulWidget {
  final String pageTitle;
  final bool isSupportSearch;
  final String? labelText;
  final void Function(String)? onChanged;
  final Function? onClearSearch;
  final String notFoundMessage;
  final Widget? Function(BuildContext, int) itemBuilder;
  final List list;
  final int? listItemCount;
  final ScrollController? scrollController;
  final bool isLoading;
  final String? addRoute;

  const MyTemplate({
    Key? key,
    required this.pageTitle,
    this.isSupportSearch = false,
    this.labelText,
    this.onChanged,
    this.onClearSearch,
    required this.notFoundMessage,
    required this.list,
    required this.listItemCount,
    this.scrollController,
    required this.itemBuilder,
    this.isLoading = false,
    this.addRoute,
  }) : super(key: key);

  @override
  State<MyTemplate> createState() => _MyTemplateState();
}

class _MyTemplateState extends State<MyTemplate> {
  late AppProvider appProvider;

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
        return AbsorbPointerWidget(
          absorbing: widget.isLoading,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: WillPopScope(
              onWillPop: () => Future.value(!widget.isLoading),
              child: Directionality(
                textDirection: Methods.getDirection(appProvider.isEnglish),
                child: Scaffold(
                  body: Background(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(SizeManager.s16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyHeader(
                              title: widget.pageTitle,
                              isSupportSearch: widget.isSupportSearch,
                              labelText: widget.labelText,
                              onChanged: widget.onChanged,
                              onClearSearch: widget.onClearSearch,
                              resultsLength: widget.list.length,
                            ),
                            Expanded(
                              child: widget.list.isEmpty ? NotFound(notFoundMessage: widget.notFoundMessage) : ListView.separated(
                                controller: widget.scrollController,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(top: SizeManager.s8, bottom: SizeManager.s16),
                                itemBuilder: widget.itemBuilder,
                                separatorBuilder: (context, index) => const SizedBox(height: SizeManager.s10),
                                itemCount: widget.listItemCount ?? widget.list.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton:widget.addRoute == null ? null : FloatingActionButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pushNamed(context, widget.addRoute!);
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}