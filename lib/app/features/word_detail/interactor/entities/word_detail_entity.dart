import 'package:flutter_mobile_dictionary/app/features/word_detail/interactor/entities/meaning_entity.dart';
import 'package:flutter_mobile_dictionary/app/features/word_detail/interactor/entities/phonetic_entity.dart';

class WordDetailEntity {
  String? word;
  String? phonetic;
  List<PhoneticEntity>? phonetics;
  String? origin;
  List<MeaningEntity>? meanings;

  WordDetailEntity({
    this.word,
    this.phonetic,
    this.phonetics,
    this.origin,
    this.meanings,
  });
}
