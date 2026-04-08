class GlobalResponse {
  GlobalResponse({
    this.message,
    this.errors,
    this.code,
  });

  String? message;
  Map<String, dynamic>? errors;
  int? code;

  factory GlobalResponse.fromJson(Map<String, dynamic> json) => GlobalResponse(
        message: json["message"].toString(),
        errors: json["errors"] == null
            ? null
            : Map<String, dynamic>.from(json["errors"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "errors": errors,
        "code": code,
      };
}
