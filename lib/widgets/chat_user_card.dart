import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/apis/api.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helper/my_date_util.dart';
import '../models/message.dart';
import '../screens/chat_screen.dart';
import 'dialogs/profile_dialog.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // last message info (if null -> no message will display)
  Message? _message;
  bool isOnline = false;

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
              _message = null;
            }

            return Stack(children: [
              ListTile(
                leading: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => ProfileDialog(
                              user: widget.user,
                            ));
                  },
                  child: ClipRRect(
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
                ),
                title: Text(
                  widget.user.name,
                  //  ==APIs.me.name?"${widget.user.name}(me)":widget.user.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .3,
                      fontSize: 17),
                ),
                subtitle: Text(
                  _message != null
                      ? _message!.type == Type.image
                          ? '📷 Photo'
                          : _message!.msg
                      : widget.user.about,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    direction: Axis.vertical,
                    children: [
                      Text(
                        _message != null
                            ? MyDateUtil.getLastMassageTime(
                                context: context,
                                time: _message!.sent,
                              )
                            : '', // Handle the case where _message is null.
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      FutureBuilder<int>(
                          future: APIs.getCount(widget.user.id),
                          builder: (context, AsyncSnapshot snapshot) {
                            // ignore: unused_local_variable
                            var num = snapshot.data;
                            return snapshot.data == 0
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 109, 108, 108),
                                        radius: 11,
                                        child: Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  );
                          }),
                    ]),
              ),
              Positioned(
                child: widget.user.isOnline ? _onlineIndicator() : SizedBox(),
                top: 7,
                left: 12,
              ),
            ]);
          },
        ),
      ),
    );
  }

  Widget _onlineIndicator() {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => ProfileDialog(
                  user: widget.user,
                ));
      },
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromARGB(255, 30, 128, 3),
            width: 1.7,
          ),
        ),
        // width: 12,
        // height: 12,
        // decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
        child: Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
