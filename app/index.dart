import 'dart:io';
import 'dart:convert';
import 'getResult.dart';

String _host = InternetAddress.loopbackIPv4.host;

Future main() async {
  var server = await HttpServer.bind(_host, 4049);
  await for (var req in server) {
    ContentType contentType = req.headers.contentType;
    HttpResponse response = req.response;

    if (req.method == 'POST' &&
        contentType?.mimeType == 'application/json' /*1*/) {
      try {
        String content = await utf8.decoder.bind(req).join(); /*2*/
        var data = jsonDecode(content) as Map; /*3*/
        var res = await getResult(data);
        req.response
          ..statusCode = HttpStatus.ok
          ..write('${res}');
      } catch (e) {
        response
          ..statusCode = HttpStatus.internalServerError
          ..write('Exception during file I/O: $e.');
      }
    } else {
      response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('Unsupported request: ${req.method}.');
    }
    await response.close();
  }
}
