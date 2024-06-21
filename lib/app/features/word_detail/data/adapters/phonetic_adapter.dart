import 'package:flutter_mobile_dictionary/app/features/word_detail/interactor/entities/phonetic_entity.dart';

class PhoneticAdapter {
  static PhoneticEntity fromJson(Map<String, dynamic> json) {
    return PhoneticEntity(
      audio: json['audio'],
      text: json['text'],
    );
  }

  static Map<String, dynamic> toJson(PhoneticEntity entity) {
    return {
      'text': entity.text,
      'audio': entity.audio,
    };
  }
}
