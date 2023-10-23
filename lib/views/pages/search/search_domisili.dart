import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../views/appbar/navtxt.dart';
import '../../../controller/search_domisili_controller.dart';
import '../../widgets/info.dart';

class SearchDomisili extends StatelessWidget {
  final SearchDomisiliController controller = Get.put(SearchDomisiliController());

  SearchDomisili({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: NavTxt(
          title: "Cari Kota",
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: controller.searchController,
                  onChanged: (text) {
                    controller.search(text);
                  },
                  decoration: InputDecoration(
                    hintText: "Cari kota Anda saat ini",
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.all(0),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 0)),
                    filled: true,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Obx(
                () {
                  if (controller.hasLoad.value == false && !controller.hasError.value != true) {
                    return const Text(
                      "Mohon Tunggu",
                      textAlign: TextAlign.center,
                    );
                  }
                  if (controller.hasError.value == true) {
                    return ListView(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15),
                      shrinkWrap: true,
                      children: [
                        Info(
                            title: "Terjadi Kesalahan",
                            desc: controller.errorMessage.value,
                            onTap: controller.onRefresh
                        ),
                      ],
                    );
                  }
                  if (controller.listcon.isEmpty) {
                    return ListView(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15),
                      shrinkWrap: true,
                      children: [
                        Info(
                            title: "Terjadi Kesalahan",
                            desc: "Kota Anda tidak ditemukan",
                            onTap: controller.onRefresh
                        ),
                      ],
                    );
                  }
                  List<GroupedCity> listGc = [];
                  controller.listcon.forEach((k, v) {
                    listGc.add(GroupedCity(domisili: k, city: v));
                  });
                  return SizedBox(
                    height:MediaQuery.of(context).size.height -
                        160 -
                        MediaQuery.of(context).viewInsets.bottom,
                    child: SafeArea(
                      child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: false,
                        controller: controller.refreshController,
                        onRefresh: controller.onRefresh,
                        child: ListView(
                          shrinkWrap: true,
                          children: listGc,
                        ),
                      )
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      );
  }
}

class GroupedCity extends StatelessWidget {
  const GroupedCity({
    Key? key,
    required this.domisili,
    required this.city,
  }) : super(key: key);

  final String domisili;
  final List city;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey[300]!))),
          child: Text(
            domisili,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        ListView.builder(
          itemCount: city.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  Navigator.pop(context, city[index]);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Colors.grey[300]!))),
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.grey[700],
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Text('${city[index]["name"]}'),
                    )
                  ]),
                ));
          },
        )
      ],
    );
  }
}