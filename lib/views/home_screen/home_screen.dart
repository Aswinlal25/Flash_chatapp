import 'package:chat_app/services/hive_database/hive_db/user_db.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/apis/api.dart';
import 'widgets/chat_user_card.dart';
import 'widgets/add_chat_dialog.dart';
import 'widgets/home_drawe.dart';
import '../user_profile_screen/profile_screen.dart';

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
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
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
                            builder: (context) =>
                                ProfileScreen(user: APIs.me)
                                ));
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
                 // _showAddChatDialog(context);
                 showDialog(
                        context: context,
                        builder: (_) => CustomAddChatDialog(
                            cntx: context,
                            ));
                
                },
                child: Icon(Icons.person_add_alt_1, color: Colors.white),
              ),
            ),
            body: StreamBuilder(
              stream: APIs.getMyUsersId(),
              builder: (context, snapshot) {
                try {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    case ConnectionState.active:
                    case ConnectionState.done:
                      return StreamBuilder(
                        stream: APIs.getAllUsers(
                            snapshot.data?.docs.map((e) => e.id).toList() ??
                                []),
                        builder: (context, thisSnapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );

                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = thisSnapshot.data?.docs ?? [];
                              
                              List<String> users =
                                  (snapshot.data?.docs.map((e) => e.id))!
                                      .toList();
                              print(users.length);
                              if (data.isEmpty) {
                                return Center(
                                  child: Text("No Data is Available",style: TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 2,
                                        color: Colors.white),),
                                );
                              } else {
//  list = data.map((e) => ChatUser.fromJson(e.data())).toList();
                                list.clear();
                                List<Map<String,dynamic>> thisUsers=[];
                                for (var ele in users) {
                                  for (var element in data) {
                                    if (ele == element['id']) {
                                     if(element['id']!=APIs.auth.currentUser!.uid){
                                       thisUsers.add(element.data());
                                     }
                                    }
                                  }
                                }
                                List<ChatUser> temp=[];
                               thisUsers.sort((a, b) => a['Last Message Time'].compareTo(b['Last Message Time']),);
                               for(var ele in thisUsers){
                                temp.add(ChatUser.fromJson(ele));
                               }
                               list=temp.reversed.toList();
                                if (list != []) {
                                  print(list.length);
                                  return ListView.builder(
                                    itemCount: _isSearching
                                        ? _searchList.length
                                        : list.length,
                                    padding: EdgeInsets.only(top: 3),
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ChatUserCard(
                                        user: _isSearching
                                            ? _searchList[index]
                                            : list[index],
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                      child: Text(
                                    'No Connections Found!',
                                    style: TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 2,
                                        color: Colors.white),
                                  ));
                                }
                              }
                          }
                        },
                      );
                  }
                } on Exception catch (e) {
                  print("the error >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$e");
                  return SizedBox();
                }
              },
            )),
      ),
    );
  }
}
