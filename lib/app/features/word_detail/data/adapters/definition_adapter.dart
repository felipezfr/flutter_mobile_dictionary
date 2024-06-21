import 'package:flutter_mobile_dictionary/app/features/word_detail/interactor/entities/definition_entity.dart';

class DefinitionAdapter {
  static DefinitionEntity fromJson(Map<String, dynamic> json) {
    return DefinitionEntity(
      definition: json['definition'],
      example: json['example'],
      synonyms:
          json['synonyms'] != null ? List<String>.from(json['synonyms']) : [],
      antonyms:
          json['antonyms'] != null ? List<String>.from(json['antonyms']) : [],
    );
  }

  static Map<String, dynamic> toJson(DefinitionEntity entity) {
    return {
      'antonyms': entity.antonyms,
      'definition': entity.definition,
      'example': entity.example,
      'synonyms': entity.synonyms,
    };
  }
}
