import 'dart:io';
import 'package:chat_app/hive_db/user_db.dart';
import 'package:chat_app/hive_model/user.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/chat_user.dart';
// import 'package:chat_app/hive_model/user.dart';


class APIs {
  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseAuth _auth = FirebaseAuth.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing self information
  static late ChatUser me;

  //for return current user
  static User get user => _auth.currentUser!;

  //for checking if user exists or not ?
  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  //for getting current user information
  static Future<void> getSelfInfo() async {
    await firestore.collection('Users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
       UserModel value=UserModel(name: me.name, about: me.about, image: me.image);
       saveUserToDB(value);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        about: "Hey i'm using Flash !",
        name: user.displayName.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        id: user.uid,
        email: user.email.toString(),
        pushToken: '',
        image: user.photoURL.toString());

    return await firestore
        .collection('Users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting all users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('Users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore
        .collection('Users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
        UserModel value=UserModel(name: me.name, about: me.about, image: me.image);
       saveUserToDB(value);
  }

 // for getting specific user info
     static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUser chatUser){
    return firestore
        .collection('Users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
        
     }

   // update online or last active status of user 
     static Future<void> updateActiveStatus(bool isOnline) async {

      firestore.collection('Users').doc(user.uid).update({
          'is_online' : isOnline,
          'last_active' : DateTime.now().millisecondsSinceEpoch.toString()
      });
     }  


  // -------------Chat Screen  Related ------------------

  //for getting conversation id
  static String getConversationID(String id) {
    List uid = [user.uid, id];
    uid.sort();
    String msgId = uid.join("_");
    return msgId;
  }
  // user.uid.hashCode <= id.hashCode
  //     ? '${user.uid}_$id'
  //     : '${id}_${user.uid}';

  //for getting all messages

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection("chats/${getConversationID(user.id)}/messages/")
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //for sending message
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
// for message sending time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

//for message to send
    final Message message = Message(
        told: chatUser.id,
        msg: msg,
        read: '',
        type: Type.text,
        formId: user.uid,
        sent: time);

    final ref = firestore
        .collection("chats/${getConversationID(chatUser.id)}/messages/");
    await ref.doc(time).set(message.toJson());
  }

  //  for update the read status of message

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection("chats/${getConversationID(message.formId)}/messages/")
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // get only last message

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return firestore
        .collection("chats/${getConversationID(user.id)}/messages/")
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

    // update profile piture of user
  static Future<void> updateProfilePicture(File file) async {

    // getting image file extension
    final ext = file.path.split('.').last;
    print('Extension: $ext');
    

    // storage file ref with path
    final ref = storage.ref().child('profile_picture/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata (contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    // updating image in firestore 
    me.image = await ref.getDownloadURL();
     await firestore
        .collection('Users')
        .doc(user.uid)
        .update({'image': me.image});
         UserModel value=UserModel(name: me.name, about: me.about, image: me.image);
       saveUserToDB(value);
  }
}
