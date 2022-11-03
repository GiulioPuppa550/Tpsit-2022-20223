# TicTacToe, #

 the Project.
<br>
<br>

## Getting Started ##
This project is trying to display a virtual version of the popular game "TicTacToe" (in italian "Tris") .

<br>

## The focus ##
I've paid particular attention to the choice of colors and to the changing theme button. I've worked with a redundant code mold like 


```
    Color methodName() {
    if (boolean) {
      return darkColor;
    } else {
      return regularColor;
    }
  
```
to make a complete theme-change. <br>
You can see this type of method under the comment section `//theme methods `. 

<br>

## The structure
the structure of the minigame is based on a `Container`, that contains a `GridView`,  that is none other than the classic ticTacToe grid. 

```
Widget _gameContainer() {
    return Container(
      color: setContainerColor(),
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, int index) {
            return _box(index);
          }),
    );
  }

```

you should see a classic table (I haven't used a `Table` Widget in this project but you can also use that instead of a `GridView` ) like this:

```
                      ________________
                      |    |    |    |
                      |____|____|____|
                      |    |    |    |
                      |____|____|____|
                      |    |    |    |
                      |____|____|____|
```

Obviously, I've added the `Text()` widget and the `ElevatedButton()` with their styles to give a style to the app.

## The Game
There is two modalities: 1v1 mode and 1vRandomic Generating mode. <br> For the 1v1 mode the alghoritm is simple: touching a cell of the box in the gridView, if it is not occupied, that cell will be occupied with the symbol of the player.

```
onTap: () {
        //on click of box
        if (gameEnd || occupied[index].isNotEmpty) {
          //Return if game already ended or box already clicked
          return;
        }
        setState(() {
          occupied[index] = currentPlayer;
          checkForWinner();
          checkForDraw();
          if (mode) {
            changeTurn();
          }
```
For the RandomMode, i've  used this method:
```
  void RandomicBotPlayer(bool gameEnd) {
    if (gameEnd) {
      MaterialStateProperty.all(Colors.green);
      return;
    }
    bool moveDone = false;
    while (!moveDone) {
      int position = Random().nextInt(occupied.length);
      if (occupied[position] == '') {
        occupied[position] = PLAYER_O;
        moveDone = true;
        print(occupied);
      }
    }
    checkForDraw();
    checkForWinner();
  }
```
this allow to the cpu to find a free cell and occupy it.



    -Giulio Puppa