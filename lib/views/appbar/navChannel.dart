import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../core/config.dart';
import '../../function/showAlert.dart';
import '../../models/ois.dart';
import '../../views/widgets/dialogLoading.dart';

enum NavChannelState {
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
        Get.toNamed(Get.arguments['popTo'],
            arguments: {"text": searchCon.text});
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

  SearchForm({Key? key, this.text, this.popTo, this.tryInput})
      : super(key: key);

  final SearchFormController controller = Get.put(SearchFormController());

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
        autofocus: controller.autoFocus,
        autocorrect: false,
        controller: controller.searchCon,
        focusNode: controller.searchFocus,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          suffixIcon: IconButton(
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
          String searchText = controller.searchCon.text
              .trim()
              .split(RegExp(r"\s\s+"))
              .join(" ");
          if (searchText != "") {
            if (popTo == null) {
              Get.back();
            }
            print("searchText: $searchText");
            OisModel.instance.updateLocalSearchHistory(searchText);
            Navigator.pop(context);
            Get.toNamed('/dsc/search', arguments: searchText);
          }
        },
      ),
    );
  }
}

class SearchAction extends StatelessWidget {
  final NavChannelState? state;

  late Widget action;

  SearchAction({Key? key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case NavChannelState.filter:
        action = IconButton(
          onPressed: () {
            Get.toNamed('/search/channels');
          },
          icon: const Icon(Icons.filter_list),
        );
        break;
      case NavChannelState.none:
        action = const Text("");
        break;
      case NavChannelState.custom:
        action = const Text("");
        break;
      case NavChannelState.basic:
        action = PopupMenuButton<String>(
          onSelected: (value) {
            switch ("$value") {
              case '1':
                Get.toNamed('/dsc/signal/new');
                break;
              case '2':
                Get.toNamed('/dsc/channels/info');
                break;
              case '3':
                remoteConfig.getInt("can_paid_channel") == 1
                    ? Get.toNamed('/dsc/withdraw')
                    : showAlert(context, LoadingState.warning, "Coming Soon");
                break;
            }
          },
          icon: Image.asset(
            'assets/icon-more-vert.png',
            width: 20,
            height: 20,
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: "1",
              child: Text('Buat Signal'),
            ),
            const PopupMenuItem<String>(
              value: "2",
              child: Text('My Info'),
            ),
            remoteConfig.getInt('can_paid_channel') == 1
                ? const PopupMenuItem<String>(
                    value: "3",
                    child: Text('Cash Out'),
                  )
                : const PopupMenuItem(child: null)
          ],
        );
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

class NavChannel extends AppBar {
  NavChannel(
      {Key? key,
      String? title,
      bool? tryInput,
      BuildContext? context,
      NavChannelState? state,
      String? popTo,
      Widget? customAction,
      String? text})
      : super(
            key: key,
            title: Container(
                height: 42,
                child: SearchForm(
                  text: text ?? "",
                  popTo: popTo ?? "",
                  tryInput: tryInput ?? false,
                )),
            actions: <Widget>[
              state != NavChannelState.custom
                  ? SearchAction(
                      state: state,
                    )
                  : customAction!,
            ],
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: const Color.fromRGBO(242, 246, 247, 1),
            shadowColor: const Color.fromRGBO(242, 246, 247, 1),
            elevation: 2);
}
