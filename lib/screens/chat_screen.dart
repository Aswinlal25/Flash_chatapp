// import 'dart:convert';

//import 'dart:developer';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../apis/api.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';
import 'view_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
// for storing all the messages
  List<Message> _list = [];

// for   handling message changes
  final _textController = TextEditingController();

// for storing value of showing emoji
  bool _showEmoji = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    int a = 0;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        onWillPop: () {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        // child:
        // SafeArea(
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 60,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 10,
              flexibleSpace: _appBar()),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'asset/chat_wallpepper 2.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      print('-----------------print---${a}-----------');
                      a++;
                      print("the chat id $a");

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                controller: _scrollController,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: 3),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _list[index],
                                  );
                                });
                          } else {
                            return const Center(
                                child: Text(
                              'Say Hii👋🏻',
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.white),
                            ));
                          }
                      }
                    },
                  ),
                ),
                _ChatInput(),

                // show emoji on keybord

                if (_showEmoji)
                  SizedBox(
                    height: 275,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: Colors.black,
                        columns: 7,
                        initCategory: Category.SMILEYS,
                        emojiSizeMax: 29 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
          backgroundColor: Color.fromARGB(255, 31, 30, 30),
        ),
        //),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_)=> ViewProfileScreen(user:widget.user)));
      },
      child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 35,
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    ClipRRect(
                      
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                          imageUrl: list.isNotEmpty
                              ? list[0].image
                              : widget.user.image),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            list.isNotEmpty ? list[0].name : widget.user.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 2),
                          child: Text(
                            list.isNotEmpty
                                ? list[0].isOnline
                                    ? 'Online'
                                    : MyDateUtil.getLastActiveTime(
                                        context: context,
                                        lastActive: list[0].lastActive)
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: widget.user.lastActive),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  Widget _ChatInput() {
    return Padding(
      padding: const EdgeInsets.all(.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Color.fromARGB(255, 20, 19, 19),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.white60,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji)
                          setState(() => _showEmoji = !_showEmoji);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: ' Message',
                        hintStyle:
                            TextStyle(color: Colors.white70, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.white60,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white60,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
       //   SizedBox(width: 0),
          Container(
            width: 45,
            height: 45,
            child: MaterialButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  APIs.sendMessage(widget.user, _textController.text);
                  _textController.text = '';
                }
              },
              color: Colors.blue,
              textColor: Colors.white,
              shape: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.send,
                  size: 21,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
