import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/Pages/chat_sample.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:expert_ease/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  final String receiverUserEmail;
  final String receiverUserID;
  const ChatScreen({super.key,required this.receiverUserEmail,
    required this.receiverUserID,});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

void sendMessage() async {
    //only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);

      //clear the text controller after sending the message
      _messageController.clear();
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: PreferredSize( 
        preferredSize: Size.fromHeight(70),
        child: AppBar( 
          backgroundColor: Color(0xFF7165D6),
          leadingWidth: 30,
           iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back arrow to white
        ),
          title:Padding(
            padding:const EdgeInsets.only(top: 8), 
            child:Row( 
            children: [ 
              CircleAvatar( 
                radius: 25,
                backgroundImage: AssetImage("images/tutor1.jpeg"),
              ),
              Padding(padding: EdgeInsets.only(left: 10),
              child: Text( 
               widget.receiverUserEmail,
                style: TextStyle( 
                  color: Colors.white,
                  
                ),
              ),)
            ],
          ),
        ),
        // actions: [ 
        //   Padding(padding: EdgeInsets.only(top: 8,right: 10),
        //   child: Icon( 
        //     Icons.call,
        //     color: Colors.white,
        //     size: 26,
        //   ),
        //   ),
        //    Padding(padding: EdgeInsets.only(top: 8,right: 10),
        //   child: Icon( 
        //     Icons.video_call,
        //     color: Colors.white,
        //     size: 30,
        //   ),),
        //    Padding(padding: EdgeInsets.only(top: 8,right: 10),
        //   child: Icon( 
        //     Icons.more_vert,
        //     color: Colors.white,
        //     size: 26,
        //   ),),
        // ],
        ),

      ),
      body: Column(
        children: [
          // message
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),
        ],
      ),
    );
  }

Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;

    //align the messages to the right if the sender is the current user, otherwise to the left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            // Text(data['senderEmail']),
            ChatSample(
              message: data['message'],
              isCurrentUser: isCurrentUser,
            ),
          ],
        ),
      ),
    );
  }

Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom:0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: Container( 
          height: 65,
          decoration: BoxDecoration( 
            color: Colors.white,
            boxShadow: [
              BoxShadow( 
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row( 
            children: [ 
              Padding(padding: EdgeInsets.only(left: 8),
              child: Icon( 
                Icons.add,
                size: 30,
              ),
              ),
              Padding(padding: EdgeInsets.only(left: 5),
              child: Icon( 
                  Icons.emoji_emotions_outlined,
                  color: Colors.amber,
                  size: 30,
              ),
              ),
              Padding(padding: EdgeInsets.only(left: 10),
              child: Container( 
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width/1.6,
                child: TextFormField( 
                  controller: _messageController,
                  decoration: InputDecoration( 
                    hintText: "Type something",
                    border: InputBorder.none,
                  ),
                ),
              ),
              ),
              Spacer(),
              Padding(padding: EdgeInsets.only(right: 10),
              child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(

                Icons.send,
                size: 30,
                color: Color(0xFF7165D6),
              ),),),
            ],
          ),
        ),
          ),
       
        ],
      ),
    );
  }



}