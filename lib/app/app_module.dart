import 'package:flutter_mobile_dictionary/app/core/core_module.dart';
import 'package:flutter_mobile_dictionary/app/features/home/home_module.dart';
import 'package:flutter_mobile_dictionary/app/features/word_detail/word_detail_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.module('/', module: HomeModule());
    r.module('/word_detail', module: WordDetailModule());
  }
}
