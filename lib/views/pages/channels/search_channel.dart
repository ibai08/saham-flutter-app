// ignore_for_file: prefer_is_empty, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../constants/app_colors.dart';
import '../../../controller/search_controller.dart';
import '../../../function/sort_channel_modal.dart';
import '../../appbar/nav_channel.dart';

class SearchChannelsTab extends StatelessWidget {
  final SearchChannelsTabController searchChannelsTabController =
      Get.put(SearchChannelsTabController());
  final SearchChannelsResultController? searchChannelsResultController =
      Get.put(SearchChannelsResultController());
  final SearchSignalResultController searchSignalResultController =
      Get.put(SearchSignalResultController());

  SearchChannelsTab({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    String? findText = ModalRoute.of(context)?.settings.arguments.toString();
    searchSignalResultController.setFindTxt(findText!);
    searchChannelsResultController?.setFindTxt(findText);
    return Scaffold(
      appBar: NavChannel(
        context: context,
        state: NavChannelState.none,
        text: findText,
        popTo: '/search/channels/pop',
      ),
      backgroundColor: AppColors.light,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: searchChannelsTabController.scrollController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: false,
                floating: false,
                snap: false,
                forceElevated: true,
                backgroundColor: AppColors.light,
                leading: const Icon(
                  Icons.ac_unit,
                  color: Colors.transparent,
                ),
                flexibleSpace: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TabBar(
                      isScrollable: true,
                      labelColor: Colors.black,
                      unselectedLabelStyle: const TextStyle(fontSize: 16),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: AppColors.primaryGreen,
                      tabs: const <Widget>[
                        Tab(
                          text: "Signal",
                        ),
                        Tab(
                          text: "Channels",
                        )
                      ],
                      controller: searchChannelsTabController.tabController,
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              SearchSignalResult(findText: findText),
              SearchChannelsResult(findText: findText)
            ],
            controller: searchChannelsTabController.tabController,
          ),
        ),
      ),
    );
  }
}

class SearchChannelsResult extends StatelessWidget {
  final SearchChannelsResultController? searchChannelsResultController =
      Get.find();

  final String? findText;

  SearchChannelsResult({Key? key, this.findText}) : super(key: key);

  bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    // print("find text channelll: $findText");
    
    return Obx(() {
      // print("testststst datat: ${searchChannelsResultController?.channelSearchResult}");
      // print("bool: ${searchChannelsResultController?.channelSearchResult.isEmpty}");
      // print("bool2: ${searchChannelsResultController?.channelSearchResult.length == 0}");
      if (searchChannelsResultController!.channelSearchResult.isEmpty &&
          searchChannelsResultController!.hasError.value == false) {
        return const Center(
            child: Text(
          "Tunggu ya..!!",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ));
      }
      if (searchChannelsResultController?.channelSearchResult.length == 0 &&
          searchChannelsResultController!.channelSearchResult.isEmpty) {
        return const Center(
            child: Text(
          "Maaf.. data tidak ditemukan",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ));
      }
      return Stack(children: [
        SmartRefresher(
          enablePullDown: false,
          enablePullUp:
              searchChannelsResultController!.channelSearchResult.length > 4
                  ? true
                  : false,
          controller: searchChannelsResultController!.refreshController,
          onLoading: searchChannelsResultController!.onLoading,
          child: ListView(
            children: searchChannelsResultController!.getChannels(
                searchChannelsResultController!.channelSearchResult),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: AppColors.primaryGreen,
            elevation: 8,
            onPressed: () async {
              int? res = await showSortChannelModal(
                  context, searchChannelsResultController!.sort);
              if (res != null && res != searchChannelsResultController!.sort) {
                searchChannelsResultController!.sort = res;
                searchChannelsResultController!.listChannel.clear();
                searchChannelsResultController!.channelSearchResult.addAll([]);
                await searchChannelsResultController!.onLoading();
              }
            },
            child: const Icon(
              Icons.sort,
              color: Colors.white,
            ),
          ),
        )
      ]);
    });
  }
}

class SearchSignalResult extends StatelessWidget {
  final SearchSignalResultController searchSignalResultController =
      Get.find();

  final String? findText;

  SearchSignalResult({Key? key, this.findText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("find text signall: $findText");
    // searchSignalResultController.setFindTxt(findText!);
      return Obx( () {
        // print("length.: ${searchSignalResultController.signalSearchResult?.length == 0 && searchSignalResultController.signalSearchResult!.isEmpty}");
        if (searchSignalResultController.signalSearchResult!.isEmpty && searchSignalResultController.hasError.value == false) {
          return const Center(
            child: Text(
              "Tunggu ya..!!",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          );
        }
        if (searchSignalResultController.signalSearchResult?.length == 0 && searchSignalResultController.signalSearchResult!.isEmpty) {
          return const Center(
            child: Text(
              "Maaf.. data tidak ditemukan",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          );
        }
        return SmartRefresher(
          enablePullDown: false,
          enablePullUp:
              searchSignalResultController.signalSearchResult!.length > 4
                  ? true
                  : false,
          controller: searchSignalResultController.refreshController,
          onLoading: searchSignalResultController.onLoading,
          child: ListView(
            children: searchSignalResultController
                .getSignals(searchSignalResultController.signalSearchResult!),
          ),
        );
      }
      );
  }
}