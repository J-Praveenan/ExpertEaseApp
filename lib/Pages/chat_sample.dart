import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';

class ChatSample extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatSample({super.key,required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        Padding(padding: EdgeInsets.only(right:2),
        
          child: 
        Container(
          alignment: isCurrentUser? Alignment.centerRight:Alignment.centerLeft,
          child: Padding( 
            padding: isCurrentUser? EdgeInsets.only(top: 20,left: 80):EdgeInsets.only(right: 80),
            child: ClipPath( 
              clipper: isCurrentUser? LowerNipMessageClipper (MessageType.send):UpperNipMessageClipper(MessageType.receive),
              child: Container( 
                padding: isCurrentUser? EdgeInsets.only(left: 20,top: 10,bottom: 25,right: 20):EdgeInsets.all(20),
                decoration:isCurrentUser? BoxDecoration( 
                  color: Color(0xFF7165D6)):BoxDecoration( 
              color: Color(0xFFFFFFFFF),
            ),
                
                child: Text( 
                 message,
                  style: TextStyle( 
                    fontSize: 16,
                    color:isCurrentUser? Colors.white:Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        ),
        
      ],
    );
  }
}