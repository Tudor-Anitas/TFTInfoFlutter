import 'dart:async';
import 'dart:collection';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tft_gg/ad_state.dart';
import 'package:tft_gg/info.dart';
import 'package:tft_gg/loading_page.dart';
import 'package:tft_gg/results_page.dart';
import 'package:tft_gg/trait.dart';
import 'package:tft_gg/unit.dart';

import 'networking.dart';

//final adStateProvider = ScopedProvider<AdState>(null);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final adsInitialization = MobileAds.instance.initialize();
  //final adState = AdState(initialization: adsInitialization);
  //await dotenv.load(fileName: ".env");
  runApp(
      ProviderScope(
        overrides: [
          //adStateProvider.overrideWithValue(adState)
        ],
        child: MyApp()
      )
  );
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
  Info playerInfo = Info();

  String region = 'eun1';

  var bannerAd;



  // @override
  // void initState() {
  //   super.initState();
  //   final adState = context.read(adStateProvider);
  //   bannerAd = BannerAd(
  //       size: AdSize.largeBanner,
  //       adUnitId: adState.bannerAdUnitId,
  //       listener: adState.listener,
  //       request: AdRequest()
  //   )..load();

  // }

  // @override
  // void didChangeDependencies() {
  //   final adState = context.read(adStateProvider);
  //   adState.initialization.then((value){
  //     bannerAd = BannerAd(
  //       size: AdSize.largeBanner,
  //       adUnitId: adState.bannerAdUnitId,
  //       listener: adState.listener,
  //       request: AdRequest()
  //     )..load();
  //   });
  // }

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
        child: SingleChildScrollView(
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
                child: Row(
                  children: [
                    Container(
                      width: windowWidth * 0.63,
                      height: windowHeight * 0.07,
                      margin: EdgeInsets.only(top: windowHeight * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))
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
                    //----------------------------- Dropdown
                    Container(
                      width: windowWidth * 0.17,
                      height: windowHeight * 0.07,
                      margin: EdgeInsets.only(top: windowHeight * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(left: BorderSide.none),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))
                      ),
                      child: DropdownButton(
                          value: region,
                          items: [
                            DropdownMenuItem(child: Text('EUNE'), value: 'eun1',),
                            DropdownMenuItem(child: Text('EUW'), value: 'euw1',),
                            DropdownMenuItem(child: Text('NA'), value: 'na1',),
                            DropdownMenuItem(child: Text('KR'), value: 'kr',),
                            DropdownMenuItem(child: Text('JP'), value: 'jp1',),
                            DropdownMenuItem(child: Text('OCE'), value: 'oc1',),
                            DropdownMenuItem(child: Text('RU'), value: 'ru',),
                            DropdownMenuItem(child: Text('TUR'), value: 'tr1',),
                            DropdownMenuItem(child: Text('BR'), value: 'br1',),
                          ],
                          underline: Container(),
                          onChanged: (value){
                            setState(() {
                              region = value;
                            });
                          },
                      ),
                    )
                  ],
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
                    Map<String, dynamic> summonerData = Map();
                    Navigator.push(context, PageTransition(type: PageTransitionType.rippleLeftDown, child: LoadingPage()));
                    var start = DateTime.now();

                    // get the puuid & the level of the searched summoner
                    summonerData = await ApiCalls().getSummoner(summonerController.text.trim(), region);
                    if(summonerData == null){
                      SnackBar snackBar = SnackBar(content: Text('Summoner not found!'),);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      // try and get the rank of the player async
                      ApiCalls().getRank(summonerData['id'], region).then((value) => playerInfo.league = value);

                      String puuid = summonerData['puuid'];

                      playerInfo.summonerName = summonerController.text.trim();
                      playerInfo.summonerLevel = summonerData['summonerLevel'];

                      // get the last 20 matches of the player
                      List<String> lastMatches = await ApiCalls().getMatches(
                          puuid, region);

                      // get the stats from the last matches
                      List<Map<String, dynamic>> matchResults = [];
                      for (int i = 0; i < 20; i++) {
                        Map<String, dynamic> match = await ApiCalls()
                            .getMatchDetails(puuid, lastMatches[i], 'europe');
                        matchResults.add(match);
                      }

                      // calculate the general stats of the player
                      calculateGeneralInfo(matchResults);
                      var end = DateTime.now();

                      print(end
                          .difference(start)
                          .inMilliseconds);
                    }
                  },
                  child: Text('Go', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Colors.white),),
                ),
              ),
              //------------------------ banner ad
              // Container(
              //   width: windowWidth,
              //   height: windowHeight * 0.07,
              //   margin: EdgeInsets.only(top: windowHeight * 0.1),
              //   child: AdWidget(ad: bannerAd as BannerAd,),
              // )
            ],
          ),
        ),
      ),
    );
  }

  calculateGeneralInfo(List<Map<String, dynamic>> matches){
    int playersEliminated = 0;
    int dmgToPlayers = 0;
    Map<String, int> companions = Map();
    Map<int, int> placements = Map();
    Map<String, Trait> traits = Map();
    Map<String, Unit> units = Map();

    // to avoid getting a null on a placement
    for(int i = 0; i<8; i++)
      placements[i+1] = 0;

    // process the information from all the games to calculate averages
    for(var match in matches){
      playersEliminated += match['players_eliminated'];
      dmgToPlayers += match['total_damage_to_players'];
      if(companions.containsKey(match['companion']))
        companions[match['companion']] = companions[match['companion']] + 1;
      else
        companions[match['companion']] = 1;

      placements[match['placement']] = placements[match['placement']] + 1;

      for(Trait trait in match['traits']){
        if(traits.containsKey(trait.name)){
          Trait current = traits[trait.name];
          current.count += 1;
          traits[trait.name] = current;
        }
        else{
          Trait current = trait;
          current.count = 1;
          traits[trait.name] = current;
        }
      }
      for(Unit unit in match['units']){
        if(units.containsKey(unit.name)){
          Unit current = units[unit.name];
          current.count += 1;
          units[unit.name] = current;
        }
        else{
          Unit current = unit;
          current.count = 1;
          units[unit.name] = current;
        }
      }
    }

    int maxOccurences = 0;
    String currentPet = '';
    companions.forEach((key, value) {
      if(value > maxOccurences){
        maxOccurences = value;
        currentPet = key;
      }
    });
    // sorting the traits descending
    print('BEFORE SORTING=============================================');
    //traits.forEach((key, value) { print('${key.name} $value');});
    var sortedTraitsKeys = traits.keys.toList(growable: false)..sort((k1, k2) => traits[k2].count.compareTo(traits[k1].count));
    LinkedHashMap sortedTraits = LinkedHashMap.fromIterable(sortedTraitsKeys, key: (k) => k, value: (k) => traits[k]);
    //print('BEFORE SORTING=============================================');
    //sortedTraits.forEach((key, value) { print('$key ${value.count}');});

    // sorting the units
    print('BEFORE SORTING=============================================');
    //units.forEach((key, value) { print('${key.name} $value');});
    var sortedUnitsKeys = units.keys.toList(growable: false)..sort((k1,k2) => units[k2].count.compareTo(units[k1].count));
    LinkedHashMap sortedUnits = LinkedHashMap.fromIterable(sortedUnitsKeys, key: (k) => k, value: (k) => units[k]);
    print('AFTER SORTING==============================================');
    //sortedUnits.forEach((key, value) { print('${key.name} $value');});

    playerInfo.playersEliminated = playersEliminated;
    playerInfo.dmgToPlayers = dmgToPlayers;
    playerInfo.companion = currentPet;
    playerInfo.placements = placements;
    playerInfo.traits = sortedTraits;
    playerInfo.units = sortedUnits;

    print('players eliminated $playersEliminated');
    print('total damage $dmgToPlayers');
    for(var trait in playerInfo.traits.entries){
        print('${trait.value.name}_${trait.value.count}');
    }
    


    Navigator.pushReplacement(context, PageTransition(child: ResultsPage(playerInfo: playerInfo,), type: PageTransitionType.rippleLeftDown));
  }

}

