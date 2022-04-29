import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/item.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:eloit/screens/home.dart';
import 'package:eloit/screens/ui_elements.dart';
import 'package:eloit/screens/vote_page.dart';
import 'package:eloit/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum loadState {
  unloaded,
  loading,
  loaded,
}

class SelectRivalry extends StatefulWidget {
  const SelectRivalry({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  State<SelectRivalry> createState() => _SelectRivalryState();
}

class _SelectRivalryState extends State<SelectRivalry> {
  loadState loaded = loadState.unloaded;
  List<Competitor> competitors = [];
  Competitor? selectedCompetitor1;
  Competitor? selectedCompetitor2;

  final DatabaseService _db = DatabaseService();

  void getCompetitors() async {
    competitors = await _db.getCompetitors(widget.category);
    setState(() {
      loaded = loadState.loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loaded == loadState.unloaded) {
      getCompetitors();
      setState(() {
        loaded = loadState.loading;
      });
    }

    if (loaded != loadState.loaded) {
      return const LinearProgressIndicator();
    }

    double pageWidth = MediaQuery.of(context).size.width;
    double avatarRadius = pageWidth / 8;
    return Scaffold(
      appBar: createCustomAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: NetworkImage(
                          selectedCompetitor1?.item.avatarURL ?? 'none'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DropdownButton<Competitor>(
                        hint: const Text('Select Competitor 1'),
                        // Initial Value
                        value: selectedCompetitor1,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items: competitors.map((Competitor competitor) {
                          return DropdownMenuItem(
                            value: competitor,
                            child: Text(competitor.item.name),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (Competitor? newValue) {
                          setState(() {
                            selectedCompetitor1 = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: NetworkImage(
                          selectedCompetitor2?.item.avatarURL ?? 'none'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DropdownButton<Competitor>(
                        hint: const Text('Select Competitor 2'),
                        // Initial Value
                        value: selectedCompetitor2,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items: competitors.map((Competitor competitor) {
                          return DropdownMenuItem(
                            value: competitor,
                            child: Text(competitor.item.name),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (Competitor? newValue) {
                          setState(() {
                            selectedCompetitor2 = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              Rivalry rivalry = await _db.createRivalry(widget.category.cid,
                  selectedCompetitor1!, selectedCompetitor2!);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      VotePage(category: widget.category, rivalry: rivalry),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
