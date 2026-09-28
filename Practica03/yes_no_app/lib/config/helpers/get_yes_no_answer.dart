import 'dart:math';
import 'package:dio/dio.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/infrastructure/models/yes_no_model.dart';

class GetYesNoAnswer {
  final _dio = Dio();

  Future<Message> getAnswer(String userMessage) async {
    String forceAnswer;
    
    final textLower = userMessage.trim().toLowerCase();

    // 1. Buscamos los comandos
    if (textLower.contains('?=yes')) {
      forceAnswer = 'yes';
    } else if (textLower.contains('?=no')) {
      forceAnswer = 'no';
    } else if (textLower.contains('?=maybe')) {
      forceAnswer = 'maybe';
    } else {
      // 2. Sorteo normal si no hay truco
      final randomNumber = Random().nextInt(100);
      if (randomNumber < 40) {
        forceAnswer = 'yes';
      } else if (randomNumber < 80) {
        forceAnswer = 'no';
      } else {
        forceAnswer = 'maybe';
      }
    }

    // 3. LA MEJORA: Usar queryParameters en lugar de modificar el String de la URL
    final response = await _dio.get(
      'https://yesno.wtf/api',
      queryParameters: {
        'force': forceAnswer // Dio construirá la URL segura automáticamente
      }
    );

    final yesNoModel = YesNoModel.fromJsonMap(response.data);

    return yesNoModel.toMessageEntity();
  }
}