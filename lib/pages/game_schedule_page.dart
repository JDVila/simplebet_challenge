import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simplebet_challenge/util/logo_util.dart';
import 'package:simplebet_challenge/widgets/game_tile_widget.dart';

class GameSchedulePage extends StatefulWidget {
  @override
  _GameSchedulePageState createState() => _GameSchedulePageState();
}

class _GameSchedulePageState extends State<GameSchedulePage> {
  static const String _GAME_SCHEDULE_PAGE_TITLE = 'TODAY\'S GAMES';

  static const String _SCHEDULE_URL_ENDPOINT =
      'https://statsapi.mlb.com/api/v1/schedule/?sportId=1&date=09/29/2019';
  static const String _BASE_GAMESCORE_URL_ENDPOINT =
      'https://statsapi.mlb.com/api/v1.1/game/';
  static const String _SUFFIX_GAMESCORE_URL_ENDPOINT =
      '/feed/live?fields=liveData,linescore,teams,away,home,runs';

  List<Widget> _finalGameList;

  void getGameTileList() async {
    List<Widget> gameList = [];
    http.Response scheduleResponse = await http.get(_SCHEDULE_URL_ENDPOINT);
    var scheduleGameJsonList = JsonDecoder().convert(scheduleResponse.body);
    List games = scheduleGameJsonList['dates'][0]['games'];

    for (int i = 0; i < games.length; i++) {
      int gamePk = games[i]['gamePk'];
      var gameScoreJson = JsonDecoder().convert((await http.get(
              '$_BASE_GAMESCORE_URL_ENDPOINT$gamePk$_SUFFIX_GAMESCORE_URL_ENDPOINT'))
          .body);

      int finalAwayScore =
          gameScoreJson['liveData']['linescore']['teams']['away']['runs'];
      ImageProvider awayImageProvider =
          IdLogoUtil.getImageProvider(games[i]['teams']['away']['team']['id']);
      String awayAbbrev =
          IdLogoUtil.getAbbrev(games[i]['teams']['away']['team']['id']);
      String gameScoreStatus = games[i]['status']['abstractGameState'];
      int finalHomeScore =
          gameScoreJson['liveData']['linescore']['teams']['home']['runs'];
      ImageProvider homeImageProvider =
          IdLogoUtil.getImageProvider(games[i]['teams']['home']['team']['id']);
      String homeAbbrev =
          IdLogoUtil.getAbbrev(games[i]['teams']['home']['team']['id']);

      GameTileModel gameTileModel = GameTileModel(
        gamePk: gamePk,
        awayImageProvider: awayImageProvider,
        awayAbbrev: awayAbbrev,
        finalAwayScore: finalAwayScore,
        gameScoreStatus: gameScoreStatus,
        finalHomeScore: finalHomeScore,
        homeImageProvider: homeImageProvider,
        homeAbbrev: homeAbbrev,
      );

      gameList.add(GameTile(
        gameTileModel: gameTileModel,
      ));
    }
    setState(() {
      _finalGameList = gameList;
    });
  }

  @override
  void initState() {
    super.initState();
    getGameTileList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_GAME_SCHEDULE_PAGE_TITLE),
        ),
        body: Center(
          child: null != _finalGameList
              ? ListView(
                  children: _finalGameList,
                )
              : CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
        ),
      ),
    );
  }
}
