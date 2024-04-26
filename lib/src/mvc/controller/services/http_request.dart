import 'dart:developer';

import 'package:http/http.dart' as http;

class HttpRequest {
  /// Use this function to send an HTTP [request] with several [retries] and a
  /// [delay] while the request `times out` or receives a response with
  /// `status code = 500`. If the [request] receives a response with a status
  /// code different than 500, return it, else return a response with status
  /// code `408` or `500`.
  static Future<http.Response> attemptHttpCall(
    http.Request request, [
    int retries = 5,
    Duration delay = const Duration(milliseconds: 500),
    Duration timeout = const Duration(seconds: 5),
  ]) async {
    request.headers.addAll({
      // ...Cookies.valideCookies,
    });
    http.StreamedResponse streamedResponse = await Future.delayed(
      retries == 5 ? Duration.zero : delay,
      () async => await request.send().timeout(
        timeout,
        onTimeout: () {
          log('Request timed out');
          return http.StreamedResponse(
            const Stream.empty(),
            408,
            request: request,
            reasonPhrase: 'Request timed out',
          );
        },
      ),
    );
    if (retries > 0 && ([500, 408].contains(streamedResponse.statusCode))) {
      //server error or timeout
      late http.Request newRequest = http.Request(
        request.method,
        request.url,
      );
      newRequest.headers.addAll(request.headers);
      newRequest.body = request.body;
      log('trying attempts left: $retries');
      return await attemptHttpCall(
        newRequest,
        retries - 1,
      );
    } else {
      throw Exception();
    }
  }
}
