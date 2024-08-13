import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:link_shortener_mobile/Core/MainHub.dart';

class Httpbase {
  // singleton
  Httpbase._internal();

  static final Httpbase _instance = Httpbase._internal();

  factory Httpbase() {
    return _instance;
  }

  // LOCAL ID ON ANDROID EMULATOR
  final String _baseUrl = "https://10.0.2.2:7031";

  // LOCAL ID ON IOS
  // final String _baseUrl = "https://localhost:7031";

  // AZURE IP
  // final String _baseUrl = "https://linkshortenerf1-gke9bqhwbmgzekgp.italynorth-01.azurewebsites.net";

  String get baseUrl => _baseUrl;

  String? _token;

  void setToken(String token) async {
    _token = token;
    await MainHub().Connect(token);
  }

  Future<http.Response> get(String? url, [String? query]) async {
    final headers =
        HeaderBuilder().withJson().withHeader(_token ?? "DUMMY").build();
    print('[GET] $_baseUrl$url${(query != null) ? query : ''}');
    print('[HEADER] $headers');
    return await http.get(
        Uri.parse('$_baseUrl$url${(query != null) ? query : ''}'),
        headers: headers);
  }

  Future<http.Response> delete(String? url, [String? query]) async {
    final headers =
        HeaderBuilder().withJson().withHeader(_token ?? "DUMMY").build();
    print('[DELETE] $_baseUrl$url${(query != null) ? query : ''}');
    print('[HEADER] $headers');
    return await http.delete(
        Uri.parse('$_baseUrl$url${(query != null) ? query : ''}'),
        headers: headers);
  }

  Future<http.Response> post(String? url, Object? body) async {
    final headers =
        HeaderBuilder().withJson().withHeader(_token ?? "DUMMY").build();
    print('[POST] $_baseUrl$url');
    print('[HEADER] $headers');
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

class QueryBuilder {
  String _base = "?";

  QueryBuilder add(String key, String value) {
    _base += '$key=$value&';
    return this;
  }

  String build() {
    return _base;
  }
}
