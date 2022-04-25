import 'package:eloit/screens/home.dart';
import 'package:eloit/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



import 'auth/auth_widget.dart';
DatabaseService _db = DatabaseService();

class SettingsPage extends StatelessWidget {
  //const SettingsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
            Text("Eloit", 
            style: TextStyle(
                  fontSize: 60)
            ),
            SizedBox(height: 20),
            Text("Rank Everything and Anything!", 
            style: TextStyle(
                  fontSize: 30)
            ),
            SizedBox(height: 20),
            Image.asset('assets/eloitLogo.png',
            //scale: MediaQuery.of(context).size. * 0.1,
            width: MediaQuery.of(context).size.width / 3,
            //height: MediaQuery.of(context).size.height / 5,
      
            
            ),
      
            SizedBox(height: 30),
            Text("Creators: Harry, Xinli, Yofti, Jack, Kevin, Revant", 
            style: TextStyle(
                  fontSize: 20)
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green, textStyle: const TextStyle(fontSize: 20)),
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
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red, textStyle: const TextStyle(fontSize: 20)),
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

            
              
          ],),
        ),
      )
    );
  }
}


TextEditingController _textFieldController = TextEditingController();


Future<void> _displayTextInputDialog(BuildContext context) async {
  
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(vertical: 150),
          title: Text('Feedback'),
          // content: TextField(
          //   controller: _textFieldController,
          //   decoration: InputDecoration(hintText: "What can we do better?"),
          // ),
          content: Column(children: [
            TextField(
              maxLines: 5,
              controller: _textFieldController,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: "What can we do better?"),
            ),
            SizedBox(height: 20),
            feedback(),

        
          ],),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                if (_textFieldController.text != null){
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

String _feedbackTopic = "Category"; //This is the selection value. It is also present in my array.
final _feedbackTopics = ["Category", "Search.", "Voting", "Vote History", "Other"];//This is the array for dropdown


class feedback extends StatefulWidget{
  Feedback createState()=> Feedback();
}

class Feedback extends State<feedback>{
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText:'Area of Concern'),
      value: _feedbackTopic,
      validator: (value) {
        if (value==null) {
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
            print("previous");
            _feedbackTopic = value as String;
          });
        },
    );
  }
}
