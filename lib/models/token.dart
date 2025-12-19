class Token {
  final String access_token;

  Token({required this.access_token});

  Map<String, dynamic> toJson() {
    return {'access_tokem': access_token};
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(access_token: json['destination']);
  }
}
