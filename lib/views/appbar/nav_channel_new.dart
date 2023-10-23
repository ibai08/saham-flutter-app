// ignore_for_file: prefer_function_declarations_over_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../models/ois.dart';

enum NavChannelNewState {
  basic,
  filter,
  custom,
  none,
}

class SearchFormNewController extends GetxController {
  final Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  final TextEditingController searchCon = TextEditingController();
  

  Function popToFn = () {};
  RxBool readyonly = false.obs;
  int tryInput = 0;
  RxBool autoFocus = false.obs;
  FocusNode searchFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();
    // print("args: ${args}");
    if (Get.arguments != null && Get.arguments['popTo'] != null) {
      popToFn = () {
        Get.toNamed(Get.arguments['popTo'],
            arguments: {"text": searchCon.text});
        readyonly.value = true;
      };
    }
    // print("teststsst: ${Get.arguments['popTo']}");
  }
}

class SearchForm extends StatelessWidget {
  final String? text;
  final String? popTo;
  final bool? tryInput;

  Widget icon = Image.asset(
    "assets/icon/search.png",
    width: 20,
    height: 20,
  );

  SearchForm({Key? key, this.text, this.popTo, this.tryInput})
      : super(key: key);

  final SearchFormNewController controller = Get.put(SearchFormNewController());

  @override
  Widget build(BuildContext context) {
    // print("Function: ${popTo}");
    if (text != null && text != "null" && text != "") {
      controller.searchCon.text = text!;
      controller.searchCon.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.searchCon.text.length));
    }
    return Form(
      key: controller.formKey.value,
      child: TextFormField(
        autofocus: false,
        autocorrect: false,
        controller: controller.searchCon,
        focusNode: controller.searchFocus,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          prefixIcon: IconButton(
            color: AppColors.black,
            icon: icon,
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 0)).then((_) {
                controller.searchCon.clear();
              });
            },
          ),
          hintText: "Cari Channel",
          hintStyle: TextStyle(color: AppColors.darkGrey2, fontFamily: 'Manrope', fontSize: 14),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.white),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        readOnly: controller.readyonly.value,
        onTap: () {
          // Get.toNamed(popTo.toString(), arguments:{"text": controller.searchCon.text});
          // controller.readyonly = true;
          Get.toNamed(popTo.toString());
        },
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (val) {
          String searchText = controller.searchCon.text
              .trim()
              .split(RegExp(r"\s\s+"))
              .join(" ");
          if (searchText != "") {
            if (popTo == null) {
              Get.back();
            }
            OisModel.instance.updateLocalSearchHistory(searchText);
            Get.toNamed('/dsc/search', arguments: {
              "popTo": searchText
            });
          }
        },
      ),
    );
  }
}

class SearchAction extends StatelessWidget {
  final NavChannelNewState? state;

  late Widget action;

  SearchAction({Key? key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case NavChannelNewState.filter:
        action = IconButton(
          onPressed: () {
            Get.toNamed('/search/channels');
          },
          icon: const Icon(Icons.filter_list),
        );
        break;
      case NavChannelNewState.none:
        action = const Text("");
        break;
      case NavChannelNewState.custom:
        action = const Text("");
        break;
      default:
        action = const Text("");
        break;
    }
    return Container(
      child: action,
    );
  }
}

class NavChannelNew extends AppBar {
  NavChannelNew(
      {Key? key,
      String? title,
      bool? tryInput,
      BuildContext? context,
      NavChannelNewState? state,
      String? popTo,
      Widget? customAction,
      String? text})
      : super(
            key: key,
            title: Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                height: 42,
                child: SearchForm(
                  text: text ?? "",
                  popTo: popTo ?? "",
                  tryInput: tryInput ?? false,
                )),
            actions: <Widget>[
              state != NavChannelNewState.custom
                  ? SearchAction(
                      state: state,
                    )
                  : customAction!,
            ],
            iconTheme: IconThemeData(color: AppColors.black),
            backgroundColor: AppColors.light,
            shadowColor: Colors.transparent,
            elevation: null);
}
