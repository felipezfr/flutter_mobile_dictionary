import 'package:flutter_mobile_dictionary/app/features/word_detail/data/adapters/meaning_adapter.dart';
import 'package:flutter_mobile_dictionary/app/features/word_detail/data/adapters/phonetic_adapter.dart';

import '../../interactor/entities/word_detail_entity.dart';

class WordDetailAdapter {
  static WordDetailEntity fromJson(Map<String, dynamic> json) {
    return WordDetailEntity(
      word: json['word'],
      phonetic: json['phonetic'],
      phonetics: json['phonetics'] != null
          ? (json['phonetics'] as List)
              .map((i) => PhoneticAdapter.fromJson(i))
              .toList()
          : [],
      origin: json['origin'],
      meanings: json['meanings'] != null
          ? (json['meanings'] as List)
              .map((i) => MeaningAdapter.fromJson(i))
              .toList()
          : [],
    );
  }

  static Map<String, dynamic> toJson(WordDetailEntity entity) {
    return {
      'word': entity.word,
      'phonetic': entity.phonetic,
      'phonetics': entity.phonetics != null
          ? (entity.phonetics as List)
              .map((i) => PhoneticAdapter.toJson(i))
              .toList()
          : [],
      'origin': entity.origin,
      'meanings': entity.meanings != null
          ? (entity.meanings as List)
              .map((i) => MeaningAdapter.toJson(i))
              .toList()
          : [],
    };
  }
}
