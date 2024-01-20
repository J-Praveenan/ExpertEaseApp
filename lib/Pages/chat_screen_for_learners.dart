import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/Pages/chat_sample.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:expert_ease/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreenForLearner extends StatefulWidget {

  final String receiverUserEmail;
  final String receiverUserID;
  const ChatScreenForLearner({super.key,required this.receiverUserEmail,
    required this.receiverUserID,});

  @override
  State<ChatScreenForLearner> createState() => _ChatScreenForLearnerState();
}

class _ChatScreenForLearnerState extends State<ChatScreenForLearner> {
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
       backgroundColor: Color(0xFFEDEBFF),
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
            
              FutureBuilder(
                  future: _getImageUrl(widget.receiverUserID),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(); // You can return a loading indicator here
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final imageUrl = snapshot.data as String?;

                    return Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl)
                            : AssetImage("images/default_avatar.png")
                                as ImageProvider<
                                    Object>?, // Use a default image if no URL is available
                      ),
                    );
                  },
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
              Padding(padding: EdgeInsets.only(left: 0),
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

   Future<String?> _getImageUrl(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('userNewProfile')
          .doc(userId)
          .get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['profileImage'] as String?;
    } catch (e) {
      print('Error getting user image URL: $e');
      return null;
    }
  }



}