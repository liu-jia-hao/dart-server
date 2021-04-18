import 'resolvers/index.dart';

getResult(Map<String, dynamic> query) async {
  List<Future<dynamic>> tasks = [];
  query.forEach((key, value) {
    if (resolvers[key] != null)
      tasks.add(resolvers[key](value));
    else
      tasks.add(new Future(() {}));
  });
  var taskResults = await Future.wait(tasks);
  Map<String, dynamic> results = new Map();
  List<String> queryKeys = query.keys.toList();
  for (var i = 0; i < queryKeys.length; i++) {
    if (queryKeys[i] == '_') continue;
    results[queryKeys[i]] = taskResults[i];
  }
  return results.toString();
}
