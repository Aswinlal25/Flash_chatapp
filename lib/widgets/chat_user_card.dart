import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/apis/api.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/my_date_util.dart';
import '../models/message.dart';
import '../screens/chat_screen.dart';

// class ChatUserCard extends StatefulWidget {
//   final ChatUser user;
//   const ChatUserCard({super.key, required this.user});

//   @override
//   State<ChatUserCard> createState() => _ChatUserCardState();
// }

// class _ChatUserCardState extends State<ChatUserCard> {
// // last message info (if null -> no message will display)

//   Message? _message;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         color: Colors.transparent,
//         elevation: 0.0,
//         margin: EdgeInsets.all(1),
//         child: InkWell(
//             onTap: () {
//               // for Navigating to chat screen

//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) => ChatScreen(
//                             user: widget.user,
//                           )));
//             },
//             child: StreamBuilder(
//                 stream: APIs.getLastMessages(widget.user),
//                 builder: (context, snapshot) {
//                   final data = snapshot.data?.docs;
//                   final list =
//                       data?.map((e) => Message.fromJson(e.data())).toList() ??
//                           [];

//                   if (list.isNotEmpty) {
//                     _message = list[0];
//                   }

//                   return ListTile(
//                       leading: ClipRRect(
//                         borderRadius: BorderRadius.circular(100),
//                         child: CachedNetworkImage(
//                           width: 50,
//                           height: 50,
//                           imageUrl:widget.user.image,
//                           errorWidget: (context, url, error) {
//                             log('Error loading image: $error');
//                             return const CircleAvatar(
//                               child: Icon(CupertinoIcons.person),
//                             );
//                           },
//                         ),
//                       ),
//                       title: Text(
//                         widget.user.name,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       subtitle: Text(
//                         _message != null ? _message!.msg : widget.user.about,
//                         maxLines: 1,
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                       trailing: 
//                       // _message == null
//                       //     ? null
//                       //     : _message!.formId != APIs.user.uid
//                       //         ? Container(
//                       //             width: 13,
//                       //             height: 13,
//                       //             decoration: BoxDecoration(
//                       //                 color: Colors.green,
//                       //                 borderRadius: BorderRadius.circular(10)),
//                       //           )
//                       //         :
//                                Text(
//                                   MyDateUtil.getLastMassageTime(
//                                       context: context, time: _message!.sent),
//                                   style: TextStyle(
//                                       color: Colors.white60, fontSize: 13),
//                                 ));
//                 })));
//   }
// }
class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // last message info (if null -> no message will display)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      margin: EdgeInsets.all(1),
      child: InkWell(
        onTap: () {
          // for Navigating to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                user: widget.user,
              ),
            ),
          );
        },
        child: StreamBuilder(
          stream: APIs.getLastMessages(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) {
              _message = list[0];
            } else {
              _message = null; // Ensure _message is null if there are no messages.
            }

            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) {
                    log('Error loading image: $error');
                    return const CircleAvatar(
                      
                      child: Icon(CupertinoIcons.person),
                    );
                  },
                ),
              ),
              title: Text(
                widget.user.name,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _message != null ? _message!.msg : widget.user.about,
                maxLines: 1,
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                _message != null
                    ? MyDateUtil.getLastMassageTime(
                        context: context,
                        time: _message!.sent,
                      )
                    : '', // Handle the case where _message is null.
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
