// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/constants/channel_sort.dart';
import 'package:saham_01_app/views/widgets/btnBlock.dart';
import 'package:saham_01_app/views/widgets/btnShort.dart';
import 'package:saham_01_app/views/widgets/btnSortNew.dart';

class SortChannelController extends GetxController {
  var sort = 0.obs;

  void setSort(int value) {
    sort.value = value;
  }
}

Future<dynamic> showSortChannelModal(BuildContext context, int initialSort) {
  final sortController = Get.put(SortChannelController());
  sortController.setSort(initialSort);

  return showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Urutkan Channel Berdasarkan",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const SizedBox(height: 5),
                Wrap(
                  children: sortMap
                      .asMap()
                      .entries
                      .map((e) => SortButton(
                            onTap: () {
                              sortController.setSort(e.key);
                            },
                            text: e.value['title'],
                            isActive: sortController.sort.value == e.key ||
                                (e.key == 0 && sortController.sort.value == null),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
          Positioned(
            top: 3,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: BtnBlock(
                width: MediaQuery.of(context).size.width - 50,
                onTap: () {
                  Navigator.pop(context, sortController.sort.value);
                },
                title: "Urutkan",
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class SortButtonsWidget extends StatelessWidget {
  final int? activeSortIndex;
  final Function(int)? onSortChanged;

  const SortButtonsWidget({Key? key, 
    @required this.activeSortIndex,
    @required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sortMap
            .asMap()
            .entries
            .map((e) => SortButtonNew(
                  onTap: () {
                    onSortChanged!(e.key);
                  },
                  text: e.value['title'],
                  isActive: activeSortIndex == e.key ||
                      (e.key == 0 && activeSortIndex == null),
                ))
            .toList(),
      ),
    );
  }
}