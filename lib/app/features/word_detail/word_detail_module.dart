import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core_module.dart';
import 'data/repositories/word_detail_repository_impl.dart';
import 'interactor/controller/word_detail_controller.dart';
import 'interactor/repositories/i_word_detail_repository.dart';
import 'ui/word_detail_page.dart';

class WordDetailModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<IWordDetailRepository>(WordDetailRepositoryImpl.new);
    i.addLazySingleton(WordDetailController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/:wordId',
      child: (context) => WordDetailPage(
        wordId: r.args.params['wordId'],
      ),
    );
  }
}
