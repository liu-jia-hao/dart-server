import 'dart:io';
import 'package:dia/dia.dart';
import 'package:dia_body/dia_body.dart';
import 'getResult.dart';

class ContextWithBody extends Context with ParsedBody {
  ContextWithBody(HttpRequest request) : super(request);
}

void main() {
  final app = App((req) => ContextWithBody(req));

  app.use(body());
// query  parsed  files
  app.use((ctx, next) async {
    try {
      ctx.body = await getResult(ctx.parsed);
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
