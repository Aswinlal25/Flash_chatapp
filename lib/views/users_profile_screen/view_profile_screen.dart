import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/views/chat_screen/chat_screen.dart';
import 'package:chat_app/views/home_screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/helper/my_date_util.dart';
import '../chat_screen/widgets/chat_delete_dialog.dart';
import '../home_screen/widgets/profile_picture_view.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ViewProfileScreen> {
  late double height, width;
  String? netImage; // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    // Initialize _image with the user's current profile picture URL
    netImage = widget.user.image;
  }

  @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: null,
//       body: Stack(
//         children: [
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) => ProfilePictureView(user: widget.user)));
//             },
//             child: Container(
//               height: height * .48,
//               child: CachedNetworkImage(
//                 width: 390.0,
//                 height: 180.0,
//                 fit: BoxFit.cover,
//                 imageUrl: netImage!,
//                 errorWidget: (context, url, error) {
//                   print('Error loading image: $error');
//                   return const Icon(
//                     CupertinoIcons.person,
//                     size: 140,
//                   );
//                 },
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 900,
//           ),
//           Positioned(
//             top: 325,
//             child: Container(
//               height: height * .6,
//               width: width * .999,
//               decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 31, 30, 30),
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(50),
//                       topRight: Radius.circular(50))),
//               child: Column(
//                 children: [
//                   SizedBox(height: 20),
//                   Text(
//                     widget.user.name,
//                     style: TextStyle(
//                         color: Colors.white, fontSize: 25, letterSpacing: 1.5),
//                   ),
//                   SizedBox(height: 15),
//                   Text(
//                     widget.user.email,
//                     style: TextStyle(
//                       fontSize: 11,
//                       letterSpacing: 1.7,
//                       color: Colors.white70,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     MyDateUtil.getLastActiveTime(
//                         context: context, lastActive: widget.user.lastActive),
//                     style: const TextStyle(
//                       color: Colors.white54,
//                       fontSize: 14,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Container(
//                     constraints: BoxConstraints(
//                           maxWidth: MediaQuery.of(context).size.width * 0.9),
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(255, 40, 40, 40),
//                         borderRadius: BorderRadius.all(
//                             Radius.circular(20)), // Adjust the radius as needed
//                       ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => ChatScreen(
//                                         user: widget.user,
//                                       ),
//                                     )).then((result) {
//                                   // Now, navigate to the HomeScreen
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => HomeScreen(),
//                                     ),
//                                   );
//                                 });
//                               },
//                               icon: const Icon(
//                                 Icons.chat,
//                                 color: Colors.white,
//                                 size: 27,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 34,
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 //_DeleteAllMsgDialog();
//                                 showDialog(
//                           context: context,
//                           builder: (_) =>   ChatDeleteDialog(user : widget.user

//                               ));
//                               },
//                               icon: const Icon(
//                                 Icons.delete,
//                                 color: Colors.white,
//                                 size: 27,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               '  Message',
//                               style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 12,
//                                   letterSpacing: .5,
//                                   fontWeight: FontWeight.w700),
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               ' Delete chat',
//                               style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 12,
//                                   letterSpacing: .5,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10,)
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(.20),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 10, bottom: 5, left: 30),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'About : ',
//                                   style: TextStyle(
//                                       color: Colors.white70,
//                                       // fontWeight: FontWeight.w700,
//                                       letterSpacing: 1.5,
//                                       fontSize: 15),
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     widget.user.about,
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         letterSpacing: 1,
//                                         fontSize: 17),
//                                   ),
//                                 ),
//                               ]),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Padding(
//                           padding:
//                               const EdgeInsets.only(bottom: 13, left: 30),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Joined On : ',
//                                   style: TextStyle(
//                                       color: Colors.white70,
//                                       fontWeight: FontWeight.w700,
//                                       letterSpacing: 1.5,
//                                       fontSize: 12),
//                                 ),
//                                 Text(
//                                   MyDateUtil.getLastMassageTime(
//                                       context: context,
//                                       time: widget.user.createdAt,
//                                       showYear: true),
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       letterSpacing: 1,
//                                       fontSize: 12),
//                                 ),
//                               ]),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   SizedBox(height: 100),
//                   Text(
//                     'FLASH',
//                     style: TextStyle(
//                         color: Colors.white38, letterSpacing: 5, fontSize: 13),
//                   ),
//                   Text(
//                     'Version 1.0',
//                     style: TextStyle(color: Colors.white24, fontSize: 8),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             left: 5,
//             top: 15,
//             child: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(
//                 CupertinoIcons.arrow_left,
//                 color: Colors.white,
//                 size: 27,
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Color.fromARGB(255, 31, 30, 30),
//     );
//   }
// }
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfilePictureView(user: widget.user)));
            },
            child: Container(
              height: height * .48,
              child: CachedNetworkImage(
                width: 390.0,
                height: 180.0,
                fit: BoxFit.cover,
                imageUrl: netImage!,
                errorWidget: (context, url, error) {
                  print('Error loading image: $error');
                  return const Icon(
                    CupertinoIcons.person,
                    size: 140,
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 900,
          ),
          Positioned(
            top: 325,
            child: Container(
              height: height * .6,
              width: width * .999,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 31, 30, 30),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.user.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            widget.user.email,
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Email id',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1,
                              color: Colors.white70,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.3,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.user.about,
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.2,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            'About',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1,
                              color: Colors.white70,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.3,
                          ),
                          SizedBox(
                            height: 210,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Joined On : ${MyDateUtil.getLastMassageTime(context: context, time: widget.user.createdAt, showYear: true)}',
                      style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: height * 0.43,
            left: width * 0.82,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        user: widget.user,
                      ),
                    )).then((result) {
                  // Now, navigate to the HomeScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(),
                    ),
                  );
                });
              },
              child: Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Color.fromARGB(255, 107, 107, 107),
                ),
                child: Center(
                  child: Icon(
                    Icons.chat,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: height * 0.04,
              left: width * 0.89,
              child: PopupMenuButton(
                  color: Color.fromARGB(255, 41, 40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the radius as needed
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: InkWell(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      ChatDeleteDialog(user: widget.user));
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 7,
                                ),
                                Icon(
                                  Icons.delete,
                                  color: Colors.white70, // Icon color
                                  size: 22.0, // Icon size
                                ),
                                SizedBox(width: 15.0),
                                Text(
                                  'Delete chat',
                                  style: TextStyle(
                                    color: Colors.white, // Text color
                                    fontSize: 16.0, // Text size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                  offset: Offset(0, 5),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.more_vert, color: Colors.white),
                  ))),
          Positioned(
            left: 5,
            top: 15,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                CupertinoIcons.arrow_left,
                color: Colors.white,
                size: 27,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
    );
  }
}
