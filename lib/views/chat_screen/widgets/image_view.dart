
  
  
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../../../models/chat_user.dart';
import '../../../models/message.dart';
import '../../../services/apis/api.dart';
import '../../../services/helper/dialogs.dart';
import '../../../services/helper/my_date_util.dart';



class ImageView extends StatefulWidget {
  final String images;
    final ChatUser user;
    final Message message;

  ImageView({super.key, required this.images, required this.user, required this.message});

  //bool Darkmessage = false;
  @override
  State<ImageView> createState() => _ProfilePictureViewState();
}

class _ProfilePictureViewState extends State<ImageView> {
  late double height, width;
  
  @override
  Widget build(BuildContext context) {
     bool isMe = APIs.user.uid == widget.message.formId;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
appBar: AppBar(
       // automaticallyImplyLeading: false,
        // leading: IconButton(
        //   onPressed:() {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon( CupertinoIcons.arrow_left,)),
         toolbarHeight: 62,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 10,
        flexibleSpace: _appBar(isMe),
       // title: 
      //   isMe?
      //   Text( 
      //    'You',
      //     style: TextStyle(color: Colors.white70),
      //   ):
      //   Text( 
      //  widget.user.name,
      //     style: TextStyle(color: Colors.white),
      //   ),
        
        
       // backgroundColor: Colors.black,
      ),      
      
      body: Column(
        children: [
          SizedBox(
            height: 55,
          ),
          Container(
            child: CachedNetworkImage(
              width: double.infinity,
              height: height*0.7,
              fit: BoxFit.contain,
              imageUrl: widget.images,
              errorWidget: (context, url, error) {
                print('Error loading image: $error');
                return const Icon(
                  CupertinoIcons.person,
                  size: 140,
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _appBar(var isme) {
     String sendMsg =
      '${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}';
    return 
     
   
         

            Column(
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
                   
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: isme ? Text(
                          'You',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ): Text(
                          widget.user.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                        )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 2),
                          child: Text(
                           sendMsg,
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
                          child: InkWell(onTap: () async {
                            
                            await GallerySaver.saveImage(widget.message.msg, albumName:'Flash images').then((success) {
                              print('saved photo');
          if (success != null && success) {
            Dialogs.showSnackbar(context, 'Image Successfully Saved!');
          }
        });

                          },
                           
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.square_arrow_down,
                                  color: Colors.white70, // Icon color
                                  size: 20.0, // Icon size
                                ),
                                SizedBox(width: 6.0),
                                Text(
                                  'Save Photo',
                                  style: TextStyle(
                                    color: Colors.white, // Text color
                                    fontSize: 16.0, // Text size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(isme)
                        PopupMenuItem(
                          child: InkWell(onTap: () async {
                           
                             await APIs.deleteMessage(widget.message).then((value) { 
        // Handle deletion completion
      }
      ); Navigator.pop(context);
                          },
                           
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.delete,
                                  color: Colors.white70,
                                  size: 20.0,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'Delete Photo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        )
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
          }
    
  }

