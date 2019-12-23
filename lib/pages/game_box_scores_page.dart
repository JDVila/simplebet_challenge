import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simplebet_challenge/widgets/game_tile_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameBoxScoresPage extends StatefulWidget {
  final GameTileModel gameTileModel;

  GameBoxScoresPage({@required this.gameTileModel});

  @override
  _GameBoxScoresPageState createState() => _GameBoxScoresPageState();
}

class _GameBoxScoresPageState extends State<GameBoxScoresPage> {
  static const String _BASE_LINESCORE_URL_ENDPOINT =
      'https://statsapi.mlb.com/api/v1/game/';
  static const String _SUFFIX_LINESCORE_URL_ENDPOINT = '/linescore';
  static const String _BASE_PLAYER_URL_ENDPOINT =
      'https://statsapi.mlb.com/api/v1.1/game/';
  static const String _SUFFIX_PLAYER_URL_ENDPOINT =
      '/feed/live?fields=liveData,boxscore,teams,id,batters,pitchers,battingOrder';
  static const String _BASE_PEOPLE_URL_ENDPOINT =
      'http://statsapi.mlb.com/api/v1/people/';
  static const String _BASE_PEOPLE_GAME_STATS_URL_ENDPOINT =
      'http://statsapi.mlb.com/api/v1/people/';
  static const String _INFIX_PEOPLE_GAME_STATS_URL_ENDPOINT = '/stats/game/';

  List<TableRow> _finalLineScoreList = [];

  Widget _awayStats;
  Widget _homeStats;

  StatsClicked statsClicked = StatsClicked.AWAY;

  @override
  void initState() {
    super.initState();
    getLineScoreList();
    getHittersPitchersWidgets();
  }

