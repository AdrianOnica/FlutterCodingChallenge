import 'dart:convert';

import 'package:coding_challenge/model/Events.dart';
import 'package:http/http.dart';

class Repository {
  final String url = 'https://app.ticketmaster.com/discovery/v2/events.json?apikey=pvFAvUNS3Ip429PMoa7dX3r2FiXKvTJm';

  Future<List<Events>>? getEvents() async {
    var response = await get(Uri.parse(url));
    Map<String, dynamic> map = jsonDecode(response.body);
    var smth = map['_embedded']['events'] as List;
    return smth.map((e) => Events.fromJson(e)).toList();
  }
}
