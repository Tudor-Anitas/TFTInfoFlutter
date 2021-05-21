import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tft_gg/trait.dart';
import 'package:tft_gg/unit.dart';

class ApiCalls{
  String _key = 'RGAPI-51f7df00-1077-4e64-979b-971fce3a6c56';

  Future<Map<String, dynamic>> getSummoner(String summonerName, String region) async{
    Uri uri; Uri.parse("https://eun1.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);

    switch(region){
      case 'br1':
        uri = Uri.parse("https://br1.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);
        break;
      case 'eun1':
        uri = Uri.parse("https://eun1.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);
        break;
      case 'euw1':
        uri = Uri.parse("https://euw1.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);
        break;
      case 'jp1':
        uri = Uri.parse("https://jp1.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);
        break;
      case 'kr':
        uri = Uri.parse("https://kr.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);
        break;
      case 'na1':
        uri = Uri.parse("https://na1.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);
        break;
      case 'oc1':
        uri = Uri.parse("https://oc1.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);
        break;
      case 'ru':
        uri = Uri.parse("https://ru.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);
        break;
      case 'tr1':
        uri = Uri.parse("https://tr1.api.riotgames.com/tft/summoner/v1/summoners/by-name/" + summonerName + "?api_key=" + _key);
        break;
    }

    var response = await http.get(uri);
    var code = response.statusCode;
    var finalResponse = json.decode(response.body);

    if(code == 200){
      Map<String, dynamic> result = Map();
      result['puuid'] = finalResponse['puuid'];
      result['summonerLevel'] = finalResponse['summonerLevel'];
      result['id'] = finalResponse['id'];

      return result;
    } else{
      return null;
    }
  }

  Future<String> getRank(String id, String region) async {
    String rank = '';
    Uri uri;

    switch(region){
      case 'br1':
        uri = Uri.parse('https://br1.api.riotgames.com/tft/league/v1/entries/by-summoner/' + id + '?api_key=' + _key);
        break;
      case 'eun1':
        uri = Uri.parse('https://eun1.api.riotgames.com/tft/league/v1/entries/by-summoner/' + id + '?api_key=' + _key);
        break;
      case 'euw1':
        uri = Uri.parse('https://euw1.api.riotgames.com/tft/league/v1/entries/by-summoner/' + id + '?api_key=' + _key);
        break;
      case 'jp1':
        uri = Uri.parse('https://jp1.api.riotgames.com/tft/league/v1/entries/by-summoner/' + id + '?api_key=' + _key);
        break;
      case 'kr':
        uri = Uri.parse('https://kr.api.riotgames.com/tft/league/v1/entries/by-summoner/' + id + '?api_key=' + _key);
        break;
      case 'na1':
        uri = Uri.parse('https://na1.api.riotgames.com/tft/league/v1/entries/by-summoner/' + id + '?api_key=' + _key);
        break;
      case 'oc1':
        uri = Uri.parse('https://oc1.api.riotgames.com/tft/league/v1/entries/by-summoner/' + id + '?api_key=' + _key);
        break;
      case 'ru':
        uri = Uri.parse('https://ru.api.riotgames.com/tft/league/v1/entries/by-summoner/' + id + '?api_key=' + _key);
        break;
      case 'tr1':
        uri = Uri.parse('https://tr1.api.riotgames.com/tft/league/v1/entries/by-summoner/' + id + '?api_key=' + _key);
        break;
    }

    var response = await http.get(uri);
    var finalResponse = json.decode(response.body);
    for(var details in finalResponse){
      if(details['queueType'] == 'RANKED_TFT'){
        rank = '${details['tier']} ${details['rank']}';
      }else if(details['queueType'] == 'RANKED_TFT_TURBO'){
        rank = '${details['ratedTier']} ${details['ratedRating']}';
      }
  }
    return rank;
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
          String name = trait['name'].substring(5);
          traits.add(Trait(name: name, style: trait['style']));
        }
        for(var unit in participant['units']){
          String name = unit['character_id'].substring(5);
          units.add(Unit(name: name, tier: unit['tier']));
        }
        player['traits'] = traits;
        player['units'] = units;
        break;
      }

    return player;
  }
}