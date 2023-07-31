import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/app_colors.dart';
import '../../../../models/emiten.dart';

class EmitenCategory extends StatefulWidget {
  const EmitenCategory({Key? key}) : super(key: key);

  @override
  _EmitenCategoryState createState() => _EmitenCategoryState();
}

class _EmitenCategoryState extends State<EmitenCategory> {
  String activeButton = 'Most Active';
  List<Map<String, String?>> activeDataButton = [];

  Future<EmitenModels> getDataFromJson() async {
    String jsonString =
        await rootBundle.loadString('assets/dummy/emitenItem.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    return EmitenModels.fromJson(jsonData);
  }

  void setActiveButton(String buttonName) async {
    EmitenModels? emitenModels = await getDataFromJson();
    setState(() {
      activeButton = buttonName;
      if (buttonName == 'Most Active') {
        activeDataButton = emitenModels.mostActiveData?.map((data) => {
              'imageText': data.imageText,
              'name': data.name,
              'companyName': data.companyName,
              'rank': data.rank,
              'percentage': data.percentage,
            }).toList() ??
            [];
      } else if (buttonName == 'Top Gamer (by %)') {
        activeDataButton = emitenModels.topGamerData?.map((data) => {
              'imageText': data.imageText,
              'name': data.name,
              'companyName': data.companyName,
              'rank': data.rank,
              'percentage': data.percentage,
            }).toList() ??
            [];
      } else if (buttonName == 'Top Loser (by %)') {
        activeDataButton = emitenModels.topLoserData?.map((data) => {
              'imageText': data.imageText,
              'name': data.name,
              'companyName': data.companyName,
              'rank': data.rank,
              'percentage': data.percentage,
            }).toList() ??
            [];
      } else if (buttonName == 'Top Volume') {
        activeDataButton = emitenModels.topVolumeData?.map((data) => {
              'imageText': data.imageText,
              'name': data.name,
              'companyName': data.companyName,
              'rank': data.rank,
              'percentage': data.percentage,
            }).toList() ??
            [];
      } else {
        activeDataButton = emitenModels.mostActiveData?.map((data) => {
              'imageText': data.imageText,
              'name': data.name,
              'companyName': data.companyName,
              'rank': data.rank,
              'percentage': data.percentage,
            }).toList() ??
            [];
      }
    });
  }

  void _initData() async {
    EmitenModels emitenModels = await getDataFromJson();
    setState(() {
      activeDataButton = emitenModels.mostActiveData?.map((data) => {
            'imageText': data.imageText,
            'name': data.name,
            'companyName': data.companyName,
            'rank': data.rank,
            'percentage': data.percentage,
          }).toList() ??
          [];
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              CustomButtons('Most Active', activeButton, setActiveButton),
              const SizedBox(width: 10),
              CustomButtons('Top Gamer (by %)', activeButton, setActiveButton),
              const SizedBox(width: 10),
              CustomButtons('Top Loser (by %)', activeButton, setActiveButton),
              const SizedBox(width: 10),
              CustomButtons('Top Volume', activeButton, setActiveButton),
            ],
          ),
        ),
        const SizedBox(height: 10),
        EmitenItemsLooping(activeDataButton),
      ],
    );
  }
}

class CustomButtons extends StatelessWidget {
  final String buttonText;
  final String activeButton;
  final Function setActiveButton;

  const CustomButtons(this.buttonText, this.activeButton, this.setActiveButton, {Key? key}) : super(key: key);

  bool get isActive => buttonText == activeButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setActiveButton(buttonText);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color.fromRGBO(46, 42, 255, 0.5) : null,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: const Color.fromRGBO(53, 6, 153, 1.0))
              : Border.all(color: Colors.grey),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class EmitenItems extends StatelessWidget {
  final String imageText;
  final String name;
  final String companyName;
  final String rank;
  final String percentage;

  const EmitenItems(
    this.imageText,
    this.name,
    this.companyName,
    this.rank,
    this.percentage, {Key? key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
            child: Row(
              children: [
                SizedBox(
                  width: 45,
                  child: CircleAvatar(
                    child: Image.asset(imageText),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Manrope',
                        ),
                      ),
                      Text(
                        companyName,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 75),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rank,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Manrope',
                      ),
                    ),
                    Text(
                      percentage,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Manrope',
                        color: AppColors.textGreenLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmitenItemsLooping extends StatelessWidget {
  final List<Map<String, String?>> emitenData;

  // ignore: use_key_in_widget_constructors
  const EmitenItemsLooping(this.emitenData);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (emitenData.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: emitenData.length,
            itemBuilder: (context, index) {
              return EmitenItems(
                emitenData[index]['imageText'] ?? '',
                emitenData[index]['name'] ?? '',
                emitenData[index]['companyName'] ?? '',
                emitenData[index]['rank'] ?? '',
                emitenData[index]['percentage'] ?? '',
              );
            },
          )
      ],
    );
  }
}

