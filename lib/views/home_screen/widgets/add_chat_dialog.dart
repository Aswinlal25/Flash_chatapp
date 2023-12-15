import 'package:flutter/material.dart';
import '../../../services/apis/api.dart';

class CustomAddChatDialog extends StatefulWidget {
 final BuildContext cntx;
   CustomAddChatDialog({super.key,required this.cntx});
  @override
  _CustomAddChatDialogState createState() => _CustomAddChatDialogState();
}

class _CustomAddChatDialogState extends State<CustomAddChatDialog> {
  String email = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Color.fromARGB(255, 31, 30, 30),
      title: Text(
        'Add Users',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1,
          fontSize: 18,
        ),
      ),
      content: Container(
        padding: EdgeInsets.only(left: 8, right: 20),
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
      contentPadding: EdgeInsets.only(left: 18, top: 15),
      titlePadding: EdgeInsets.only(left: 35, top: 25, bottom: 4),
      actionsPadding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
      actions: <Widget>[
        Row(
          children: [
            SizedBox(width: 37),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                width: 100,
                height: 45,
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
            SizedBox(width: 30),
            InkWell(
              onTap: ()async {
                
                     bool isFound= await APIs.addChatUser(email.trim());
                  isFound==true?_showSnackBar(
                              widget.cntx, 'User added Successfully! ', Colors.black):_showSnackBar(
                              widget.cntx, 'User does not Exists ', Colors.black);
                      Navigator.of(context).pop();
                 },
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 80, 79, 79),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                width: 100,
                height: 45,
                child: Center(
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
