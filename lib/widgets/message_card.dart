import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../apis/api.dart';
import '../helper/dialogs.dart';
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
    bool isMe = APIs.user.uid == widget.message.formId;
    return InkWell(
        onLongPress: () {
          _MsgEditDialog(isMe);
        },
        child: _messageWidget());
  }

  Widget _messageWidget() {
    final isDarkMessage = APIs.user.uid != widget.message.formId;
   if( isDarkMessage)
     if(widget.message.readed==''){
      print("the function is called");
         APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment:
          isDarkMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          padding: widget.message.type == Type.text
              ? EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 4)
              : EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 4),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          decoration: BoxDecoration(
            color: isDarkMessage
                ? Color.fromARGB(255, 43, 43, 43)
                : Color.fromARGB(255, 81, 80, 80),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: isDarkMessage ? Radius.circular(10) : Radius.zero,
              bottomLeft: isDarkMessage ? Radius.zero : Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: isDarkMessage
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              widget.message.type == Type.text
                  ?  Text(
                      widget.message.msg,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          errorWidget: (context, url, error) => const Icon(
                                Icons.image,
                                size: 70,
                              )),
                    ),
              SizedBox(
                width: 0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.1),
                    child: Text(
                      MyDateUtil.getFormattedTime(
                        context: context,
                        time: widget.message.sent,
                      ),
                      style: TextStyle(color: Colors.white70, fontSize: 9),
                    ),
                  ),
                  SizedBox(width: 3,),

                if ( isDarkMessage) 
                  Text('')
                else
                  if(widget.message.readed!='')
                  const Icon(Icons.done_all_rounded,color: Colors.blue,size: 14,)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _MsgEditDialog(isMe) {
     final isDarkMessage = APIs.user.uid != widget.message.formId;
     
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          backgroundColor: Color.fromARGB(255, 31, 30,
              30),
          content: Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.message.type == Type.text
                    ? InkWell(
                        child: ListTile(
                          leading: Icon(
                            Icons.copy,
                            color: Colors.white70,
                          ),
                          title: Text(
                            'Copy Text',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        onTap: () async {
                          await Clipboard.setData(
                                  ClipboardData(text: widget.message.msg))
                              .then((value) {
                            Navigator.pop(context);

                            Dialogs.showSnackbar(context, 'Text Copied!');
                          });
                        },
                      )
                    : InkWell(
                        onTap: () async {
                          try{
                            await GallerySaver.saveImage(widget.message.msg, albumName: 'Flash images')
                              .then((success) {
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackbar(
                                  context, 'Image Successfully Saved!');
                            }
                          });
                          }
                          catch(e){
                                 print('ErrorwhileSavingimage:$e');
                          }
                        },
                        child: ListTile(
                          leading: Icon(
                            Icons.save,
                            color: Colors.white70,
                          ),
                          title: Text(
                            'Save image',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      isDarkMessage?
                  ListTile(
                    leading: Icon(
                      Icons.delete_forever,
                      color: Colors.white70,
                    ),
                    title: Text('Cant Delete Message',
                        style: TextStyle(color: Colors.white70)),
                  ):
                  InkWell(
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_forever,
                      color: Colors.white70,
                    ),
                    title: Text('Delete Message',
                        style: TextStyle(color: Colors.white70)),
                  ),
                  onTap: () async {
                    await APIs.deleteMessage(widget.message).then((value) {
                      Navigator.pop(context);
                    });
                  },
                ),
                if (widget.message.type == Type.text && isMe)
                  InkWell(
                    onTap: () {
                      _showMessageUpdateDialog(context);
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Colors.white70,
                      ),
                      title: Text(
                        'Edit Message',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ListTile(
                  leading: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white70,
                  ),
                  title: Text(
                    'Sent At : ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white70,
                  ),
                  title: Text( widget.message.readed.isEmpty? 'Read At : Not seen yet'
                    :'Read At : ${MyDateUtil.getFormattedTime(context: context, time: widget.message.readed)}',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMessageUpdateDialog(BuildContext context) {
    String updatedMsg = widget.message.msg;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Color.fromARGB(255, 31, 30, 30),
         title: Image.asset(
                    'asset/MsgEdit.png',
                    width: 100,
                    height: 100,
                  ),
          // title: Text(
          //   ' Update ',
          //   style: TextStyle(
          //       color: Colors.white, letterSpacing: 0.9, fontSize: 18),
          // ),
          content: Container(
            padding: EdgeInsets.only(
                left: 8, right: 20), // Adjust the padding as needed
            child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
                // color: Colors.white.withOpacity(0.8), // Add opacity
              ),
              child: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.update, color: Colors.white, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  // filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  //alignLabelWithHint: true // Add opacity
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          contentPadding:
              EdgeInsets.only(left: 18, top: 15), // Adjust padding here
          titlePadding:
              EdgeInsets.only(left: 35, top: 20), // Adjust padding here
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                APIs.updatingMessage(widget.message, updatedMsg);
              },
              child: Text('Update', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}






// class _MessageCardState extends State<MessageCard> {
//   @override
//   Widget build(BuildContext context) {
//     return APIs.user.uid == widget.message.formId
//         ? _LightgreyMessges()
//         : _darkgreyMessges();
//   }

//   // sender message

//   Widget _darkgreyMessges() {
//     // if (widget.message.read.isEmpty) {
//     //   APIs.updateMessageReadStatus(widget.message);
//     //  // print('message is updated');
//     // }

//     return Row(
//       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           constraints:
//               BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
//           padding: EdgeInsets.only(left: 12,top: 8,right: 12,bottom: 4),
//           margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
//           decoration: BoxDecoration(
//               color: Color.fromARGB(255, 43, 43, 43),
//               //border: Border.all(color: Colors.blue.shade300),
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   topRight: Radius.circular(10),
//                   bottomRight: Radius.circular(10))),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(widget.message.msg,
//                   style: TextStyle(color: Colors.white, fontSize: 16)),
              
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                  // mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
                  
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5),
//                     child: Text(
//                       MyDateUtil.getFormattedTime(context: context, time: widget.message.sent,),
//                       style: TextStyle(color: Colors.white70, fontSize: 9),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           // child: Text(widget.message.msg,
//           //     style: TextStyle(color: Colors.white, fontSize: 16)),
//         ),
//       ],
//     );
//   }

//   // User Messsages

//   Widget _LightgreyMessges() {
//    return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           constraints:
//               BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
//           padding: EdgeInsets.only(left: 12,top: 8,right: 12,bottom: 4),
//           margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
//           decoration: BoxDecoration(
//               color: Color.fromARGB(255, 81, 80, 80),
//               //border: Border.all(color: Colors.blue.shade300),
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   topRight: Radius.circular(10),
//                   bottomLeft: Radius.circular(10))),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
              
//               Text(widget.message.msg,
//                   style: TextStyle(color: Colors.white, fontSize: 16)),
//               SizedBox(
//                 width: 0,
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                  // mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5.1),
//                     child: Text(
//                       MyDateUtil.getFormattedTime(context: context, time: widget.message.sent,),
//                       style: TextStyle(color: Colors.white70, fontSize: 9),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           // child: Text(widget.message.msg,
//           //     style: TextStyle(color: Colors.white, fontSize: 16)),
//         ),
//       ],
//     );
//   }
// }
