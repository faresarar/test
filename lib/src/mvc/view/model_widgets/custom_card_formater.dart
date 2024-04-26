import 'package:flutter/services.dart';

class CustomCardFormatter extends TextInputFormatter {
  final String sample;
  final String separator;

  CustomCardFormatter({
    required this.sample,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String sampleText = sample.replaceAll(separator, '');
    String oldText = oldValue.text.replaceAll(separator, '');
    String newText = newValue.text.replaceAll(separator, '');
    if (newText.isEmpty) {
      return newValue;
    }
    if (newText.length < oldText.length) {
      String text = formatText(newText);
      return newValue.copyWith(
        text: text,
        selection: TextSelection.collapsed(
          offset: text.length,
        ),
      );
    }
    if (newText.length > sampleText.length) {
      return oldValue;
    }
    String text = formatText(newText);
    return TextEditingValue(
      text: formatText(newText),
      selection: TextSelection.collapsed(
        offset: text.length,
      ),
    );
  }

  String formatText(String text) {
    List<String> samples = sample.split(separator);
    String result = '';
    for (var i = 0; i < samples.length; i++) {
      if (text.isEmpty) break;
      if (text.length <= samples[i].length) {
        result += text;
        break;
      }
      String value = '';
      value += text.substring(0, samples[i].length);
      text = text.substring(samples[i].length);
      if (text.isNotEmpty) {
        value += separator;
      }
      result += value;
    }
    return result;
  }
}
