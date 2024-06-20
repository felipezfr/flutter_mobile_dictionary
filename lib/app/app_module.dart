import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/rest_client/dio/rest_client_dio_impl.dart';
import 'core/rest_client/i_rest_client.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [];

  @override
  void binds(Injector i) {
    i.add<Dio>(DioFactory.dio);
    i.add<IRestClient>(RestClientDioImpl.new);
  }

  @override
  void routes(RouteManager r) {}
}
