import '../mvc/model/enums.dart';

extension LottieAnimationExtensions on LottieAnimation {
  String get valueToString {
    switch (this) {
      // case LottieAnimation.splashscreen:
      //   return 'assets/lotties/splashscreen.json';
      case LottieAnimation.check:
        return 'assets/lotties/check.json';
      case LottieAnimation.question:
        return 'assets/lotties/question.json';
      case LottieAnimation.error:
        return 'assets/lotties/error.json';
      default:
        throw Exception('Value not in range');
    }
  }
}
