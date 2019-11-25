import 'package:flutter/material.dart';
import 'package:simplebet_challenge/pages/game_box_scores_page.dart';

class GameTile extends StatelessWidget {
  final GameTileModel gameTileModel;

  GameTile({@required this.gameTileModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameBoxScoresPage(
              gameTileModel: gameTileModel,
            ),
          ),
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 65.0,
                      height: 65.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: gameTileModel.awayImageProvider),
                      ),
                    ),
                    Text(
                      gameTileModel.awayAbbrev,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, left: 8.0),
                child: Text(
                  "${gameTileModel.finalAwayScore}",
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(gameTileModel.gameScoreStatus),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, right: 8.0),
                child: Text(
                  "${gameTileModel.finalHomeScore}",
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 65.0,
                      height: 65.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: gameTileModel.homeImageProvider),
                      ),
                    ),
                    Text(
                      gameTileModel.homeAbbrev,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameTileModel {
  final int gamePk;
  final ImageProvider awayImageProvider;
  final int finalAwayScore;
  final String awayAbbrev;
  final String gameScoreStatus;
  final ImageProvider homeImageProvider;
  final int finalHomeScore;
  final String homeAbbrev;

  GameTileModel(
      {@required this.gamePk,
      @required this.awayImageProvider,
      @required this.finalAwayScore,
      @required this.awayAbbrev,
      @required this.gameScoreStatus,
      @required this.homeImageProvider,
      @required this.finalHomeScore,
      @required this.homeAbbrev});
}
