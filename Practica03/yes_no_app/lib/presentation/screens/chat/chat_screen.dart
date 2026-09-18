import 'package:flutter/material.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/Briar_0.jpg',
            ),
          )
        ),
        title: const Text('Briar'),
        centerTitle: false,
      ),
      body: _ChatView(),
    );
  }

  
}

class _ChatView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children:[
            Expanded(child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index){
                return const MyMessageBubble();
              })),
              Text("Hola"), 
            Text("Mundo"),
      ]
        )
      )
      
    );
  }
}