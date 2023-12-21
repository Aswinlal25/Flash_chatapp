import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/services/helper/my_date_util.dart';
import 'package:chat_app/views/chat_screen/widgets/image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../../../models/chat_user.dart';
import '../../../services/apis/api.dart';
import '../../../services/helper/dialogs.dart';
import '../../../models/message.dart';
import '../../../utils/constants.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message, required this.onMessagePress, required this.user});

   final ChatUser user;
  final Message message;
   final VoidCallback onMessagePress;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
    bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.formId;
    return InkWell(
        onLongPress: () {
          
          try{
             setState(() {
          isSelected = !isSelected;
        });

        
             // widget.onMessagePress();
          if( isSelected )
          _showMessageEditPopupMenu(context,isMe);
          } on Exception catch (e) {
                  print("the error >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$e");
                  return ;
                }
        },
        // onTapCancel:() {
        //    setState(() {
        //   isSelected = false;
        // });
        //}, 
        onSecondaryTap: () {
           setState(() {
          isSelected = false;
        });
        },
      //    onTap: () {
      //   // Toggle the selection when the card is tapped
      //   setState(() {
      //     isSelected = !isSelected;
      //   });
      // },
       // onTap: widget.onMessagePress,
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
            color:isSelected? blue: isDarkMessage
                ? msgcardcolor1
                : msgcardcolor2,
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
                      style: TextStyle(color: white, fontSize: 16),
                    )
                  : InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=> ImageView(images: widget.message.msg,user: widget.user,message: widget.message,))),
                    child: ClipRRect(
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
                  ),
              SizedBox(
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
                  const Icon(Icons.done_all_rounded,color: blue,size: 14,)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMessageEditPopupMenu(BuildContext context, bool isMe) {
  final isDarkMessage = APIs.user.uid != widget.message.formId;

   final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final Offset center = overlay.size.center(Offset.zero);
  final RelativeRect position = RelativeRect.fromLTRB(
    center.dx, // Center horizontally
    8.8, // Align to the top vertically
    10.0,
    10.0,
  );


  showMenu(
    context: context,
    position: position,
    items: [
      if (widget.message.type == Type.text)
        PopupMenuItem(
          value: 'copyText',
          child: ListTile(
            leading: Icon(Icons.copy, color: Colors.white70),
            title: Text('Copy Text', style: TextStyle(color: Colors.white70)),
          ),
        ),
        if (widget.message.type == Type.image)
      PopupMenuItem(
        value: 2,
        child: ListTile(
          leading: Icon(Icons.save, color: Colors.white70),
          title: Text('Save Image', style: TextStyle(color: Colors.white70)),
        ),
      ),
      if (!isDarkMessage && widget.message.type == Type.text && isMe)
        PopupMenuItem(
          value: 'editMessage',
          child: ListTile(
            leading: Icon(CupertinoIcons.refresh, color: Colors.white70),
            title: Text('Edit Message', style: TextStyle(color: Colors.white70)),
          ),
        ),
         if (!isDarkMessage )
      PopupMenuItem(
        value: 'deleteMessage',
        child: ListTile(
          leading: Icon(CupertinoIcons.delete, color: Colors.white70),
          title: Text('Delete Message', style: TextStyle(color: Colors.white70)),
        ),
      ),
     // if(widget.message.type == Type.text)
      PopupMenuItem(
       value: 'more',
        child: ListTile(
          leading: Icon(CupertinoIcons.info, color: Colors.white70),
          title: Text('info', style: TextStyle(color: Colors.white70)),
        ),
      ),
    ],
    color: primarycolor, // Set the background color of the PopupMenuButton
  ).then((value) {
    if (value != null) {
      _handleMenuItemSelection(context, value);
    }
  });
}

void _handleMenuItemSelection(BuildContext context, var value) async {
  switch (value) {
    case 'copyText':
      try {
        await Clipboard.setData(ClipboardData(text: widget.message.msg)).then((value) {
          Dialogs.showSnackbar(context, 'Text Copied!');
        });
      } on Exception catch (e) {
        print("Error while copying text: $e");
      }
      break;

    case 2:
      try {
        await GallerySaver.saveImage(widget.message.msg, albumName:'Flash images').then((success) {
          if (success != null && success) {
            Dialogs.showSnackbar(context, 'Image Successfully Saved!');
          }
        });
      } catch (e) {
        print('Error while saving image: $e');
      }
      break;

    case 'deleteMessage':
      await APIs.deleteMessage(widget.message).then((value) {
        // Handle deletion completion
      });
      break;

    case 'editMessage':
      _showMessageUpdateDialog(context);
      break;
       case 'more':
     _showMessageinfoDialog(context);
      break;
    default:
      break;
  }
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
          backgroundColor: primarycolor,
          title: Text(
            ' Update ',
            style: TextStyle(
                color: white, letterSpacing: 0.9, fontSize: 18),
          ),
          content: Container(
            padding: EdgeInsets.only(
                left: 8, right: 20), // Adjust the padding as needed
            child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
              //  border: Border.all(color: white),
                borderRadius: BorderRadius.circular(10),
                 color: msgcardcolor1 // Add opacity
              ),
              child: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.edit, color: white, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  // filled: true,
                  fillColor: white.withOpacity(0.9),
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  //alignLabelWithHint: true // Add opacity
                ),
                style: TextStyle(color: white),
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
              child: Text('Cancel', style: TextStyle(color: blue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                APIs.updatingMessage(widget.message, updatedMsg);
              },
              child: Text('Update', style: TextStyle(color: blue)),
            ),
          ],
        );
      },
    );
  }

 void _showMessageinfoDialog(BuildContext context) {
  String sendMsg =
      '${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}';
  String readMsg = widget.message.readed.isEmpty
      ?'_______'
      :'${MyDateUtil.getFormattedTime(context: context, time: widget.message.readed)}';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: primarycolor,
        content: Container(
          height: 120, // Adjust the height as needed
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [Icon(Icons.done_all_outlined,size: 17,color: blue,),SizedBox(width: 3,),
                    Text('Seen',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w500)),
                  ],
                ),
                                SizedBox(height: 4,),

                Text('      $readMsg',style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w400,fontSize: 14),),
                SizedBox(height: 12,),
                 Row(
                   children: [Icon(Icons.done_all_outlined,size: 17,color: blue,),SizedBox(width: 3,),
                     Text('Delivered',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w500)),
                   ],
                 ),
                                 SizedBox(height: 4,),

                Text('      $sendMsg',style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w400,fontSize: 14)),
              ],
            ),
          ),
        ),
      );
    },
  );
}

}






