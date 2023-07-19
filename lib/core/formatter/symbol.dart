import 'package:flutter/services.dart';
import 'package:saham_01_app/models/entities/symbols.dart';

List<double> extDecimalArray = [
  1.0,
  10.0,
  100.0,
  1000.0,
  10000.0,
  100000.0,
  1000000.0,
  10000000.0,
  100000000.0
];

List<String> extNumberFormat = [
  "#",
  "#.#",
  "#.##",
  "#.###",
  "#.####",
  "#.#####",
  "#.######",
  "#.#######",
  "#.########"
];

class SymbolInputFormatter extends TextInputFormatter {
  int? digit;
  Function? fnSymbol;
  SymbolInputFormatter(this.fnSymbol);
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    TradeSymbol symbol = fnSymbol!();
    digit = symbol.digit;

    // default offset
    int offset = newValue.selection.baseOffset;
    int oldoffset = oldValue.selection.baseOffset;
    String affected =
        offset <= oldoffset ? oldValue.text[offset] : newValue.text[oldoffset];
    int decimalPos = oldValue.text.indexOf(".");

    // Jika yang diketik '.' atau ','
    // dan tipe editnya input (kalo offset <= oldoffset artinya delete)
    // dan cursor ada di depan .
    // maka pindah ke decimal place
    if ((affected == "." || affected == ",") && offset > oldoffset) {
      return oldValue.copyWith(
          selection: TextSelection.collapsed(offset: decimalPos + 1));
    }
    if ((affected == "." || affected == ",") && offset <= oldoffset) {
      return oldValue.copyWith(
          selection: TextSelection.collapsed(offset: decimalPos));
    }

    double? value = double.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }
    List<String> arrVal = newValue.text.split(".");
    if (arrVal.length > 1) {
      if (arrVal[0] == "") {
        return newValue.copyWith(text: "");
      }
      String firstDecimal = arrVal[0];
      String lastDecimal = arrVal[1];

      // handle 0 ke 10 biasanya saat awal 0.00 klo diisi dengan 1 jadi 10.00 harusnya jadi 1.00
      List<String> arrValOld = oldValue.text.split(".");
      if (arrValOld.length > 1) {
        String firstDecimalOld = arrValOld[0];
        // String lastDecimalOld = arrValOld[1];

        if (firstDecimal == "10" && firstDecimalOld == "0") {
          firstDecimal = "1";
          return newValue.copyWith(
              text: double.parse(firstDecimal + "." + lastDecimal)
                  .toStringAsFixed(digit!),
              selection: const TextSelection.collapsed(offset: 1));
        }
      }

      // jika firstDecimal itu sudah kosong karena dihapus maka ganti dengan 0
      if (firstDecimal.isEmpty) {
        firstDecimal = "0";
        return newValue.copyWith(
            text: double.parse(firstDecimal + "." + lastDecimal)
                .toStringAsFixed(digit!),
            selection: const TextSelection.collapsed(offset: 0));
      }

      if (firstDecimal.length > 10) {
        return oldValue;
      }

      if (lastDecimal.length > digit!) {
        String newText = double.parse(
                firstDecimal + "." + lastDecimal.substring(0, digit))
            .toStringAsFixed(digit!);
        if (newText.length < offset) {
          offset--;
        }
        return newValue.copyWith(
            text: newText,
            selection: TextSelection.collapsed(offset: offset));
      }
    }
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (digit! > extDecimalArray.length ||
        digit! > extNumberFormat.length) {
      return newValue;
    }
    if (!newValue.text.contains(".") && newValue.text.length > 1) {
      value = value / extDecimalArray[digit!];
    }
    String newText = value.toStringAsFixed(digit!);
    return newValue.copyWith(
        text: newText, selection: TextSelection.collapsed(offset: offset));
  }
}