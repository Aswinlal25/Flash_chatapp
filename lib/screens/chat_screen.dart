import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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

// for storing value of showing emoji and
// isUploading for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

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
          //resizeToAvoidBottomInset: false,
          appBar: AppBar(
              toolbarHeight: 60,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 10,
              flexibleSpace: _appBar()),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/chat_wallpepper 2.jpg'),
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
                            10.0), // Adjust the radius as needed
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
                                  Icons.info,
                                  color: Colors.white70, // Icon color
                                  size: 22.0, // Icon size
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  'View Account',
                                  style: TextStyle(
                                    color: Colors.white70, // Text color
                                    fontSize: 16.0, // Text size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: InkWell(
                            onTap: () => _DeleteAllMsgDialog(),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white70,
                                  size: 22.0,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'Delete Chat',
                                  style: TextStyle(
                                    color: Colors.white70,
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
                      Icons.image,
                      color: Colors.white60,
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
          Container(
            width: 45,
            height: 45,
            child: MaterialButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
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
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
    );
  }

  void _DeleteMsgDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Color.fromARGB(255, 31, 30, 30),
          title: Text(
            'Delete',
            style: TextStyle(color: Colors.white, letterSpacing: 0.9),
          ),
          content: Container(
            padding: EdgeInsets.all(8.0), // Adjust the padding as needed
            child: Text(
              'Are you sure you want Delete All Messages ?',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 0.2,
                wordSpacing: 2,
              ),
            ),
          ),
          contentPadding:
              EdgeInsets.only(left: 18, top: 15), // Adjust padding here
          titlePadding:
              EdgeInsets.only(left: 27, top: 20), // Adjust padding here
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () async {
                await APIs.deleteAllMessages(widget.user.id).then((value) {
                  Navigator.pop(context);
                });
              },
              child: Text('Delete', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _DeleteAllMsgDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          backgroundColor: Color.fromARGB(255, 30, 30, 30),
          content: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 280,
                width: 190,
                child: Column(
                  children: [
                    
                    Center(
                        child: Image.asset(
                      'asset/chat_deleteimg-.png',
                      width: 150,
                      height: 150,
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Are you sure you want Delete All Messages ?',
                        style: TextStyle(
                            color: Colors.white, letterSpacing: 1, fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      width: 200,
                      height: 50,
                      child: Center(
                          child: InkWell(
                              onTap: () async {
                                await APIs.deleteAllMessages(widget.user.id)
                                    .then((value) {
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ))),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                left: 201,
                bottom: 240,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.white,
                  ),
                ))
          ]),
        );
      },
    );
  }
}
