import 'package:flutter/cupertino.dart';

class IdLogoUtil {
  static const Map<int, String> _IdAbbrevMap = {
    109: "ARI",
    144: "ATL",
    110: "BAL",
    111: "BOS",
    112: "CHC",
    113: "CIN",
    114: "CLE",
    115: "COL",
    145: "CWS",
    116: "DET",
    117: "HOU",
    118: "KC",
    108: "LAA",
    119: "LAD",
    146: "MIA",
    158: "MIL",
    142: "MIN",
    121: "NYM",
    147: "NYY",
    133: "OAK",
    143: "PHI",
    134: "PIT",
    135: "SD",
    136: "SEA",
    137: "SF",
    138: "STL",
    139: "TB",
    140: "TEX",
    141: "TOR",
    120: "WSH",
  };
  static String getAbbrev(int id) => _IdAbbrevMap[id];
  static ImageProvider getImageProvider(int id) => AssetImage("lib/images/${_IdAbbrevMap[id]}.gif");
}
