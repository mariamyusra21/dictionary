import 'dart:io';

import 'package:http/http.dart' as http;

import 'model.dart';

class DictionaryService {
  String URL = 'https://api.dictionaryapi.dev/api/v2/entries/en';

  Future<List<DictionaryModel>> getMeaning({String? word}) async {
    final url = "$URL/$word";
    try {
      final req = await http.get(Uri.parse(url));

      print(req.statusCode);
      if (req.statusCode == 200) {
        print(req.body);

        final dictionaryModel = dictionaryModelFromJson(req.body);
        return dictionaryModel;
      } else {
        print(req.body);
        final dictionaryModel = dictionaryModelFromJson(req.body);

        return dictionaryModel;
      }
    } on SocketException catch (_) {
      return Future.error('No network found');
    } catch (_) {
      return Future.error('Something occured');
    }
  }
}
