import 'dart:io';
import 'package:dia/dia.dart';
import 'package:dia_body/dia_body.dart';
import 'resolvers/index.dart';

class ContextWithBody extends Context with ParsedBody {
  ContextWithBody(HttpRequest request) : super(request);
}

void main() {
  final app = App((req) => ContextWithBody(req));

  app.use(body());
// query  parsed  files
  app.use((ctx, next) async {
    var a = ['1', 1];
    try {
      Map<String, dynamic> query = ctx.parsed;
      List<Future<dynamic>> tasks = [];
      query.forEach((key, value) {
        tasks.add(resolvers[key](value));
      });
      await Future.wait(tasks);
      ctx.body = result.toString();
      next();
    } catch (err) {
      print(err);
    }
  });

  /// Start server listen on localhsot:8080
  app
      .listen('localhost', 8080)
      .then((info) => print('Server started on http://localhost:8080'));
}
