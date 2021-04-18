import 'dart:io';
import 'dart:convert';
import 'getResult.dart';

String _host = InternetAddress.loopbackIPv4.host;

Future main() async {
  var server = await HttpServer.bind(_host, 8080);
  await for (var req in server) {
    HttpResponse response = req.response;
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
    await response.close();
  }
}
