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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _searchCon = TextEditingController();
  Widget icon = Image.asset(
    "assets/icon-search.png",
    width: 20,
    height: 20,
  );

  Function popToFn = () {};
  bool readyonly = false;
  int tryInput = 0;
  bool autoFocus = false;
  FocusNode _searchFocus = FocusNode();

  final SearchForm args = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    print("args: $args");
    if (args.popTo != null) {
      popToFn = () {
        Get.toNamed(args.popTo!, arguments: {"text": _searchCon.text});
        readyonly = true;
      };
    } else {
      autoFocus = true;
    }
  }
}

class SearchForm extends GetWidget<SearchFormController> {
  final String? text;
  final String? popTo;
  final bool? tryInput;

  final SearchFormController searchFormController = Get.put(SearchFormController());

  SearchForm({Key? key, this.text, this.popTo, this.tryInput}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text != null && text != "null" && text != "") {
      searchFormController._searchCon.text = text!;
      searchFormController._searchCon.selection = TextSelection.fromPosition(TextPosition(offset: searchFormController._searchCon.text.length));
    }
    return Obx(() {
      return Form(
        key: searchFormController._formKey,
        child: TextFormField(
          autofocus: searchFormController.autoFocus,
          autocorrect: false,
          controller: searchFormController._searchCon,
          focusNode: searchFormController._searchFocus,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            prefixIcon: IconButton(
              icon: searchFormController.icon,
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 0)).then((_) {
                  searchFormController._searchCon.clear();
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
          readOnly: searchFormController.readyonly,
          onTap: () {
            searchFormController.popToFn;
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (val) {
            String searchText = searchFormController._searchCon.text.trim().split(RegExp(r"\s\s+")).join(" ");
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
    });
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