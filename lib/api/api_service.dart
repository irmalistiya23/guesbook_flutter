import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guestbook_flutter/utils/constants.dart';
import 'package:guestbook_flutter/models/guest.dart';

class ApiService {
  static Future<List<Guest>> fetchGuests() async {
    final response = await http.get(Uri.parse('${Constants.apiUrl}/guests'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => Guest.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load guests');
    }
  }
}