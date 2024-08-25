import 'package:chatapp/components/drawer.dart';
import 'package:chatapp/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  //creating a firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //get users
  Stream<List<Map<String, dynamic>>> getAllUsers() {
    return _firebaseFirestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //create individual user
        final user = doc.data();
        //return user
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverId, message) async {
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp currentTimeStamp = Timestamp.now();

    Message mainMessage = Message(
      senderId: currentUserId,
      receiverId: receiverId,
      senderEmail: currentUserEmail,
      message: message,
      timestamp: currentTimeStamp,
    );

    //creating chat room ID for the two users for unique convo room
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sorting the ids so that the chatroomId is same for any 2 people.
    String chatRoomId = ids.join('_');
    await _firebaseFirestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(mainMessage.toMap());
    // get messages
  }
}
