import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({
    Key? key,
    this.radius = 9,
    required this.mdFileName,
  })  : assert(mdFileName.contains('.md'),
            'The fil must contain the .md extension'),
        super(key: key);
  final double radius;
  final String mdFileName;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Column(children: [
        Expanded(
          child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 150)).then((value) {
              return rootBundle.loadString('assets/$mdFileName',);
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final markdownStyleSheet = MarkdownStyleSheet(
                p:TextStyle(color: Colors.white,fontSize: 14,letterSpacing: 0.4,wordSpacing: 2.5),
                );
                return Markdown(
                  data: snapshot.data!,
                  styleSheet: markdownStyleSheet,
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
                 color: Color.fromARGB(255, 91, 90, 90),
              //  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              )),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: Text(
                "Close",
                style: TextStyle(fontSize: 18, color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
