import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/searchControllers.dart';
import 'package:saham_01_app/views/appbar/navChannel.dart';

class SearchChannelsPop extends StatelessWidget {
  final SearchChannelsPopController controller = Get.put(SearchChannelsPopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Obx(() {
          String searchTxt = '';
          if (controller.searchText.isNotEmpty) {
            searchTxt = controller.searchText.value;
          }
          print("GetContext: ${Get.context}");
          return NavChannel(
            context: Get.context,
            state: NavChannelState.none,
            text: searchTxt,
          );
        }),
        preferredSize: const Size(double.infinity, 60),
      ),
      body: Container(
        height: double.infinity,
        child: Obx(() {
          print("searcglist: ${controller.searchList}");
          if (controller.searchList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            children: controller.searchList.map((String tile) {
              return GestureDetector(
                onTap: () {
                  Get.back(canPop: true);
                  Get.toNamed('/dsc/search', arguments: tile);
                },
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text(tile),
                  trailing: IconButton(
                    icon: Image.asset(
                      'assets/open-in-new.png',
                      width: 20,
                    ),
                    onPressed: () {
                      controller.updateSearchText(tile);
                    },
                  ),
                ),
              );
            }).toList()
          );
        }),
      ),
    );
  }
}