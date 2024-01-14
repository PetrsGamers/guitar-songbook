import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../firebase/firebase_auth_services.dart';

class CommentScreen extends StatefulWidget {
  final String? songId;
  const CommentScreen({required this.songId, Key? key}) : super(key: key);

  @override
  CommentScreenState createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  final User? _currentUser = Auth().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
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
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No comments yet'),
            ); // Display when no comments are available
          }

          // Process comments and user details
          return FutureBuilder<List<Widget>>(
            future: _getUserComments(snapshot.data!.docs),
            builder: (BuildContext context,
                AsyncSnapshot<List<Widget>> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError) {
                return Text('Error: ${userSnapshot.error}');
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
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<Widget>> _getUserComments(List<DocumentSnapshot> comments) async {
    comments.sort(
        (a, b) => (b['time'] as Timestamp).compareTo(a['time'] as Timestamp));

    List<Widget> commentWidgets = [];

    for (DocumentSnapshot comment in comments) {
      Map<String, dynamic> commentData = comment.data() as Map<String, dynamic>;
      DocumentReference userRef = commentData['author'];

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userRef.id)
          .get();
      Map<String, dynamic>? userData = userSnapshot.data();
      commentWidgets.add(
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userData?['picture'] ?? ''),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/profile/${userRef.id}');
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userData?['name'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Text(
                    _formatTimestamp(commentData['time']),
                    style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Wrap(
                  children: [
                    Text(
                      commentData['text'] ?? '',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    if (userRef.id == _currentUser?.uid)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            final commentRef = comment.reference;
                            commentRef.delete();
                          },
                          child: const Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                  ],
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
    TextEditingController _textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Type your comment here',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String commentText = _textController.text.trim();
                      if (commentText.isNotEmpty) {
                        _sendComment(commentText);
                      }

                      Navigator.of(context).pop(); // Close modal bottom sheet
                    },
                    child: const Text("Send!"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close modal bottom sheet
                    },
                    child: const Text("Close"),
                  ),
                  const SizedBox(height: 32.0),
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
      final _ratingCollectionRef = FirebaseFirestore.instance
          .collection('songs')
          .doc(widget.songId)
          .collection('comments');

      final _authorRef =
          FirebaseFirestore.instance.collection('users').doc(_currentUser?.uid);
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      final _commentData = {
        'author': _authorRef,
        'text': text,
        'time': timestamp,
      };
      await _ratingCollectionRef.add(_commentData);
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
