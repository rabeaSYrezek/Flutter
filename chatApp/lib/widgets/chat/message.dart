import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skidrow_friend/crypto/encrypt_decrypt.dart';
import 'package:skidrow_friend/providers/Message.dart';
import 'package:skidrow_friend/providers/auth.dart';
import 'package:skidrow_friend/widgets/chat/message_bubble.dart';

class Messages extends StatefulWidget {
  String prk;
   Messages({super.key, required this.prk});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
   ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    final myId = Provider.of<Auth>(context).userId;
    // final myPrivateKey = Provider.of<Auth>(context).privateKeyEncryptedFromServer;
  // print('fofo $myPrivateKey');
    // Auth authService = Provider.of<Auth>(context, listen: false);
    print('prpr, ${widget.prk}');
    final encrypto = Crypto();

    return Consumer<MessageRepo>(
      builder: (ctx, messages, child) => ListView.builder(
        controller: _scrollController,
         reverse: true,
         shrinkWrap: true,
        itemCount: messages.messages.length,
        itemBuilder: (ctx, index) => MessageBubble(
          isMe: messages.messages[index].fromId == myId,
          message: messages.messages[index].fromId == myId
              ? encrypto.decrypMessage(
                  privateKey: widget.prk,
                  message: messages.messages[index].fromText!)
              : encrypto.decrypMessage(
                  privateKey: widget.prk,
                  message: messages.messages[index].toText!),
          username: 'username',
        ),
      ),
    );
  }
}