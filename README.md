# Connect 4

###Instructions

* Using left and right arrow for moving the token.
* Use up / down arrow or spacebar to drop token

Game is turn based.  Winning condition is checked after every move.
Once there is a winner, the token stays either red or blue.
For fun, the winning player can fill up the board if they wish.

#### Internal Mechanics
Having two game players is handled internally by who is red and not red. *red_turn* in db.

Only table being used is *Games*
Winning condition is checked everytime a valid move is played.
A winner can continue adding tokens.


### Javascript
Most of the Javascript logic is located in a coffeescript file called
app/javascripts/play.coffee

### Backend


Get state of a game

```
GET /games/11.json
```

Add a token

```
POST /api/v1/games/add_token',  {id:[GAME ID], column: [COLUMN]}
```


#### TODO
* Allow clicking on column header to select and drop token
* Adjust show.json to use API route
* Remove global refrences to window.game in class Game in coffeescript
* Add login system so that games have players.
* Add Testing
* Add Security