import 'package:yes_no_app/domain/entities/message.dart';

class YesNoModel {
  YesNoModel({
    required this.answer,
    required this.forced,
    required this.image,
  });

  final String answer;
  final bool forced;
  final String image;

  factory YesNoModel.fromJsonMap(Map<String, dynamic> json) => YesNoModel(
        answer: json["answer"],
        forced: json["forced"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "answer": answer,
        "forced": forced,
        "image": image,
      };

  Message toMessageEntity() {
    // Variable para guardar la traducción
    String respuestaTraducida;

    // Traducimos los 3 casos exactos
    if (answer == 'yes') {
      respuestaTraducida = 'Sí';
    } else if (answer == 'no') {
      respuestaTraducida = 'No';
    } else {
      respuestaTraducida = 'Tal vez';
    }

    return Message(
      text: respuestaTraducida,
      fromWho: FromWho.hers,
      imageUrl: image,
      time: DateTime.now() // Manteniendo la hora que configuramos
    );
  }
}