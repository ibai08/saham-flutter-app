import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/models/ois.dart';

enum NavChannelNewState {
  basic,
  filter,
  custom,
  none,
}

class SearchFormController extends GetxController {
  final Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  final TextEditingController searchCon = TextEditingController();
  Widget icon = Image.asset(
    "assets/icon-search.png",
    width: 20,
    height: 20,
  );

  Function popToFn = () {};
  bool readyonly = false;
  int tryInput = 0;
  bool autoFocus = false;
  FocusNode searchFocus = FocusNode();

  

  @override
  void onInit() {
    super.onInit();
    // print("args: ${args}");
    if (Get.arguments != null && Get.arguments['popTo'] != null) {
      popToFn = () {
        Get.toNamed(Get.arguments['popTo'], arguments: {"text": searchCon.text});
        readyonly = true;
      };
    } else {
      autoFocus = true;
    }
  }
}

class SearchForm extends GetView<SearchFormController> {
  final String? text;
  final String? popTo;
  final bool? tryInput;

  SearchForm({Key? key, this.text, this.popTo, this.tryInput}) : super(key: key);

  final SearchFormController controller = Get.put(SearchFormController());

  @override
  Widget build(BuildContext context) {
    print("Function: ${popTo}");
    if (text != null && text != "null" && text != "") {
      controller.searchCon.text = text!;
      controller.searchCon.selection = TextSelection.fromPosition(TextPosition(offset: controller.searchCon.text.length));
    }
    return Form(
      key: controller.formKey.value,
      child: TextFormField(
        autofocus: controller.autoFocus,
        autocorrect: false,
        controller: controller.searchCon,
        focusNode: controller.searchFocus,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          prefixIcon: IconButton(
            icon: controller.icon,
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 0)).then((_) {
                controller.searchCon.clear();
              });
            },
          ),
          hintText: "Cari Channels",
          hintStyle: TextStyle(color: AppColors.darkGrey3),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        readOnly: controller.readyonly,
        onTap: () {
          print("ketap");
          // Get.toNamed(popTo.toString(), arguments:{"text": controller.searchCon.text});
          // controller.readyonly = true;
          Get.offNamed(popTo.toString());
          print("keklik");
        },
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (val) {
          String searchText = controller.searchCon.text.trim().split(RegExp(r"\s\s+")).join(" ");
          if  (searchText != "") {
            if (popTo == null) {
              Get.back();
            }
            OisModel.instance.updateLocalSearchHistory(searchText);
            Get.toNamed('/dsc/search', arguments: searchText);
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
  NavChannelNew({
    Key? key,
    String? title,
    bool? tryInput,
    BuildContext? context,
    NavChannelNewState? state,
    String? popTo,
    Widget? customAction,
    String? text
  }) : super (
    key: key,
    title: Container(
      height: 42,
      child: SearchForm(
        text: text ?? "",
        popTo: popTo ?? "",
        tryInput: tryInput ?? false,
      )
    ),
    actions: <Widget>[
      state != NavChannelNewState.custom ? SearchAction(
        state: state,
      ) : customAction!,
    ],
    iconTheme: const IconThemeData(color: Colors.black),
    backgroundColor: const Color.fromRGBO(242, 246, 247, 1),
    shadowColor: const Color.fromRGBO(242, 246, 247, 1),
    elevation: 2
  );
}