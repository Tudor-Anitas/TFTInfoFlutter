import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tft_gg/trait.dart';
import 'package:tft_gg/unit.dart';

class ApiCalls{
  String _key = 'RGAPI-774aad37-8b2c-4005-b4f9-689df4dad8ab';

  Future<String> getSummoner(String summonerName) async{

    Uri uri = Uri.parse("https://eun1.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);
    var response = await http.get(uri);
    var finalResponse = json.decode(response.body);

    return finalResponse['puuid'];
  }

  Future<List<String>> getMatches(String puuid, String region) async{
    Uri uri;
    List<String> matchIds = [];

    switch(region){
      case 'europe':
        uri = Uri.parse('https://europe.api.riotgames.com/tft/match/v1/matches/by-puuid/' + puuid + '/ids?count=20&api_key=' + _key);
        break;
      case 'america':
        uri = Uri.parse('https://americas.api.riotgames.com/tft/match/v1/matches/by-puuid/' + puuid + '/ids?count=20&api_key=' + _key);
        break;
      case 'asia':
        uri = Uri.parse('https://asia.api.riotgames.com/tft/match/v1/matches/by-puuid/' + puuid + '/ids?count=20&api_key=' + _key);
        break;
    }

    var response = await http.get(uri);
    var finalResponse = json.decode(response.body);

    for(String match in finalResponse)
      matchIds.add(match);

    return matchIds;
  }

  Future<Map<String, dynamic>> getMatchDetails(String puuid, String matchId, String region) async{
    Uri uri;
    Map<String, dynamic> player = Map();
    List<Trait> traits = [];
    List<Unit> units = [];

    switch(region){
      case 'europe':
        uri = Uri.parse('https://europe.api.riotgames.com/tft/match/v1/matches/' + matchId + '?api_key=' + _key);
        break;
      case 'america':
        uri = Uri.parse('https://americas.api.riotgames.com/tft/match/v1/matches/' + matchId + '?api_key=' + _key);
        break;
      case 'asia':
        uri = Uri.parse('https://asia.api.riotgames.com/tft/match/v1/matches/' + matchId + '?api_key=' + _key);
        break;
    }

    var response = await http.get(uri);
    var finalResponse = json.decode(response.body);

    for(var participant in finalResponse['info']['participants'])
      if(participant['puuid'] == puuid){
        player['companion'] = participant['companion']['species'];
        player['players_eliminated'] = participant['players_eliminated'];
        player['total_damage_to_players'] = participant['total_damage_to_players'];
        player['placement'] = participant['placement'];
        for(var trait in participant['traits']){
          traits.add(Trait(name: trait['name'], style: trait['style']));
        }
        for(var unit in participant['units']){
          units.add(Unit(name: unit['character_id'], tier: unit['tier']));
        }
        player['traits'] = traits;
        player['units'] = units;
        break;
      }

    return player;
  }
}