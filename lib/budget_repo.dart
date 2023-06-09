import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:budget_tracker/failure_model.dart';
import 'package:budget_tracker/items_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class BudgetRepo {
  static const String baseUrl = 'https://api.notion.com/v1/';
  final http.Client _client;
  BudgetRepo({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future<List<Item>> getItems() async {
    log(dotenv.env['NOTION_DATABASE_ID'].toString());
    try {
      final url =
          '${baseUrl}databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['results'] as List).map((e) => Item.fromMap(e)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      } else {
        throw const Failure(message: 'Something went wrong!');
      }
    } catch (e) {
      log(e.toString());
      throw const Failure(message: 'Something went wrong!');
    }
  }
}
