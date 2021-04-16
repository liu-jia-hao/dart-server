import 'dart:convert';
import 'dart:io';
import 'package:body_parser/body_parser.dart'
Future<void> main() async {
  final server = await createServer();
  print('Server started: ${server.address} port ${server.port}');
  await handleRequests(server);
}

Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 3030;
  return await HttpServer.bind(address, port);
}

Future<void> handleRequests(HttpServer server) async {
  await for (HttpRequest request in server) {
    switch (request.method) {
      case 'GET':
        handleGet(request);
        break;
      case 'POST':
        handlePost(request);
        break;
      default:
        handleDefault(request);
    }
  }
}

var myStringStorage = 'Hello from a Dart server';
const fruit = ['apple', 'banana', 'peach', 'pear'];

/// GET requests
void handleGet(HttpRequest request) {
  final path = request.uri.path;
  switch (path) {
    case '/fruit':
      handleGetFruit(request);
      break;
    case '/vegetables':
      handleGetVegetables(request);
      break;
    default:
      handleGetOther(request);
  }
}

void handleGetFruit(HttpRequest request) {
  final queryParams = request.uri.queryParameters;

  // Return all fruit if there are no query parameters
  if (queryParams.isEmpty) {
    final jsonString = jsonEncode(fruit);
    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonString)
      ..close();
    return;
  }

  // Find any fruit that start with the 'prefix'
  final prefix = queryParams['prefix'];
  final matches = fruit
      .where(
        (item) => item.startsWith(prefix),
      )
      .toList();

  // Respond based on the matches found
  if (matches.isEmpty) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..close();
  } else {
    final jsonString = jsonEncode(matches);
    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonString)
      ..close();
  }
}

void handleGetVegetables(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..write(myStringStorage)
    ..close();
}

void handleGetOther(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.badRequest
    ..close();
}

/// POST requests
Future<void> handlePost(HttpRequest request) async {
  print(request.contains);
  dynamic myStringStorage = await utf8.decoder.bind(request);
  print(myStringStorage);
  request.response
    ..write('Got it. Thanks.')
    ..close();
}

/// Other HTTP method requests
void handleDefault(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.methodNotAllowed
    ..write('Unsupported request: ${request.method}.')
    ..close();
}
