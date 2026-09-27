import 'dart:math';
import 'package:dio/dio.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/infrastructure/models/yes_no_model.dart';

class GetYesNoAnswer {
  final _dio = Dio();

  Future<Message> getAnswer() async {
    // 1. Generamos un número aleatorio del 0 al 99
    final randomNumber = Random().nextInt(100);
    String forceAnswer;

    // 2. Lógica matemática del 40%, 40%, 20%
    if (randomNumber < 40) {
      forceAnswer = 'yes';
    } else if (randomNumber < 80) {
      forceAnswer = 'no';
    } else {
      forceAnswer = 'maybe';
    }

    // 3. Modificamos la URL para forzar a la API a darnos el resultado que sorteamos
    final response = await _dio.get('https://yesno.wtf/api?force=$forceAnswer');

    final yesNoModel = YesNoModel.fromJsonMap(response.data);

    return yesNoModel.toMessageEntity();
  }
}