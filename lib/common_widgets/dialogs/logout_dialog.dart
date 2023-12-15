import 'package:flutter/material.dart';

import '../../views/auth/Methods.dart';
import '../snackbar.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      content: Stack(children: [
        SizedBox(
          height: 125,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              
              SizedBox(
                height: 16,
              ),
              Text(
                'Do you want to logout ?',
                style: TextStyle(color: Colors.white, letterSpacing: 1),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      width: 100,
                      height: 45,
                      child: Center(
                          child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      logOut(context);
                      CustomSnackBar.show(context,'Logout Successfully!',Colors.black);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 80, 79, 79),
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      width: 100,
                      height: 45,
                      child: Center(
                          child: Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }

 
}
