import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skidrow_friend/main.dart';
import 'package:skidrow_friend/model/rsa.dart';
import 'package:skidrow_friend/model/socket_custom.dart';
import 'package:skidrow_friend/providers/Message.dart';
import 'package:skidrow_friend/providers/all_users.dart';
import 'package:skidrow_friend/providers/auth.dart';
import 'package:skidrow_friend/providers/context_change.dart';
import 'package:skidrow_friend/screens/chat/chat_screen.dart';
import 'package:skidrow_friend/screens/userScreen/tabs/friend_screen.dart';
import 'package:skidrow_friend/screens/userScreen/tabs/not_friend_user_screen.dart';
import 'package:skidrow_friend/screens/userScreen/tabs/request_screen.dart';
import 'package:skidrow_friend/global/currentChatId.dart';

class RecentChatScreen extends StatefulWidget {
  final SocketServices socketo;
  const RecentChatScreen({Key? key, required this.socketo}) : super(key: key);

  @override
  State<RecentChatScreen> createState() => _RecentChatScreenState();
}

class _RecentChatScreenState extends State<RecentChatScreen> {
      String searchedProvince = 'all';
//  final _socketClient = SocketClient.instance.socket!;
// var sockServ = SocketServices();
 
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
 
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _socketClient.dispose();
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
      
    bool isServerConnected = Provider.of<Auth>(context).isConnectToserver;
    if (!isServerConnected) {
      Future.delayed(Duration.zero, () {
       
      rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text('no server connection')));
    //  }
    });
    }
    // _socketClient.on('sss', (data) => print(data));
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    var token = Provider.of<Auth>(context).token;

const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) => onSelectNotification(payload: payload!, id: message.data['title'], publicKey: message.data['bodyLocKey']));

          print('object1  ${message.data}');
         print('object2  ${message.data['title']}');
         print('object3  ${message.data['body']}');
          print('object4  ${message.data['bodyLocKey']}');
        // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;

        print('iddd, ${CurrentChatUserID.userId}');
       if (CurrentChatUserID.userId != null) {
        if(CurrentChatUserID.userId == message.data['title']) {
          print('why888');
         Provider.of<MessageRepo>(context, listen: false).addToCurrentChatMessages(message: message.data['body'], id: message.data['title']);
         return;
        }
       } else {
        showNotification();
       } 

       
    
  });
    print('token222');
    // MySocket mySocket = MySocket();
  //  MySocket();
  // var soso = SocketServices();
    // soso.connectSocket();
    
    return MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('SkidrowFriend'),
            actions: [
              PopupMenuButton<String>(
                  onSelected: (value) => handleClick(value, context),
                  itemBuilder: (BuildContext context) {
                    return {'Logout', 'Settings'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  })
            ],
            bottom: TabBar(
              tabs: const [
                Tab(icon: Icon(Icons.chat_bubble)),
                Tab(icon: Icon(Icons.people)),
                Tab(icon: Icon(Icons.location_on_outlined), ),
              ],
              onTap: (value) {
                onTab(value, context, token);
              },
            ),
          ),
          body:  TabBarView(
            children: [
              FriendScreen(socket: widget.socketo),
              RequestScreen(socket: widget.socketo),
              // Icon(Icons.directions_transit),
              // Consumer<AllUsers>(builder: (ctx, auth, _) => print(1);)
              NotFriendUserScreen(socket: widget.socketo),
            ],
          ),
          
        ),
      ),
    );

    
  }

  Future onSelectNotification({required String payload, required String id, required String publicKey}) async {
    final prefs = await SharedPreferences.getInstance();
    var extracted = json.decode(prefs.getString('apiKey')!);

    String privateKey = extracted['privateKey']!;
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (context) {return ChatScreen(privateKey: privateKey);},
                                    settings: RouteSettings(
                                      arguments: {
                                        'status': 'out',
                                        'id': id,
                                        'toPublicKey': publicKey
                                      }
                                    )
                                  ),
                                );
  } 

void onTab(int value, BuildContext context, dynamic token) async{
  //  final prefs = await SharedPreferences.getInstance();
  //   final extractedUserData = json.decode(prefs.getString('apiKey')!);
    
  //   // String prk = extractedUserData['privateKey'];
  //   print('ppkk ${extractedUserData['privateKey']}');

  //   var rsa = Rsa();
  //  var rr = rsa.encryptWithPublicKey('text0000000000', extractedUserData['publicKey']);
  //  rsa.decryptWithPrivateKey(rr, extractedUserData['privateKey']);
  switch(value) {
    case 2:
    setState(() {
      
      Provider.of<AllUsers>(context, listen: false).getAllUsers(token,  searchedProvince = Provider.of<AllUsers>(context, listen: false).xProvince);
      print(searchedProvince + '22');
    });
    break;
  }
}
  
}

void handleClick(String value, BuildContext context) {
  switch (value) {
    case 'Logout':
      Provider.of<Auth>(context, listen: false).logout();
      break;
  }
  
   
}




