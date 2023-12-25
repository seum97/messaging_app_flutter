
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_messaging_app/model/message.dart';
import 'package:new_messaging_app/pages/message/messagePage.dart';
import 'package:new_messaging_app/service/messageService.dart';

import '../../model/user.dart';
import '../../service/databaseService.dart';
import '../../service/notificationService.dart';

class Home extends StatefulWidget {
  final String uid;
  Home(this.uid);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    print("initState entered!! ");
    // TODO: implement initState
    super.initState();
    NotificationService.notificationPayload.stream.listen(
            (payload) {
          // Navigator.pushNamed(context, event! );
          Navigator.pushNamed(context, '/notice_page', arguments: {'payload': payload} );
        }
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;



  // Tile containing info of users who are available for messaging
  Widget showTile(CustomUser user){
    if (_auth.currentUser!.uid != user.uid  ) { // current user won't be shown,
                                  // as nobody should be allowed to chat with him/herself here!
      return Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(color: Colors.black, width: 2.0),
        ),
        child: ListTile(
          title: Text("${user.name}", style: TextStyle(fontSize: 25),),

          subtitle: StreamBuilder<List<Message>>(
              stream: MessageService().getUnseenMessages(_auth.currentUser!.uid, user.uid ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final unseenMessageList = snapshot.data;
                  return Text("${user.email} (${unseenMessageList?.length} unseen messages)");
                } else {
                  return Text("${user.email}");
                }
              }

          ),
          tileColor: Colors.grey[300],
          splashColor: Colors.black38,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    MessagePage(receiverID: user.uid, receiverEmail: user.email)
                )
            );
          },

        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget showUserList() {
    return StreamBuilder<List<CustomUser>>(
        stream: DatabaseService().getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userList = snapshot.data;
            return Column(
              children: userList!.map((user) => showTile(user)).toList(),
            );
          } else {
            return Text("Data Not found");
          }
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is Home Page"),
      ),
      body: StreamBuilder<CustomUser>(
          stream: DatabaseService().getUserByUserID(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CustomUser? customUser = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    Text("Currently Logged in user: ", style: TextStyle(fontSize: 30),),
                    SizedBox(height: 10,),
                    Text("${customUser?.name} ", style: TextStyle(fontSize: 25),),

                    Text("${customUser?.email} ", style: TextStyle(fontSize: 20),),

                    SizedBox(height: 40,),
                    Text("Other users available to chat: ", style: TextStyle(fontSize: 30),),

                    SizedBox(height: 10,),
                    showUserList(),

                    SizedBox(height: 40,),
                    ElevatedButton(
                        onPressed: () async{
                          await DatabaseService().logoutUser();
                        },
                        child: Text("Logout")),

                    SizedBox(height: 30,),
                    ElevatedButton(onPressed: () async{
                      await NotificationService().showLocalNotifications(
                        "Notice Title",
                        "This is a very important notification, please read it !!",
                        '/notice_page',);
                      // Navigator.push(context,
                      //   MaterialPageRoute(builder: (context) =>  NotificationDestination()),
                      // );

                    },
                        child: Text("Show Notification")
                    ),
                  ],
                ),
              );
            } else {
              return Text("Data Not Found");
            }
          }),
    );
  }
}
