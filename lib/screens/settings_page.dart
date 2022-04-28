import 'package:eloit/screens/home.dart';
import 'package:eloit/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth/auth_widget.dart';

DatabaseService _db = DatabaseService();

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              children: [
                const Text(APP_NAME, style: TextStyle(fontSize: 60)),
                const SizedBox(height: 20),
                const Text("Rank Everything and Anything!",
                    style: TextStyle(fontSize: 30)),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // child: Image.asset(
                        //   'assets/eloitLogo.png',
                        // ),
                        child: Image.network("https://firebasestorage.googleapis.com/v0/b/eloit-c4540.appspot.com/o/eloitLogo.png?alt=media&token=0ff73827-47c3-464a-a609-05d762e9b7c5"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text("Creators: Harry, Xinli, Yofti, Jack, Kevin, Revant",
                    style: TextStyle(fontSize: 20)),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      textStyle: const TextStyle(fontSize: 20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Give Feedback',
                      style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.button?.color),
                    ),
                  ),
                  onPressed: () async {
                    return _displayTextInputDialog(context);
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      textStyle: const TextStyle(fontSize: 20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.button?.color),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // Now navigate to the auth page.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthBox(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

TextEditingController _textFieldController = TextEditingController();

Future<void> _displayTextInputDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 150),
        title: const Text('Feedback'),
        content: Column(
          children: [
            TextField(
              maxLines: 5,
              controller: _textFieldController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "What can we do better?"),
            ),
            const SizedBox(height: 20),
            const feedback(),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Submit'),
            onPressed: () {
              if (_textFieldController.text.isNotEmpty) {
                _db.addUserFeedback(_textFieldController.text, _feedbackTopic);
                _textFieldController.clear();
                _feedbackTopic = "Category";
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}

String _feedbackTopic =
    "Category"; //This is the selection value. It is also present in my array.
final _feedbackTopics = [
  "Category",
  "Search.",
  "Voting",
  "Vote History",
  "Other"
]; //This is the array for dropdown

class feedback extends StatefulWidget {
  const feedback({Key? key}) : super(key: key);

  @override
  Feedback createState() => Feedback();
}

class Feedback extends State<feedback> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(labelText: 'Area of Concern'),
      value: _feedbackTopic,
      validator: (value) {
        if (value == null) {
          return "can't empty";
        } else {
          return null;
        }
      },
      items: _feedbackTopics
          .map((String item) =>
              DropdownMenuItem<String>(child: Text(item), value: item))
          .toList(),
      onChanged: (String? value) {
        setState(() {
          _feedbackTopic = value as String;
        });
      },
    );
  }
}




// decoration: BoxDecoration(
//                         //border: Border.all(color: Color.fromARGB(255, 0, 0, 0), width: 5), // added
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(barPaddingHeight * 0.2),
//                           bottomRight: Radius.circular(barPaddingHeight * 0.2),
//                         ),
//                         color: widget.voted == voteState.beforeVote
//                           ? Colors.grey[600]
//                           : Colors.red,
//                       ),
//                     ),


