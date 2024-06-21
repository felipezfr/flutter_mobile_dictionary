import 'package:flutter_mobile_dictionary/app/features/word_detail/interactor/entities/word_detail_entity.dart';

import '../../../../core/types/types.dart';

abstract class IWordDetailRepository {
  Future<Output<WordDetailEntity>> getWordDetail(String wordId);
  Future<Output<List<String>>> getFavorites();
  Future<Output<void>> toogleFavorite(String wordId);
  Future<Output<void>> addHistory(String wordId);
}
