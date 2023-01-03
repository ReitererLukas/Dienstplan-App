import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dienstplan/main.dart';
import 'package:dienstplan/models/user.dart';
import 'package:dienstplan/stores/user_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NotificationServer {
  final String url = dotenv.get("url");

  Map<String, String> _getHeaders() {
    return {
      "content-type": "application/json",
      "authorization": dotenv.get("apiPassword")
    };
  }

  String? _handleResponse(http.Response resp, {bool hasBody = true}) {
    if ([HttpStatus.created, HttpStatus.ok].contains(resp.statusCode) && hasBody) {
      String id = jsonDecode(resp.body)["id"].toString();
      return id;
    }
    return null;
  }

  Future<String> registerDienstplan(User user) async {
    String? token = prefs.getString("gcmToken");
    if (token != null) {
      return await _registerDienstplanLinkToApi({
        "dienstplan": {
          "dienstplanLink": user.link,
          "notificationToken": token,
          "name": user.name
        }
      });
    }
    return "";
  }

  void updateToken(String newToken) {
    prefs.setString("gcmToken", newToken);
    _updateTokenToApi(
        getIt<UserManager>()
            .users
            .where((u) => u.notificationId != "")
            .map((u) => u.notificationId)
            .toList(),
        newToken);
  }

  void removeDienstplan() {
    _removeDienstplanLinkFromApi(getIt<UserManager>().activeUser!.notificationId);
  }

  Future<void> _updateTokenToApi(List<String> ids, String newToken) async {
    for (String id in ids) {
      http.Response resp = await http.patch(Uri.parse("${url}dienstplan/update/$id"),
          body: jsonEncode({
            "dienstplan": {
              "notificationToken": newToken,
            }
          }),
          headers: _getHeaders());
      _handleResponse(resp);
    }
  }

  Future<String> _registerDienstplanLinkToApi(Map body) async {
    http.Response resp = await http.post(Uri.parse("${url}dienstplan/register"),
        body: jsonEncode(body), headers: _getHeaders());
    return _handleResponse(resp) ?? "";
  }

  // server removes dienstplan after 60 days of inactivity
  // => when dp is fetched timer on the server should be updated
  Future<void> refreshTimerOfDienstplanOnServer(String id) async {
    http.Response resp = await http.patch(Uri.parse("${url}dienstplan/refreshTimer/$id"),
        headers: _getHeaders());

    if(resp.statusCode == 404) {
      getIt<UserManager>().activeUser!.notificationId = await registerDienstplan(getIt<UserManager>().activeUser!);
    }
  }

  Future<void> _removeDienstplanLinkFromApi(String id) async {
    http.Response resp = await http.delete(Uri.parse("${url}dienstplan/remove/$id"),
        headers: _getHeaders());
    _handleResponse(resp, hasBody: false);
  }

}