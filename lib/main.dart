import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tft_gg/loading_page.dart';
import 'package:tft_gg/results_page.dart';

import 'networking.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController summonerController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Container(
        width: windowWidth,
        height: windowHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff6200EE), Color(0xffB400ED)]
          )
        ),
        child: Column(
          children: [
            //------------------------ pingu image
            AnimatedContainer(
              duration: Duration(milliseconds: 50),
              curve: Curves.easeInOut,
              width: windowWidth * 0.9,
              height: windowHeight * 0.25,
              margin: MediaQuery.of(context).viewInsets.bottom != 0? EdgeInsets.only(top: 10) : EdgeInsets.only(top: windowHeight * 0.1),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage('assets/images/pingu.jpg'),
                      fit: BoxFit.fill
                    )
                  ),
              )
            ),
            //------------------------ heading
            AnimatedContainer(
              duration: Duration(milliseconds: 50),
              curve: Curves.easeInOut,
              width: windowWidth * 0.8,
              margin: MediaQuery.of(context).viewInsets.bottom != 0? EdgeInsets.only(top: windowHeight * 0.06) : EdgeInsets.only(top: windowHeight * 0.15),
              child: Text(
                'Search a summoner',
                style: GoogleFonts.spaceGrotesk(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            //------------------------ search bar
            Container(
              width: windowWidth * 0.8,
              height: windowHeight * 0.07,
              margin: EdgeInsets.only(top: windowHeight * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  border: InputBorder.none,
                ),
                controller: summonerController,
                style: TextStyle(
                  fontSize: 24
                ),
              ),
            ),
            //------------------------ button
            Container(
              width: windowWidth * 0.27,
              height: windowHeight * 0.07,
              margin: EdgeInsets.only(top: windowHeight * 0.05),
              decoration: BoxDecoration(
                color: Color(0xffF06400),
                borderRadius: BorderRadius.circular(8)
              ),
              child: MaterialButton(
                onPressed: () async {

                  Navigator.push(context, PageTransition(type: PageTransitionType.rippleLeftDown, child: LoadingPage()));
                  var start = DateTime.now();

                  // get the puuid of the searched summoner
                  String puuid = await ApiCalls().getSummoner(summonerController.text.trim());
                  // get the last 20 matches of the player
                  List<String> lastMatches = await ApiCalls().getMatches(puuid, 'europe');

                  // get the stats from the last matches
                  List<Map<String,dynamic>> matchResults = [];
                  for(int i=0; i<20; i++){
                    Map<String,dynamic> match = await ApiCalls().getMatchDetails(puuid, lastMatches[i], 'europe');
                    matchResults.add(match);
                  }

                  // calculate the general stats of the player
                  calculateGeneralInfo(matchResults);
                  var end = DateTime.now();

                  print(end.difference(start).inMilliseconds);
                },
                child: Text('Go', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  calculateGeneralInfo(List<Map<String, dynamic>> matches){
    int playersEliminated = 0;
    int dmgToPlayers = 0;
    Map<String, int> companions = Map();
    Map<int, int> placements = Map();
    Map<String, int> traits = Map();
    Map<String, int> units = Map();
    Map<String, dynamic> stats = Map();


    for(var match in matches){
      playersEliminated += match['players_eliminated'];
      dmgToPlayers += match['total_damage_to_players'];

      if(companions.containsKey(match['companion']))
        companions[match['companion']] = companions[match['companion']] + 1;
      else
        companions[match['companion']] = 1;

      if(placements.containsKey(match['placement']))
        placements[match['placement']] = placements[match['placement']] + 1;
      else
        placements[match['placement']] = 1;

      for(var trait in match['traits']){
        if(traits.containsKey(trait.name))
          traits[trait.name] = traits[trait.name] + 1;
        else
          traits[trait.name] = 1;
      }
    }

    stats['players_eliminated'] = playersEliminated;
    stats['total_damage_to_players'] = dmgToPlayers;
    stats['placements'] = placements;

    int maxOccurences = 0;
    String currentPet = '';
    companions.forEach((key, value) {
      if(value > maxOccurences){
        maxOccurences = value;
        currentPet = key;
      }
    });
    stats['companion'] = currentPet;

    print('players eliminated $playersEliminated');
    print('total damage $dmgToPlayers');
    print('placements ${stats['placements']}');

    Navigator.push(context, PageTransition(child: ResultsPage(), type: PageTransitionType.rippleLeftDown));
  }
}

