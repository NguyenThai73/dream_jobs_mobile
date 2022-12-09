import 'dart:convert';
import 'dart:math';
import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid.
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class MessengerItem extends StatefulWidget {
  var listMassenger;
  MessengerItem({super.key, required this.listMassenger});
  @override
  State<MessengerItem> createState() => _MessengerItemState();
}

class _MessengerItemState extends State<MessengerItem> {
  var listMassenger;
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  final List<types.Message> _messages = [];
  late final _user;
  @override
  void initState() {
    super.initState();
    listMassenger = widget.listMassenger.first['user_id'];
    _user = types.User(id: '${widget.listMassenger.first['user_id']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colorWhite,
              size: 20,
            )),
        // ignore: prefer_const_constructors
        title: Center(
          child:  Text(
            widget.listMassenger.first['jobsName'],
            style: const TextStyle(color: colorWhite),
          ),
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}
