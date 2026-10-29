import 'user_model.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final UserModel user;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'];
    final tokenType = json['tokenType'];
    final expiresIn = json['expiresIn'];
    final user = json['user'];

    if (accessToken is! String ||
        accessToken.isEmpty ||
        tokenType != 'Bearer' ||
        expiresIn is! int ||
        expiresIn <= 0 ||
        user is! Map<String, dynamic>) {
      throw const FormatException('Invalid authentication response.');
    }

    return AuthSessionModel(
      accessToken: accessToken,
      tokenType: tokenType as String,
      expiresIn: expiresIn,
      user: UserModel.fromJson(user),
    );
  }
}
