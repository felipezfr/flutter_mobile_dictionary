import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'rest_client/dio/rest_client_dio_impl.dart';
import 'rest_client/i_rest_client.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<Dio>(DioFactory.dio);
    i.add<IRestClient>(RestClientDioImpl.new);
  }
}
