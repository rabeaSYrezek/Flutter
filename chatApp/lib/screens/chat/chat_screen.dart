import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skidrow_friend/providers/Message.dart';
import 'package:skidrow_friend/providers/auth.dart';
import 'package:skidrow_friend/providers/context_change.dart';
import 'package:skidrow_friend/widgets/chat/message.dart';
import 'package:skidrow_friend/widgets/chat/new_message.dart';
import 'package:skidrow_friend/global/currentChatId.dart';

class ChatScreen extends StatefulWidget {
  
  static const routeName = 'chat_screen';
  String? privateKey;
   ChatScreen({super.key, this.privateKey});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 MessageRepo _myProvider = MessageRepo();
  @override
  void dispose() {
     
    CurrentChatUserID.userId = null;
    super.dispose();
  }

 @override
  void initState() {
    super.initState();
    
    _myProvider = Provider.of<MessageRepo>(context, listen: false);
     _myProvider.resetMessageList();
  }
  @override
  Widget build(BuildContext context) {
    // bool? isFriend = Provider.of<Auth>(context).isFriend;
    
    var token = Provider.of<Auth>(context, listen: false).token;
    print('toto $token');
    Map<String, dynamic>? arg = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    CurrentChatUserID.userId = arg['id'];
    print('args, ${arg}');
    if (arg != null) {
     if (arg['status'] == 'out') {
       Provider.of<MessageRepo>(context, listen: false).getAllMessages(token: token!, userId: arg['id']!);
     } 
     if (arg['status'] == 'in') {
      Provider.of<MessageRepo>(context, listen: false).getAllMessages(token: token!, userId: arg['id']!);
     }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('myText'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(prk: widget.privateKey!),
            ),
           arg['status'] != null ? NewMessage(status: arg['status'], toUserId:  arg['id']!, toPublicKey: arg['toPublicKey']!,) 
           : NewMessage(toPublicKey: 'sssssss', toUserId: 'sssssss'),
          ],
        ),
      ),
    );
  }
}
