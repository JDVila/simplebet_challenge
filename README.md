# simplebet_challenge

A new Flutter application which utilizes the `statsapi.mlb.com` api to display MLB games and player stats for a particular day.

## Getting Started

This application consists of two screens, multiple api calls, a list view with images and final run scores, and several tables which display player statistics (runs, hits, etc.) for a combination of a particular day, game, team, and player.

The first screen displays a list of games, consisting of team logos for both away and home teams, team abbreviations, final scores, and a final score declaration for the date `09/29/2019` (Baseball season for 2019 ended at the close of October, so no current stats will be displayed at this time). When clicked, the user will be directed to another screen displayed on the screen.

The top of the new screen will display the same data as the item for the game clicked (away and home teams, team abbreviations, final scores, and a final score declaration), as well as full inning scores for both teams, including total runs, hits, and errors for the game - in the form of a table which can be scrolled from left-to-right, to display statistics for games with more innings.

Also displayed will be a toggle button for shifting the state and display between away and home team hitting and pitching statistics, such as `atBats`, `runs`, `hits`, and `rbi` for Hitters, and `inningsPitched`, `hits`, `runs`, and `strikeOuts` for Pitchers, respectively. Triple dashes `---` are used to denote null data for a particular player in relation to pitchers listed with hitters, and a `CircularProgressIndicator` which spins to let the user know that data is being retreived and loaded to be displayed.

## Screenshots

### First Page - ListView

![First Page](https://github.com/JDVila/simplebet_challenge/blob/master/readme_images/listview.png)

### Second Page - Details Page

![Second Page](https://github.com/JDVila/simplebet_challenge/blob/master/readme_images/details_page.png)
