import 'dart:io';
//import 'dart:convert' show UTF8;

Future main() async {
  var server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    4040,
  );
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    //Future<String> content = UTF8.decodeStream(request);
    request.response.write('Hello, world!');
    await request.response.close();
  }
}
