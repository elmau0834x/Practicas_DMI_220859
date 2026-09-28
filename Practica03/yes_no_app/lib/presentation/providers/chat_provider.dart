import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/get_yes_no_answer.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final getYesNoAnswer = GetYesNoAnswer();

  List<Message> messageList = [
    Message(text: "Hola Puta", fromWho: FromWho.me, time: DateTime.now()),
    Message(text: "Unas Rankeds o que?", fromWho: FromWho.me, time: DateTime.now()),
  ];

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    // 1. Limpiamos los comandos secretos para que no aparezcan en tu burbuja visual
    String cleanText = text
        .replaceAll('?=yes', '')
        .replaceAll('?=no', '')
        .replaceAll('?=maybe', '')
        .trim();

    // Guardamos en la lista el mensaje ya limpio
    final newMessage = Message(text: cleanText, fromWho: FromWho.me, time: DateTime.now());
    messageList.add(newMessage);

    notifyListeners();
    moveScrollToBottom();

    // 2. Comprobamos si el mensaje limpio termina en "?"
    if (cleanText.endsWith("?")) {
      // 3. Le pasamos a Briar el texto ORIGINAL (que sí trae el truco oculto)
      herReplay(text);
    }
  }

  // 4. Recibimos el parámetro 'text' aquí para solucionar el error
  Future<void> herReplay(String text) async {
    final herMessage = await getYesNoAnswer.getAnswer(text);
    messageList.add(herMessage);
    notifyListeners();

    moveScrollToBottom();
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));

    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}