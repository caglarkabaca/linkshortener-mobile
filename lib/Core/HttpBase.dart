import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:link_shortener_mobile/Core/LocalStorage.dart';

class Httpbase {
  // singleton
  Httpbase._internal();

  static final Httpbase _instance = Httpbase._internal();

  factory Httpbase() {
    return _instance;
  }

  final String _baseUrl = "https://10.0.2.2:7031";
  String? _token;

  // olmadı
  void setToken(String token) {
    _token = token;
  }

  Future<http.Response> get(String? url) async {
    final headers =
        HeaderBuilder().withJson().withHeader(_token ?? "DUMMY").build();
    return await http.get(Uri.parse('$_baseUrl$url'), headers: headers);
  }

  Future<http.Response> post(String? url, Object? body) async {
    final headers =
        HeaderBuilder().withJson().withHeader(_token ?? "DUMMY").build();
    return await http.post(Uri.parse('$_baseUrl$url'),
        headers: headers, body: body);
  }
}

class HeaderBuilder {
  final Map<String, String> _base = {"accept": "*/*"};

  HeaderBuilder withJson() {
    _base[HttpHeaders.contentTypeHeader] = 'application/json; charset=UTF-8';
    return this;
  }

  HeaderBuilder withHeader(String token) {
    _base[HttpHeaders.authorizationHeader] = 'Bearer ${token}';
    return this;
  }

  Map<String, String> build() {
    return _base;
  }
}
