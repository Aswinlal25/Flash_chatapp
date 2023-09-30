import 'package:chat_app/helper/my_date_util.dart';
import 'package:flutter/material.dart';

import '../apis/api.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.formId
        ? _LightgreyMessges()
        : _darkgreyMessges();
  }

  // sender message

  Widget _darkgreyMessges() {
    // if (widget.message.read.isEmpty) {
    //   APIs.updateMessageReadStatus(widget.message);
    //  // print('message is updated');
    // }

    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          padding: EdgeInsets.only(left: 12,top: 8,right: 12,bottom: 4),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 43, 43, 43),
              //border: Border.all(color: Colors.blue.shade300),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(widget.message.msg,
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              
              Row(
                mainAxisSize: MainAxisSize.min,
                 // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      MyDateUtil.getFormattedTime(context: context, time: widget.message.sent,),
                      style: TextStyle(color: Colors.white70, fontSize: 9),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // child: Text(widget.message.msg,
          //     style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
    );
  }

  // User Messsages

  Widget _LightgreyMessges() {
   return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          padding: EdgeInsets.only(left: 12,top: 8,right: 12,bottom: 4),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 81, 80, 80),
              //border: Border.all(color: Colors.blue.shade300),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(widget.message.msg,
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(
                width: 0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                 // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.1),
                    child: Text(
                      MyDateUtil.getFormattedTime(context: context, time: widget.message.sent,),
                      style: TextStyle(color: Colors.white70, fontSize: 9),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // child: Text(widget.message.msg,
          //     style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
    );
  }
}
