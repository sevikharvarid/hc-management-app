import 'package:equatable/equatable.dart';

class DataResponse<T> extends Equatable {
  final Status status;
  final dynamic data;
  final String? message;
  final int? messageCode;
  final dynamic responseStatus;

  const DataResponse.error({
    this.data,
    this.message,
    this.messageCode,
    this.responseStatus,
  }) : status = Status.error;

  const DataResponse.success({
    this.data,
    this.message,
    this.messageCode,
    this.responseStatus,
  }) : status = Status.success;

  const DataResponse.loading({
    this.data,
    this.message,
    this.messageCode,
    this.responseStatus,
  }) : status = Status.loading;

  const DataResponse.noConnection({
    this.data,
    this.message,
    this.messageCode,
    this.responseStatus,
  }) : status = Status.noConnection;

  const DataResponse.tokenExpired({
    this.data,
    this.message,
    this.messageCode,
    this.responseStatus,
  }) : status = Status.tokenExpired;

  const DataResponse.requestTimeOut({
    this.data,
    this.message,
    this.messageCode,
    this.responseStatus,
  }) : status = Status.requestTimeOut;

  @override
  String toString() =>
      "status : $status, message: $message, data: ${data.toString()}";

  @override
  List<Object?> get props => [
        status,
        data,
        message,
        messageCode,
        responseStatus,
      ];
}

enum Status {
  loading,
  success,
  failed,
  error,
  noConnection,
  tokenExpired,
  requestTimeOut
}
