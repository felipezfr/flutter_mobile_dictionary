class RestClientRequest {
  final String path;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? headers;
  final String? method;

  RestClientRequest({
    required this.path,
    this.data,
    this.queryParameters,
    this.headers,
    this.method = 'GET',
  });
}
