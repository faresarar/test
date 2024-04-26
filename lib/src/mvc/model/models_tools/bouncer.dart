import 'dart:async';
import 'dart:ui';

class Bouncer {
  final int milliseconds;

  Timer? _timer;

  Bouncer({this.milliseconds = 500});

  factory Bouncer.fromMinutes(int minutes) => Bouncer(
        milliseconds: minutes * 60000,
      );

  bool get isActive => _timer?.isActive == true;

  void run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(
      Duration(milliseconds: milliseconds),
      (timer) {
        action();
      },
    );
  }

  void cancel() {
    _timer?.cancel();
  }
}
