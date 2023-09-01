import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../function/helper.dart';
import '../../../views/appbar/navtxt.dart';
import '../../../controller/searchDomisiliController.dart';
import '../../widgets/info.dart';

class SearchDomisili extends StatelessWidget {
  final SearchDomisiliController controller = Get.put(SearchDomisiliController());
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
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: controller.searchController,
                  onChanged: (text) {
                    controller.search(text);
                  },
                  decoration: InputDecoration(
                    hintText: "Cari kota Anda saat ini",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.all(0),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 0)),
                    filled: true,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Obx(
                () {
                  if (controller.hasLoad.value == false && !controller.hasError.value != true) {
                    print("kondisi 1");
                    return Text(
                      "Mohon Tunggu",
                      textAlign: TextAlign.center,
                    );
                  }
                  if (controller.hasError.value == true) {
                    print("kondisi 2");
                    print("controller.hasError.value: ${controller.errorMessage.value} ");
                    
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
                    print("kondisi 3");
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
                  return Container(
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
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey[300]!))),
          child: Text(
            "$domisili",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        ListView.builder(
          itemCount: city.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  Navigator.pop(context, city[index]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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