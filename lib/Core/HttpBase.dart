import 'package:http/http.dart' as http;
import 'dart:convert';

class Httpbase {
  // singleton
  Httpbase._internal();

  static final Httpbase _instance = Httpbase._internal();

  factory Httpbase() {
    return _instance;
  }

  final String BASE_URL = "https://10.0.2.2:7031";

  Future<http.Response> get(String? url) async {
    return await http.get(Uri.parse('$BASE_URL$url'), headers: HeaderBuilder().build());
  }

  Future<http.Response> post(String? url, Object? body) async {
    return await http.post(Uri.parse('$BASE_URL$url'),
        headers: HeaderBuilder().withJson().build(), body: body);
  }
}

class HeaderBuilder {
  final Map<String, String> _base = {"accept": "*/*"};

  HeaderBuilder withJson() {
    _base['Content-Type'] = 'application/json; charset=UTF-8';
    return this;
  }

  HeaderBuilder withHeader() {
    _base['Authorization'] = 'Bearer TOKEN';
    return this;
  }

  Map<String, String> build() {
    return _base;
  }
}
