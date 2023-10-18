import 'dart:developer';
import 'package:chat_app/hive_db/user_db.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../apis/api.dart';
import '../widgets/chat_user_card.dart';
import '../widgets/home_drawe.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
 
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    APIs.updateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      print('Message : $message');

      if (message.toString().contains('resume')) APIs.updateActiveStatus(true);
      if (message.toString().contains('pause')) APIs.updateActiveStatus(false);

      return Future.value(message);
    });
  }

  // Function to open the drawer
  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },

        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 34, 33, 33),
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Color.fromARGB(15, 5, 5, 5),
            elevation: 3,
            leading: Builder(
              // Wrap IconButton with Builder
              builder: (context) => IconButton(
                onPressed: () {
                  _openDrawer(context);

                  // Open the drawer when the menu icon is tapped
                },
                icon: Icon(Icons.menu, color: Colors.white),
              ),
            ),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle:
                          TextStyle(color: Colors.white38, letterSpacing: 1),
                    ),
                    autofocus: true,
                    style: TextStyle(color: Colors.white),
                    onChanged: (val) {
                      _searchList.clear();

                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }

                        setState(() {
                          _searchList;
                        });
                      }
                    })
                : Text(
                    'FLASH',
                    style: TextStyle(
                        color: Colors.white38,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 4),
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                  color: Colors.white,
                ),
              ),
              
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: APIs.me)));
                },
                icon: const Icon(Icons.person, color: Colors.white),
              )
            ],
          ),

          // the custom drawer
          drawer: thisUSer.value.name!.isNotEmpty ? CustomDrawer() : null,

          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 80, 79, 79),

              onPressed: () {
                _showAddChatDialog(context);
              },
              child: Icon(Icons.person_add_alt_outlined, color: Colors.white),
            ),
          ),

          body: StreamBuilder(
            stream: APIs.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  log(data.toString());
                 list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                  // list.clear();
                        //  for(var element in data!){
                        //   if(element.id!=APIs.auth.currentUser!.uid){
                        //     list.add(ChatUser.fromJson(element.data()));
                        //   }
                        //  }
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount:
                          _isSearching ? _searchList.length : list.length,
                      padding: EdgeInsets.only(top: 3),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: _isSearching ? _searchList[index] : list[index],
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text(
                      'No Connections Found!',
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.white),
                    ));
                  }
              }
            },
          ),
        ),
      ),
    );
  }

  void _showAddChatDialog(BuildContext context) {
    String email ='';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Color.fromARGB(255, 31, 30, 30),
                 
          title: Text(
            ' Add Users ',
            style: TextStyle(
                color: Colors.white, letterSpacing: 0.9, fontSize: 18),
          ),
          content: Container(
            padding: EdgeInsets.only(
                left: 8, right: 20), // Adjust the padding as needed
            child: Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
               
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.white, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                
                  fillColor: Colors.white.withOpacity(0.9),
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  
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
              onPressed: () async {

                APIs.addUser(email.trim());
                
                Navigator.of(context).pop();              
              },
              child: Text('Add', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );

  }

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white, letterSpacing: 1),
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(8)), // Rounded rectangle border
      ),
      behavior: SnackBarBehavior.fixed,
    ));
  }
}
