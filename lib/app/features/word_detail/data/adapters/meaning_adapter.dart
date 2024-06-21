import 'package:flutter_mobile_dictionary/app/features/word_detail/data/adapters/definition_adapter.dart';
import 'package:flutter_mobile_dictionary/app/features/word_detail/interactor/entities/meaning_entity.dart';

class MeaningAdapter {
  static MeaningEntity fromJson(Map<String, dynamic> json) {
    return MeaningEntity(
      partOfSpeech: json['partOfSpeech'],
      definitions: json['definitions'] != null
          ? (json['definitions'] as List)
              .map((i) => DefinitionAdapter.fromJson(i))
              .toList()
          : [],
    );
  }

  static Map<String, dynamic> toJson(MeaningEntity entity) {
    return {
      'partOfSpeech': entity.partOfSpeech,
      'definitions': entity.definitions != null
          ? (entity.definitions as List)
              .map((i) => DefinitionAdapter.toJson(i))
              .toList()
          : [],
    };
  }
}
