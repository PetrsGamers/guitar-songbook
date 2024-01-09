import 'dart:js_interop_unsafe';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/entities/songs.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../firebase/firebase_auth_services.dart';

class CommentScreen extends StatefulWidget {
  final songId;
  const CommentScreen({required this.songId, Key? key}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final User? currentUser = Auth().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('songs')
            .doc(widget.songId)
            .collection('comments')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Show error message
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No comments yet'),
            ); // Display when no comments are available
          }

          // Process comments and user details
          return FutureBuilder<List<Widget>>(
            future: _getUserComments(snapshot.data!.docs),
            builder: (BuildContext context,
                AsyncSnapshot<List<Widget>> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show loading indicator while fetching user details
              }
              if (userSnapshot.hasError) {
                return Text(
                    'Error: ${userSnapshot.error}'); // Show error message if fetching fails
              }

              // Display comments with user details
              return ListView(
                children: userSnapshot.data ?? [],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCommentWindow,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<Widget>> _getUserComments(List<DocumentSnapshot> comments) async {
    List<Widget> commentWidgets = [];

    for (DocumentSnapshot comment in comments) {
      Map<String, dynamic> commentData = comment.data() as Map<String, dynamic>;
      DocumentReference userRef = commentData['author'];

      print(userRef.id);
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userRef.id)
          .get();
      Map<String, dynamic>? userData = userSnapshot.data();
      print(commentData);
      print(userData);
      // Build the comment widget with user details
      commentWidgets.add(
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(userData?['picture'] ?? ''),
                  ),
                  Text(
                    _formatTimestamp(commentData['time']),
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentData['text'] ?? '',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    GestureDetector(
                      onTap: () {
                        context.go('/profile/${userRef.id}');
                      },
                      child: Text(
                        userData?['name'] ?? '',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
              if (userRef.id == currentUser?.uid)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      final commentRef = comment.reference;
                      commentRef.delete();
                      print('Delete comment');
                    },
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.close, color: Colors.red),
                      SizedBox(width: 4.0),
                    ]),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return commentWidgets;
  }

  void openCommentWindow() {
    TextEditingController textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Type your comment here',
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String commentText = textController.text.trim();
                      if (commentText.isNotEmpty) {
                        print('Comment sent: $commentText');
                        _sendComment(commentText);
                      }

                      Navigator.of(context).pop(); // Close modal bottom sheet
                    },
                    child: Text("Send!"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close modal bottom sheet
                    },
                    child: Text("Close"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendComment(text) async {
    try {
      final ratingCollectionRef = FirebaseFirestore.instance
          .collection('songs')
          .doc(widget.songId)
          .collection('comments');

      final authorRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser?.uid);
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      final commentData = {
        'author': authorRef,
        'text': text,
        'time': timestamp,
      };
      await ratingCollectionRef.add(commentData);
    } catch (error) {
      print("Error updating document: $error");
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat('MMMM d, y - HH:mm').format(dateTime);
    return formattedTime;
  }
}
