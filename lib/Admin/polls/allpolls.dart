// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_constructors_in_immutables, unused_element, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPollsScreen extends StatefulWidget {
  @override
  _ViewPollsScreenState createState() => _ViewPollsScreenState();
}

class _ViewPollsScreenState extends State<ViewPollsScreen> {
  final CollectionReference _pollsCollection =
      FirebaseFirestore.instance.collection('polls');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All polls',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff392850),
      ),
      body: _buildPollList(),
    );
  }

  Widget _buildPollList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _pollsCollection.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final polls = snapshot.data!.docs;

        if (polls.isEmpty) {
          return Center(child: Text('No polls available.'));
        }

        // Sort the polls based on the 'date' field in descending order.
        polls.sort((a, b) {
          final DateTime timeA =
              (a.data() as Map<String, dynamic>)['date'].toDate();
          final DateTime timeB =
              (b.data() as Map<String, dynamic>)['date'].toDate();
          return timeB.compareTo(timeA);
        });

        return ListView.builder(
          itemCount: polls.length,
          itemBuilder: (context, index) {
            final pollData = polls[index].data() as Map<String, dynamic>;
            final pollId = polls[index].id;
            final poll = Poll.fromMap(pollData, pollId);

            return PollCard(poll: poll);
          },
        );
      },
    );
  }
}

class Poll {
  final String id;
  final String question;
  final List<String> options;
  final Map<String, int> votes;

  Poll(
      {required this.id,
      required this.question,
      required this.options,
      required this.votes});

  factory Poll.fromMap(Map<String, dynamic> data, String documentId) {
    return Poll(
      id: documentId,
      question: data['question'] ?? "N/A",
      options: List<String>.from(data['options'] ?? []),
      votes: Map<String, int>.from(data['votes'] ?? {}),
    );
  }
}

class PollCard extends StatelessWidget {
  final Poll poll;

  PollCard({required this.poll});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            title: Text(
              poll.question + "?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Column(
            children: poll.options.map((option) {
              return ListTile(
                title: Text(option),
                trailing: Text('Votes: ${poll.votes[option]}'),
                // IconButton(
                //   icon: Icon(Icons.thumb_up),
                //   onPressed: () => _vote(poll.id, option),
                // ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _vote(String pollId, String option) async {
    final pollReference =
        FirebaseFirestore.instance.collection('polls').doc(pollId);
    final pollSnapshot = await pollReference.get();
    final pollData = pollSnapshot.data() as Map<String, dynamic>;

    if (pollData != null && pollData['options'].contains(option)) {
      final votes = pollData['votes'] as Map<String, dynamic> ?? {};
      final currentCount = votes[option] ?? 0;
      votes[option] = currentCount + 1;

      await pollReference.update({'votes': votes});
    }
  }
}
