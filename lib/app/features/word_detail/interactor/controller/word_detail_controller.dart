import '../../../../core/controllers/controllers.dart';
import '../../../../core/states/base_state.dart';
import '../repositories/i_word_detail_repository.dart';

class WordDetailController extends BaseController {
  final IWordDetailRepository repository;
  WordDetailController(
    this.repository,
  ) : super(InitialState());

  Future<void> getWordDetail(String wordId) async {
    update(LoadingState());

    final respose = await repository.getWordDetail(wordId);

    respose.fold(
      (left) => update(ErrorState(exception: left)),
      (right) => update(SuccessState(data: right)),
    );
  }

  Future<bool> isFavorited(String wordId) async {
    final respose = await repository.getFavorites();

    bool isFavorited = false;
    respose.fold(
      (left) => isFavorited = false,
      (right) => isFavorited = right.contains(wordId),
    );
    return isFavorited;
  }

  Future<void> toogleFavorite(String wordId) async {
    await repository.toogleFavorite(wordId);
  }

  Future<void> addHistory(String wordId) async {
    await repository.addHistory(wordId);
  }
}
