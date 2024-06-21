import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';

import 'package:flutter_mobile_dictionary/app/core/cache/i_cache.dart';

import '../../../../core/errors/default_exception.dart';
import '../../../../core/rest_client/i_rest_client.dart';
import '../../../../core/rest_client/rest_client_exception.dart';
import '../../../../core/types/types.dart';
import '../../interactor/repositories/i_home_repository.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final IRestClient restClient;
  final ICache cache;

  HomeRepositoryImpl({
    required this.restClient,
    required this.cache,
  });

  @override
  Future<Output<List<String>>> getWordList() async {
    try {
      String jsonString =
          await File('assets/data/words_dictionary.json').readAsString();
      final response = jsonDecode(jsonString);

      if (response == null) {
        return const Left(DefaultException(message: 'Não há dados'));
      }

      final List<String> wordList = [];
      (response as Map).forEach((key, value) => wordList.add(key));

      return Right(wordList);
    } on RestClientException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Output<List<String>>> getFavoriteWordList() async {
    try {
      final response = await cache.getData('FAVORITES');

      if (response == null) {
        return const Right([]);
      }
      return Right(List<String>.from(response));
    } on RestClientException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Output<List<String>>> getHistoryWordList() async {
    try {
      final response = await cache.getData('HISTORY');

      if (response == null) {
        return const Right([]);
      }
      return Right(List<String>.from(response));
    } on RestClientException catch (e) {
      return Left(e);
    }
  }
}
