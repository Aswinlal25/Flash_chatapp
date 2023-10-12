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

  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing self information
  static late ChatUser me;

  //for return current user
  static User get user => auth.currentUser!;

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
        .orderBy("Last Message Time",descending: true)
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
  static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
// for message sending time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

//for message to send
    final Message message = Message(
        told: chatUser.id,
        msg: msg,
        readed: '',
        type: type,
        formId: user.uid,
        sent: time);

    final ref = firestore
        .collection("chats/${getConversationID(chatUser.id)}/messages/");
    await ref.doc(time).set(message.toJson());
    
    updateLastMessageTime(time,me.id,chatUser.id);
  }

  //  for update last message time in user 

 static updateLastMessageTime(String time,String thisUser,String chatUserId)async{
    await firestore.collection('Users').doc(thisUser).set({"Last Message Time":time},SetOptions(merge: true));
    await firestore.collection('Users').doc(chatUserId).set({"Last Message Time":time},SetOptions(merge: true));
  }

  //  for update the read status of message

  static Future<void> updateMessageReadStatus(Message message) async {
    var time=DateTime.now().millisecondsSinceEpoch.toString();
 await firestore
        .collection("chats/${getConversationID(message.formId)}/messages/")
        .doc(message.sent)
        .set({"readed":time},SetOptions(merge: true));
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

  //delete meessage
  static Future<void>deleteMessage(Message message)async{
    await firestore
    .collection('chats/${getConversationID(message.told)}/messages/')
    .doc(message.sent)
    .delete();

    if(message.type == Type.image){
      await storage.refFromURL(message.msg).delete();
    }
  }


  static Future<void> deleteAllMessages(String conversationID) async {
    String chatId=getConversationID(conversationID);
  final collectionReference = firestore.collection('chats/$chatId/messages');

  final QuerySnapshot querySnapshot = await collectionReference.get();
  for (final doc in querySnapshot.docs) {
    await doc.reference.delete();
  }
}

// updating message 
static Future<void> updatingMessage(Message message , String updatedMsg) async {
    await firestore
    .collection('chats/${getConversationID(message.told)}/messages/')
    .doc(message.sent)
    .update({'msg': updatedMsg});

    
  
}


//send chat image

static Future<void> sendChatImage(ChatUser chatUser ,File file) async{

  // getting image file extension
    final ext = file.path.split('.').last;
   
    

    // storage file ref with path
    final ref = storage.ref().child('images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata (contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    // updating image in firestore 
    final imageUrl = await ref.getDownloadURL();
     await sendMessage(chatUser, imageUrl, Type.image);
}


static Future<int> getCount(String chatUserId)async{

String chatId=getConversationID(chatUserId);
  final message =await FirebaseFirestore.instance.collection('chats').doc(chatId).collection("messages").get();
  int count = 0;
    final  messageList = message.docs;
    for(var data in messageList){
      if(data['readed']== ""&&data['formId']!= auth.currentUser!.uid){
        count++;
      }
    }
  return count;
}

}




