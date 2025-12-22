import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);
  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout of ApiServer');

      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout of ApiServer');

      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout of ApiServer');

      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response!.statusCode!,
          dioError.response!.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was cancelled');
      case DioExceptionType.connectionError:
        return ServerFailure('No internet connection');
      case DioExceptionType.unknown:
        return ServerFailure('There was an unexpected error, Please try again');
      default:
        return ServerFailure('Oops there was an error, Please try later');
    }
  }
  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure('Your request is not found, please try later');
    } else if (statusCode == 500) {
      return ServerFailure('Internal server error, please try later');
    } else {
      return ServerFailure('Oops there was an error, Please try later');
    }
  }
}
