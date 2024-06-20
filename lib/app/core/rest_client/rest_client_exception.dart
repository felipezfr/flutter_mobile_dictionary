import '../errors/base_exception.dart';
import 'rest_client_response.dart';

class RestClientException extends BaseException {
  dynamic error;
  int? statusCode;
  RestClientResponse? response;

  RestClientException({
    required super.message,
    this.statusCode,
    required this.error,
    this.response,
    super.stackTracing,
  });
}