  TableRow _createPitcherStatsTableRow(String name, String inningsPitched,
      String hits, String runs, String strikeOuts, int index) {
    List<Widget> rowWidgets = [];
    rowWidgets.add(
      Container(
        color: index != -1 && index % 2 == 0 ? Colors.grey[200] : null,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: RichText(
            text: TextSpan(
              text: name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: index != -1 ? FontWeight.normal : FontWeight.bold,
              ),
              children: [],
            ),
          ),
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );

    List params = [inningsPitched, hits, runs, strikeOuts];

    for (int i = 0; i < params.length; i++) {
      rowWidgets.add(
        Container(
          color: index != -1 && index % 2 == 0 ? Colors.grey[200] : null,
          alignment: Alignment.centerRight,
          child: Text(
            params[i],
            style: TextStyle(
              fontWeight: index != -1 ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          padding: EdgeInsets.all(8.0),
        ),
      );
    }
    return TableRow(children: rowWidgets);
  }

  TableRow _createBatterStatsTableRow(String name, String role, String atBats,
      String runs, String hits, String rbi, int index) {
    List<Widget> rowWidgets = [];
    rowWidgets.add(
      Container(
        color: index != -1 && index % 2 == 0 ? Colors.grey[200] : null,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: RichText(
            text: TextSpan(
              text: name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: index != -1 ? FontWeight.normal : FontWeight.bold,
              ),
              children: [
                null != role
                    ? TextSpan(
                        text: ' $role',
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      )
                    : TextSpan(text: ''),
              ],
            ),
          ),
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );

    List params = [atBats, runs, hits, rbi];

    for (int i = 0; i < params.length; i++) {
      rowWidgets.add(
        Container(
          color: index != -1 && index % 2 == 0 ? Colors.grey[200] : null,
          alignment: Alignment.centerRight,
          child: Text(
            params[i],
            style: TextStyle(
              fontWeight: index != -1 ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          padding: EdgeInsets.all(8.0),
        ),
      );
    }
    return TableRow(children: rowWidgets);
  }

  TableRow _createLineScoreTableRow(
      String team,
      List<dynamic> inningsList,
      String runs,
      String hits,
      String errors,
      LineScoreRowType lineScoreRowType) {
    List<Widget> rowWidgets = [];
    rowWidgets.add(
      Container(
        color: lineScoreRowType == LineScoreRowType.HEADER
            ? Colors.grey[200]
            : null,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            team,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
    for (int i = 0; i < inningsList.length; i++) {
      rowWidgets.add(
        Container(
          color: lineScoreRowType == LineScoreRowType.HEADER
              ? Colors.grey[200]
              : null,
          alignment: Alignment.center,
          child: Text(
            lineScoreRowType == LineScoreRowType.HEADER
                ? '${inningsList[i]['num']}'
                : lineScoreRowType == LineScoreRowType.AWAY
                    ? '${inningsList[i]['away']['runs']}'
                    : '${inningsList[i]['home']['runs']}',
            style: TextStyle(),
          ),
          padding: EdgeInsets.all(8.0),
        ),
      );
    }
    rowWidgets.add(
      Container(
        color: lineScoreRowType == LineScoreRowType.HEADER
            ? Colors.grey[200]
            : null,
        alignment: Alignment.center,
        child: Text(
          runs,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
    rowWidgets.add(
      Container(
        color: lineScoreRowType == LineScoreRowType.HEADER
            ? Colors.grey[200]
            : null,
        alignment: Alignment.center,
        child: Text(
          hits,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
    rowWidgets.add(
      Container(
        color: lineScoreRowType == LineScoreRowType.HEADER
            ? Colors.grey[200]
            : null,
        alignment: Alignment.center,
        child: Text(
          errors,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
    return TableRow(children: rowWidgets);
  }

  void getLineScoreList() async {
    http.Response lineScoreResponse = await http.get(
        '$_BASE_LINESCORE_URL_ENDPOINT${widget.gameTileModel.gamePk}$_SUFFIX_LINESCORE_URL_ENDPOINT');
    var lineScoreJsonList = JsonDecoder().convert(lineScoreResponse.body);
    List innings = lineScoreJsonList['innings'];
    TableRow headerTableRow = _createLineScoreTableRow(
        '   ', innings, 'R', 'H', 'E', LineScoreRowType.HEADER);
    TableRow awayTableRow = _createLineScoreTableRow(
        widget.gameTileModel.awayAbbrev,
        innings,
        '${lineScoreJsonList['teams']['away']['runs']}',
        '${lineScoreJsonList['teams']['away']['hits']}',
        '${lineScoreJsonList['teams']['away']['errors']}',
        LineScoreRowType.AWAY);

    TableRow homeTableRow = _createLineScoreTableRow(
        widget.gameTileModel.homeAbbrev,
        innings,
        '${lineScoreJsonList['teams']['home']['runs']}',
        '${lineScoreJsonList['teams']['home']['hits']}',
        '${lineScoreJsonList['teams']['home']['errors']}',
        LineScoreRowType.AWAY);

    setState(() {
      _finalLineScoreList.add(headerTableRow);
      _finalLineScoreList.add(awayTableRow);
      _finalLineScoreList.add(homeTableRow);
    });
  }

  void getHittersPitchersWidgets() async {
    http.Response playerResponse = await http.get(
        '$_BASE_PLAYER_URL_ENDPOINT${widget.gameTileModel.gamePk}$_SUFFIX_PLAYER_URL_ENDPOINT');
    var playerjsonList = JsonDecoder().convert(playerResponse.body);

    List awayTeamHitters =
        playerjsonList['liveData']['boxscore']['teams']['away']['batters'];
    List awayTeamPitchers =
        playerjsonList['liveData']['boxscore']['teams']['away']['pitchers'];
    List homeTeamHitters =
        playerjsonList['liveData']['boxscore']['teams']['home']['batters'];
    List homeTeamPitchers =
        playerjsonList['liveData']['boxscore']['teams']['home']['pitchers'];

    List<TableRow> awayBattersTableRows = [];
    awayBattersTableRows.add(
      _createBatterStatsTableRow('HITTERS', null, 'AB', 'R', 'H', 'RBI', -1),
    );

    int totalAwayHittersAtBats = 0;
    int totalAwayHittersRuns = 0;
    int totalAwayHittersHits = 0;
    int totalAwayHittersRbi = 0;

    for (int i = 0; i < awayTeamHitters.length; i++) {
      http.Response individualPlayerResponse =
          await http.get('$_BASE_PEOPLE_URL_ENDPOINT${awayTeamHitters[i]}/');
      http.Response individualPlayerStatsResponse = await http.get(
          '$_BASE_PEOPLE_GAME_STATS_URL_ENDPOINT${awayTeamHitters[i]}$_INFIX_PEOPLE_GAME_STATS_URL_ENDPOINT${widget.gameTileModel.gamePk}');
      String playerFirstName = JsonDecoder()
          .convert(individualPlayerResponse.body)['people'][0]['firstName'];
      String playerLastName = JsonDecoder()
          .convert(individualPlayerResponse.body)['people'][0]['lastName'];
      String fullName = '${playerFirstName.substring(0, 1)}. $playerLastName';
      String playerRole =
          JsonDecoder().convert(individualPlayerResponse.body)['people'][0]
              ['primaryPosition']['abbreviation'];
      List groups = JsonDecoder()
          .convert(individualPlayerStatsResponse.body)['stats'][0]['splits'];
      String awayHittersAtBats = '---';
      String awayHittersRuns = '---';
      String awayHittersHits = '---';
      String awayHittersRbi = '---';

      for (int j = 0; j < groups.length; j++) {
        if (groups[j]['group'] == 'hitting') {
          awayHittersAtBats = (null != groups[j]['stat']['atBats'])
              ? '${groups[j]['stat']['atBats']}'
              : awayHittersAtBats;
          awayHittersRuns = (null != groups[j]['stat']['runs'])
              ? '${groups[j]['stat']['runs']}'
              : awayHittersRuns;
          awayHittersHits = (null != groups[j]['stat']['hits'])
              ? '${groups[j]['stat']['hits']}'
              : awayHittersHits;
          awayHittersRbi = (null != groups[j]['stat']['rbi'])
              ? '${groups[j]['stat']['rbi']}'
              : awayHittersRbi;

          totalAwayHittersAtBats = (null != groups[j]['stat']['atBats'])
              ? totalAwayHittersAtBats += groups[j]['stat']['atBats']
              : totalAwayHittersAtBats;
          totalAwayHittersRuns = (null != groups[j]['stat']['runs'])
              ? totalAwayHittersRuns += groups[j]['stat']['runs']
              : totalAwayHittersRuns;
          totalAwayHittersHits = (null != groups[j]['stat']['hits'])
              ? totalAwayHittersHits += groups[j]['stat']['hits']
              : totalAwayHittersHits;
          totalAwayHittersRbi = (null != groups[j]['stat']['rbi'])
              ? totalAwayHittersRbi += groups[j]['stat']['rbi']
              : totalAwayHittersRbi;
          break;
        }
      }

      awayBattersTableRows.add(
        _createBatterStatsTableRow(fullName, playerRole, awayHittersAtBats,
            awayHittersRuns, awayHittersHits, awayHittersRbi, i),
      );
    }
    awayBattersTableRows.add(
      _createBatterStatsTableRow(
          'TEAM',
          null,
          '$totalAwayHittersAtBats',
          '$totalAwayHittersRuns',
          '$totalAwayHittersHits',
          '$totalAwayHittersRbi',
          -1),
    );

    Table awayBattersTable = Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      border: TableBorder(
        top: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        bottom: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        horizontalInside: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      children: awayBattersTableRows,
    );

    List<TableRow> awayPitchersTableRows = [];
    awayPitchersTableRows.add(
      _createPitcherStatsTableRow('PITCHERS', 'IP', 'H', 'R', 'K', -1),
    );

    double totalAwayPitchersInningsPitched = 0.0;
    int totalAwayPitchersHits = 0;
    int totalAwayPitchersRuns = 0;
    int totalAwayPitchersStrikeOuts = 0;

    for (int k = 0; k < awayTeamPitchers.length; k++) {
      http.Response individualPlayerResponse =
          await http.get('$_BASE_PEOPLE_URL_ENDPOINT${awayTeamPitchers[k]}/');
      http.Response individualPlayerStatsResponse = await http.get(
          '$_BASE_PEOPLE_GAME_STATS_URL_ENDPOINT${awayTeamPitchers[k]}$_INFIX_PEOPLE_GAME_STATS_URL_ENDPOINT${widget.gameTileModel.gamePk}');
      String playerFirstName = JsonDecoder()
          .convert(individualPlayerResponse.body)['people'][0]['firstName'];
      String playerLastName = JsonDecoder()
          .convert(individualPlayerResponse.body)['people'][0]['lastName'];
      String fullName = '${playerFirstName.substring(0, 1)}. $playerLastName';
      List groups = JsonDecoder()
          .convert(individualPlayerStatsResponse.body)['stats'][0]['splits'];
      String awayPitchersInningsPitched,
          awayPitchersHits,
          awayPitchersRuns,
          awayPitchersStrikeOuts = '---';

      for (int m = 0; m < groups.length; m++) {
        if (groups[m]['group'] == 'pitching') {
          awayPitchersInningsPitched =
              (null != groups[m]['stat']['inningsPitched'])
                  ? '${groups[m]['stat']['inningsPitched']}'
                  : awayPitchersInningsPitched;
          awayPitchersHits = (null != groups[m]['stat']['hits'])
              ? '${groups[m]['stat']['hits']}'
              : awayPitchersHits;
          awayPitchersRuns = (null != groups[m]['stat']['runs'])
              ? '${groups[m]['stat']['runs']}'
              : awayPitchersRuns;
          awayPitchersStrikeOuts = (null != groups[m]['stat']['strikeOuts'])
              ? '${groups[m]['stat']['strikeOuts']}'
              : awayPitchersStrikeOuts;

          totalAwayPitchersInningsPitched =
              (null != groups[m]['stat']['inningsPitched'])
                  ? totalAwayPitchersInningsPitched += double.parse(
                      double.parse(groups[m]['stat']['inningsPitched'])
                          .toStringAsFixed(2))
                  : totalAwayPitchersInningsPitched;
          totalAwayPitchersHits = (null != groups[m]['stat']['hits'])
              ? totalAwayPitchersHits += groups[m]['stat']['hits']
              : totalAwayPitchersHits;
          totalAwayPitchersRuns = (null != groups[m]['stat']['runs'])
              ? totalAwayPitchersRuns += groups[m]['stat']['runs']
              : totalAwayPitchersRuns;
          totalAwayPitchersStrikeOuts = (null !=
                  groups[m]['stat']['strikeOuts'])
              ? totalAwayPitchersStrikeOuts += groups[m]['stat']['strikeOuts']
              : totalAwayPitchersStrikeOuts;
          break;
        }
      }

      awayPitchersTableRows.add(
        _createPitcherStatsTableRow(fullName, awayPitchersInningsPitched,
            awayPitchersHits, awayPitchersRuns, awayPitchersStrikeOuts, k),
      );
    }
    awayPitchersTableRows.add(
      _createPitcherStatsTableRow(
          'TEAM',
          '${double.parse(totalAwayPitchersInningsPitched.toStringAsFixed(2))}',
          '$totalAwayPitchersHits',
          '$totalAwayPitchersRuns',
          '$totalAwayPitchersStrikeOuts',
          -1),
    );

    Table awayPitchersTable = Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      border: TableBorder(
        top: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        bottom: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        horizontalInside: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      children: awayPitchersTableRows,
    );

    // Home

    List<TableRow> homeBattersTableRows = [];
    homeBattersTableRows.add(
      _createBatterStatsTableRow('HITTERS', null, 'AB', 'R', 'H', 'RBI', -1),
    );

    int totalHomeHittersAtBats = 0;
    int totalHomeHittersRuns = 0;
    int totalHomeHittersHits = 0;
    int totalHomeHittersRbi = 0;

    for (int i = 0; i < homeTeamHitters.length; i++) {
      http.Response individualPlayerResponse =
          await http.get('$_BASE_PEOPLE_URL_ENDPOINT${homeTeamHitters[i]}/');
      http.Response individualPlayerStatsResponse = await http.get(
          '$_BASE_PEOPLE_GAME_STATS_URL_ENDPOINT${homeTeamHitters[i]}$_INFIX_PEOPLE_GAME_STATS_URL_ENDPOINT${widget.gameTileModel.gamePk}');
      String playerFirstName = JsonDecoder()
          .convert(individualPlayerResponse.body)['people'][0]['firstName'];
      String playerLastName = JsonDecoder()
          .convert(individualPlayerResponse.body)['people'][0]['lastName'];
      String fullName = '${playerFirstName.substring(0, 1)}. $playerLastName';
      String playerRole =
          JsonDecoder().convert(individualPlayerResponse.body)['people'][0]
              ['primaryPosition']['abbreviation'];
      List groups = JsonDecoder()
          .convert(individualPlayerStatsResponse.body)['stats'][0]['splits'];
      String homeHittersAtBats = '---';
      String homeHittersRuns = '---';
      String homeHittersHits = '---';
      String homeHittersRbi = '---';

      for (int j = 0; j < groups.length; j++) {
        if (groups[j]['group'] == 'hitting') {
          homeHittersAtBats = (null != groups[j]['stat']['atBats'])
              ? '${groups[j]['stat']['atBats']}'
              : homeHittersAtBats;
          homeHittersRuns = (null != groups[j]['stat']['runs'])
              ? '${groups[j]['stat']['runs']}'
              : homeHittersRuns;
          homeHittersHits = (null != groups[j]['stat']['hits'])
              ? '${groups[j]['stat']['hits']}'
              : homeHittersHits;
          homeHittersRbi = (null != groups[j]['stat']['rbi'])
              ? '${groups[j]['stat']['rbi']}'
              : homeHittersRbi;

          totalHomeHittersAtBats = (null != groups[j]['stat']['atBats'])
              ? totalHomeHittersAtBats += groups[j]['stat']['atBats']
              : totalHomeHittersAtBats;
          totalHomeHittersRuns = (null != groups[j]['stat']['runs'])
              ? totalHomeHittersRuns += groups[j]['stat']['runs']
              : totalHomeHittersRuns;
          totalHomeHittersHits = (null != groups[j]['stat']['hits'])
              ? totalHomeHittersHits += groups[j]['stat']['hits']
              : totalHomeHittersHits;
          totalHomeHittersRbi = (null != groups[j]['stat']['rbi'])
              ? totalHomeHittersRbi += groups[j]['stat']['rbi']
              : totalHomeHittersRbi;
          break;
        }
      }

      homeBattersTableRows.add(
        _createBatterStatsTableRow(fullName, playerRole, homeHittersAtBats,
            homeHittersRuns, homeHittersHits, homeHittersRbi, i),
      );
    }
    homeBattersTableRows.add(
      _createBatterStatsTableRow(
          'TEAM',
          null,
          '$totalHomeHittersAtBats',
          '$totalHomeHittersRuns',
          '$totalHomeHittersHits',
          '$totalHomeHittersRbi',
          -1),
    );

    Table homeBattersTable = Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      border: TableBorder(
        top: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        bottom: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        horizontalInside: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      children: homeBattersTableRows,
    );

    List<TableRow> homePitchersTableRows = [];
    homePitchersTableRows.add(
      _createPitcherStatsTableRow('PITCHERS', 'IP', 'H', 'R', 'K', -1),
    );

    double totalHomePitchersInningsPitched = 0;
    int totalHomePitchersHits = 0;
    int totalHomePitchersRuns = 0;
    int totalHomePitchersStrikeOuts = 0;

    for (int k = 0; k < homeTeamPitchers.length; k++) {
      http.Response individualPlayerResponse =
          await http.get('$_BASE_PEOPLE_URL_ENDPOINT${homeTeamPitchers[k]}/');
      http.Response individualPlayerStatsResponse = await http.get(
          '$_BASE_PEOPLE_GAME_STATS_URL_ENDPOINT${homeTeamPitchers[k]}$_INFIX_PEOPLE_GAME_STATS_URL_ENDPOINT${widget.gameTileModel.gamePk}');
      String playerFirstName = JsonDecoder()
          .convert(individualPlayerResponse.body)['people'][0]['firstName'];
      String playerLastName = JsonDecoder()
          .convert(individualPlayerResponse.body)['people'][0]['lastName'];
      String fullName = '${playerFirstName.substring(0, 1)}. $playerLastName';
      List groups = JsonDecoder()
          .convert(individualPlayerStatsResponse.body)['stats'][0]['splits'];
      String homePitchersInningsPitched = '---';
      String homePitchersHits = '---';
      String homePitchersRuns = '---';
      String homePitchersStrikeOuts = '---';

      for (int m = 0; m < groups.length; m++) {
        if (groups[m]['group'] == 'pitching') {
          homePitchersInningsPitched =
              (null != groups[m]['stat']['inningsPitched'])
                  ? '${groups[m]['stat']['inningsPitched']}'
                  : homePitchersInningsPitched;
          homePitchersHits = (null != groups[m]['stat']['hits'])
              ? '${groups[m]['stat']['hits']}'
              : homePitchersHits;
          homePitchersRuns = (null != groups[m]['stat']['runs'])
              ? '${groups[m]['stat']['runs']}'
              : homePitchersRuns;
          homePitchersStrikeOuts = (null != groups[m]['stat']['strikeOuts'])
              ? '${groups[m]['stat']['strikeOuts']}'
              : homePitchersStrikeOuts;

          totalHomePitchersInningsPitched =
              (null != groups[m]['stat']['inningsPitched'])
                  ? totalHomePitchersInningsPitched += double.parse(
                      double.parse(groups[m]['stat']['inningsPitched'])
                          .toStringAsFixed(2))
                  : totalHomePitchersInningsPitched;
          totalHomePitchersHits = (null != groups[m]['stat']['hits'])
              ? totalHomePitchersHits += groups[m]['stat']['hits']
              : totalHomePitchersHits;
          totalHomePitchersRuns = (null != groups[m]['stat']['runs'])
              ? totalHomePitchersRuns += groups[m]['stat']['runs']
              : totalHomePitchersRuns;
          totalHomePitchersStrikeOuts = (null !=
                  groups[m]['stat']['strikeOuts'])
              ? totalHomePitchersStrikeOuts += groups[m]['stat']['strikeOuts']
              : totalHomePitchersStrikeOuts;
          break;
        }
      }

      homePitchersTableRows.add(
        _createPitcherStatsTableRow(fullName, homePitchersInningsPitched,
            homePitchersHits, homePitchersRuns, homePitchersStrikeOuts, k),
      );
    }
    homePitchersTableRows.add(
      _createPitcherStatsTableRow(
          'TEAM',
          '$totalHomePitchersInningsPitched',
          '$totalHomePitchersHits',
          '$totalHomePitchersRuns',
          '$totalHomePitchersStrikeOuts',
          -1),
    );

    Table homePitchersTable = Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      border: TableBorder(
        top: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        bottom: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        horizontalInside: BorderSide(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      children: homePitchersTableRows,
    );

    setState(() {
      _awayStats =
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 32.0, bottom: 16.0),
          child: Text(
            "Hitting",
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: awayBattersTable,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 32.0, bottom: 16.0),
          child: Text(
            "Pitching",
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 32.0),
          child: awayPitchersTable,
        ),
      ]);

      _homeStats =
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 32.0, bottom: 16.0),
          child: Text(
            "Hitting",
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: homeBattersTable,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 32.0, bottom: 16.0),
          child: Text(
            "Pitching",
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 32.0),
          child: homePitchersTable,
        ),
      ]);
    });
  }

  List<bool> _isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              "${widget.gameTileModel.awayAbbrev} @ ${widget.gameTileModel.homeAbbrev}"),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 65.0,
                                height: 65.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.scaleDown,
                                      image: widget
                                          .gameTileModel.awayImageProvider),
                                ),
                              ),
                              Text(
                                widget.gameTileModel.awayAbbrev,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 24.0, left: 8.0),
                          child: Text(
                            "${widget.gameTileModel.finalAwayScore}",
                            style: TextStyle(fontSize: 24.0),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Text(widget.gameTileModel.gameScoreStatus),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 24.0, right: 8.0),
                          child: Text(
                            "${widget.gameTileModel.finalHomeScore}",
                            style: TextStyle(fontSize: 24.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 65.0,
                                height: 65.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.scaleDown,
                                      image: widget
                                          .gameTileModel.homeImageProvider),
                                ),
                              ),
                              Text(
                                widget.gameTileModel.homeAbbrev,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Table(
                        defaultColumnWidth: IntrinsicColumnWidth(),
                        border: TableBorder(
                          top: BorderSide(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          horizontalInside: BorderSide(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          verticalInside: BorderSide(
                            color: Colors.grey,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                        ),
                        children: null != _finalLineScoreList
                            ? _finalLineScoreList
                            : [],
                      ),
                    ),
                  ),
                  ToggleButtons(
                      isSelected: _isSelected,
                      borderColor: Colors.black,
                      borderWidth: 2,
                      selectedBorderColor: Colors.black,
                      splashColor: Colors.black,
                      highlightColor: Colors.black,
                      selectedColor: Colors.white,
                      disabledColor: Colors.black,
                      fillColor: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Container(
                            width: 50.0,
                            child: Center(
                              child: Text(
                                widget.gameTileModel.awayAbbrev,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Container(
                            width: 50.0,
                            child: Center(
                              child: Text(
                                widget.gameTileModel.homeAbbrev,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          if (index % 2 == 0) {
                            statsClicked = StatsClicked.AWAY;
                            _isSelected[0] = true;
                            _isSelected[1] = false;
                          } else {
                            statsClicked = StatsClicked.HOME;
                            _isSelected[0] = false;
                            _isSelected[1] = true;
                          }
                        });
                      }),
                  (null != _awayStats && null != _homeStats) &&
                          statsClicked == StatsClicked.AWAY
                      ? _awayStats
                      : (null != _awayStats && null != _homeStats) &&
                              statsClicked == StatsClicked.HOME
                          ? _homeStats
                          : Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum LineScoreRowType { HEADER, AWAY, HOME }

enum StatsClicked { HOME, AWAY }
