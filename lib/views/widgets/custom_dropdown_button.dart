import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class DropdownWithLabel<T> extends StatelessWidget {
  const DropdownWithLabel({
    Key? key,
    this.title,
    @required this.value,
    @required this.label,
    @required this.onChange,
    @required this.items,
    this.error,
  }) : super(key: key);
  final String? title;
  final T? value;
  final String? label;
  final Function? onChange;
  final List<DropdownMenuItem<T>>? items;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const SizedBox(
          height: 5,
        ),
        DropdownButtonFormField<T>(
            isExpanded: true,
            isDense: true,
            icon: Image.asset(
              'assets/drop-down.png',
              width: 22,
            ),
            elevation: 12,
            decoration: InputDecoration(
              labelText: title,
              hintText: label,
              labelStyle: TextStyle(
                height: 1.5,
                color: AppColors.black,
              ),
              contentPadding: EdgeInsets.zero,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.2,
                  color: AppColors.darkGrey4,
                ),
              ),
            ),
            value: value == "null" ? null : value,
            onChanged: (context) {
              onChange;
            },
            items: items),
        Text(
          error ?? '',
          style: TextStyle(
              color: Colors.redAccent.shade700,
              fontSize: 12.0,
              height: error != null ? 2 : 0),
        )
      ],
    );
  }
}
