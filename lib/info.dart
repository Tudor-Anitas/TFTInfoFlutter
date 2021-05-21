import 'dart:collection';

import 'package:tft_gg/unit.dart';

class Info{
  String summonerName;
  int summonerLevel;
  String league;
  int playersEliminated;
  int dmgToPlayers;
  String companion;
  Map<int, int> placements;
  LinkedHashMap traits;
  LinkedHashMap units;

  Info({this.summonerName, this.summonerLevel, this.league, this.playersEliminated, this.dmgToPlayers,
      this.companion, this.placements, this.traits, this.units});
}