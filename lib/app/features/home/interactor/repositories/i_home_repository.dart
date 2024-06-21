import '../../../../core/types/types.dart';

abstract class IHomeRepository {
  Future<Output<List<String>>> getWordList();
  Future<Output<List<String>>> getFavoriteWordList();
  Future<Output<List<String>>> getHistoryWordList();
}
