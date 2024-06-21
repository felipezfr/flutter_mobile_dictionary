import 'package:flutter_mobile_dictionary/app/features/word_detail/interactor/entities/definition_entity.dart';

class MeaningEntity {
  String? partOfSpeech;
  List<DefinitionEntity>? definitions;

  MeaningEntity({this.partOfSpeech, this.definitions});
}
