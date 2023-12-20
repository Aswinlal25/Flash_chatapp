// ignore_for_file: deprecated_member_use, unused_element

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/services/helper/my_date_util.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/views/chat_screen/widgets/chat_delete_dialog.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/apis/api.dart';
import '../../models/chat_user.dart';
import '../../models/message.dart';
import 'widgets/message_card.dart';
import '../users_profile_screen/view_profile_screen.dart';

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

// for storing value of showing emoji and
// isUploading for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false,isEditing =false;

   void _onMessagePress() {
    // Update the app bar or perform any action you want when a message is pressed
    setState(() {
      print("Message pressed!");
      // Update the app bar or any other state
      // For example, you can set a flag to change the app bar in the build method
      isEditing = !isEditing;
    });
  }
 
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
        // statusBarIconBrightness: Brightness.dark,
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

        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 62,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 10,
              flexibleSpace: isEditing ? _appBar() : _appBar(),),
              
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('asset/chat_wallpepper 2.jpg'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter),
            ),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      print('-----------------print---${a}-----------');
                      a++;
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
                                    message: _list[index],     onMessagePress: _onMessagePress,user: widget.user,
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

                if (_isUploading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                //chat input field
                ChatInput(),

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
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewProfileScreen(user: widget.user)));
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
                          CupertinoIcons.arrow_left,
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
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
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
                    Spacer(),
                    PopupMenuButton(
                      color: Color.fromARGB(255, 41, 40, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust the radius as needed
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewProfileScreen(user: widget.user))),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white70, // Icon color
                                  size: 22.0, // Icon size
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  'View Account',
                                  style: TextStyle(
                                    color: Colors.white, // Text color
                                    fontSize: 16.0, // Text size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: InkWell(
                            onTap: () {
                              //  _DeleteAllMsgDialog();
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      ChatDeleteDialog(user: widget.user));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.white70,
                                  size: 22.0,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'Delete Chat',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      offset: Offset(0, 37),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.more_vert, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            );
          }),
    );
  }

  Widget _appBar2() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewProfileScreen(user: widget.user)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {},
                child: Icon(
                  Icons.edit,
                  color: white,
                )),
            SizedBox(
              width: 30,
            ),
            InkWell(onTap: () {}, child: Icon(Icons.save, color: white)),
            SizedBox(
              width: 30,
            ),
            InkWell(onTap: () {}, child: Icon(Icons.delete, color: white)),
            SizedBox(
              width: 30,
            ),
            InkWell(onTap: () {}, child: Icon(Icons.copy, color: white)),
            SizedBox(
              width: 30,
            ),
            PopupMenuButton(
              color: Color.fromARGB(255, 41, 40, 40),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8.0), // Adjust the radius as needed
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      SizedBox(width: 6.0),
                      Text(
                        'time',
                        style: TextStyle(
                          color: white, // Text color
                          fontSize: 16.0, // Text size
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      SizedBox(width: 8.0),
                      Text(
                        'Delete Chat',
                        style: TextStyle(
                          color: white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              offset: Offset(0, 37),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(Icons.more_vert, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  ChatInput() {
    return Row(
      children: [
        Container(
          child: Expanded(
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
                      CupertinoIcons.smiley,
                      color: Colors.white60,
                    ),
                  ),
                  SizedBox(
                    width: 5,
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
                      style: TextStyle(color: white),
                      decoration: const InputDecoration(
                        hintText: ' Aa',
                        hintStyle:
                            TextStyle(color: Colors.white70, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // picking multiple images
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      for (var i in images) {
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      CupertinoIcons.photo_fill,size: 22,
                      color: Colors.white54,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      final XFile? images = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);

                      if (images != null) {
                        print('Image Path: ${images.path}');

                        await APIs.sendChatImage(
                            widget.user, File(images.path));
                      }
                    },
                    icon: const Icon(
                     CupertinoIcons.camera_fill,size: 22,
                      color: Colors.white54,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          width: 45,
          height: 45,
          child: MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);

                _textController.text = '';
              }
            },
            color: Color.fromARGB(255, 107, 107, 107),
            textColor: white,
            shape: CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                Icons.send,
                size: 21,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(
              child: CircularProgressIndicator(),
            ));
  }
}
