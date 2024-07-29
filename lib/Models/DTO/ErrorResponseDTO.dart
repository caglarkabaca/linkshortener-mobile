class ErrorResponseDTO {
  String? error_message;

  ErrorResponseDTO({this.error_message});

  ErrorResponseDTO.fromJson(Map<String, dynamic> json) {
    error_message = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMessage'] = this.error_message;
    return data;
  }
}
