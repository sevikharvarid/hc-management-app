import 'package:http/http.dart' as http;

class ThrowException implements Exception {
  final dynamic prefix;
  final dynamic message;
  final dynamic data;

  ThrowException({this.message, this.prefix, this.data});

  @override
  String toString() => "$message";
}

class FetchDataException extends ThrowException {
  FetchDataException([String? message, dynamic prefix])
      : super(prefix: prefix, message: "$message");
}

class InvalidException extends ThrowException {
  InvalidException({
    String? message,
    int? responseCode,
    Map<String, dynamic>? data,
  }) : super(prefix: responseCode, message: "$message");
}

class BadRequestException extends ThrowException {
  BadRequestException([String? message, dynamic prefix, data])
      : super(prefix: prefix, message: "$message", data: data);
}

class UnauthorizedException extends ThrowException {
  UnauthorizedException({String? message})
      : super(message: "$message Unauthorized");
}

class ExpiredTokenException extends ThrowException {
  ExpiredTokenException({
    required String message,
    http.Response? response,
    int? responseCode,
    dynamic data,
  }) : super(message: "${responseCode.toString()} Expired Token");
}

class InvalidInputException extends ThrowException {
  InvalidInputException([String? message])
      : super(message: "$message Invalid input");
}

class RequestTimeoutException extends ThrowException {
  RequestTimeoutException([String? message])
      : super(message: "$message Gateway Timeout");
}
