import 'dart:convert';
import 'package:either_dart/either.dart';

import 'package:flutter_mobile_dictionary/app/core/cache/cache.dart';
import 'package:flutter_mobile_dictionary/app/core/types/unit.dart';
import 'package:flutter_mobile_dictionary/app/features/word_detail/interactor/entities/word_detail_entity.dart';

import '../../../../core/errors/default_exception.dart';
import '../../../../core/rest_client/i_rest_client.dart';
import '../../../../core/rest_client/rest_client_exception.dart';
import '../../../../core/rest_client/rest_client_request.dart';
import '../../../../core/types/types.dart';
import '../../interactor/exceptions/word_detail_not_found_exception.dart';
import '../../interactor/repositories/i_word_detail_repository.dart';
import '../adapters/word_detail_adapter.dart';

class WordDetailRepositoryImpl implements IWordDetailRepository {
  final IRestClient restClient;
  final ICache cache;

  WordDetailRepositoryImpl({
    required this.restClient,
    required this.cache,
  });

  @override
  Future<Output<WordDetailEntity>> getWordDetail(String wordId) async {
    try {
      final wordDetailCached = await cache.getData(wordId);
      if (wordDetailCached != null) {
        return Right(WordDetailAdapter.fromJson(wordDetailCached));
      }

      final response = await restClient.get(RestClientRequest(path: wordId));
      if (response.data == null) {
        return const Left(DefaultException(message: 'Não há dados'));
      }

      // await Future.delayed(const Duration(seconds: 2));

      final json = response.data as List;

      final wordDetail =
          json.map((e) => WordDetailAdapter.fromJson(e)).toList();

      cache.setData(
          params: CacheParams(
              key: wordId, value: WordDetailAdapter.toJson(wordDetail.first)));

      return Right(wordDetail.first);
    } on RestClientException catch (e) {
      if (e.statusCode == 404) {
        return Left(WordDetailNotFoundException(message: e.message));
      }
      return Left(e);
    }
  }

  @override
  Future<Output<List<String>>> getFavorites() async {
    try {
      final favorites = await cache.getData('FAVORITES');

      return favorites != null
          ? Right(List<String>.from(favorites))
          : const Right([]);
    } catch (e) {
      return Left(DefaultException(message: e.toString()));
    }
  }

  @override
  Future<Output<Unit>> toogleFavorite(String wordId) async {
    try {
      final result = await cache.getData('FAVORITES');

      final List<String> favoritesCached =
          result != null ? List<String>.from(result) : [];

      if (favoritesCached.contains(wordId)) {
        favoritesCached.remove(wordId);
      } else {
        favoritesCached.add(wordId);
      }

      await cache.setData(
          params: CacheParams(
              key: 'FAVORITES', value: jsonEncode(favoritesCached)));
      return const Right(unit);
    } catch (e) {
      return Left(DefaultException(message: e.toString()));
    }
  }

  @override
  Future<Output<Unit>> addHistory(String wordId) async {
    try {
      final result = await cache.getData('HISTORY');

      final List<String> historyCached =
          result != null ? List<String>.from(result) : [];

      historyCached.add(wordId);

      await cache.setData(
        params: CacheParams(key: 'HISTORY', value: jsonEncode(historyCached)),
      );
      return const Right(unit);
    } catch (e) {
      return Left(DefaultException(message: e.toString()));
    }
  }
}
