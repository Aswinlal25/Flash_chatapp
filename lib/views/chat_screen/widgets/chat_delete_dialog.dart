import 'package:chat_app/services/apis/api.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/material.dart';
import '../../../common_widgets/snackbar.dart';
import '../../../utils/constants.dart';

class ChatDeleteDialog extends StatelessWidget {
  final ChatUser user;

  const ChatDeleteDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      backgroundColor: primarycolor,
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
                height10,
                const Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Are you sure you want Delete All Messages ?',
                    style:
                        TextStyle(color: white, letterSpacing: 1, fontSize: 15),
                  ),
                ),
                height32,
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 107, 107, 107),
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    width: 200,
                    height: 50,
                    child: InkWell(
                      onTap: () async {
                        await APIs.deleteAllMessages(user.id).then((value) {
                          Navigator.pop(context);
                        });
                        CustomSnackBar.show(
                            context, 'Chat Deleted Succesfully!', black);
                      },
                      child: Center(
                          child: Text(
                        'Delete',
                        style: TextStyle(
                            color: white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
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
                color: white,
              ),
            ))
      ]),
    );
  }
}
