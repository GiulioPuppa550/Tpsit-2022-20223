import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  
  //variables
  static const String PLAYER_X = "X";
  static const String PLAYER_O = "O";
  late String currentPlayer;
  late String modeButtonText;
  late List<String> occupied;
  late bool mode = true;
  late bool gameEnd;
  bool setColor = false;
  bool setDark = false;

  

  // functional methods
  @override
  void initState() {
    initializeGame();
    super.initState();
  }
  void initializeGame() {
    currentPlayer = PLAYER_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""]; //9 empty places

    if (mode) {
      modeButtonText = ' 1 VS Random ';
    } else {
      RandomicBotPlayer(gameEnd);
      modeButtonText = ' 1 VS 1 mode ';
    }
  }
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
  _restartButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: const Text("Restart Game"));
  }
  changeTurn() {
    if (currentPlayer == PLAYER_X) {
      currentPlayer = PLAYER_O;
    } else {
      currentPlayer = PLAYER_X;
    }
  }
  showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          
          duration: Duration(seconds: 1),
          backgroundColor: setContainerColor(),
          content: Text(
            "Game Over \n $message",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          )),
    );
  }
  checkForWinner() {
    //Define winning positions
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var winningPos in winningList) {
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          //all equal means player won
          showGameOverMessage("Player $playerPosition0 Won");
          gameEnd = true;
          return;
        }
      }
    }
  }
  checkForDraw() {
    if (gameEnd) {
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        //at least one is empty not all are filled
        draw = false;
      }
    }

    if (draw) {
      showGameOverMessage("Draw");
      gameEnd = true;
    }
  }


  //methods for theme
  Color setDarkTitle() {
    if (setDark) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
  Color setDarkText() {
    if (setDark) {
      return Color.fromARGB(255, 190, 190, 190);
    } else {
      return Color.fromARGB(255, 45, 66, 124);
    }
  }
  Color setDarkObj() {
    if (setDark) {
      return Color.fromARGB(255, 45, 66, 124);
    } else {
      return  Color.fromARGB(255, 255, 255, 255);
    }
  }
  Color setDarkBackground() {
    if (setDark) {
      return Color.fromARGB(255, 0, 39, 70);
    } else {
      return Colors.white;
    }
  }
  Color setContainerColor() {
    if (setDark) {
      return Color.fromARGB(255, 89, 133, 255);
    } else {
      return Colors.grey;
    }
  }
  Color setCellColor() {
    if (setDark) {
      return Color.fromARGB(255, 45, 66, 124);
    } else {
      return Color.fromARGB(255, 91, 91, 91);
    }
  }
  Color setButtonColor() {
    if (setDark) {
      return Color.fromARGB(255, 190, 226, 255);
    } else {
      return Color.fromARGB(255, 0, 41, 74);
    }
  }
  Color setXColor(){
    if (setDark) {
      return Color.fromARGB(255, 255, 0, 0);
    } else {
      return Color.fromARGB(255, 116, 0, 0);
    }
  }
  Color setOColor(){
    if (setDark) {
      return Color.fromARGB(255, 0, 187, 255);
    } else {
      return Color.fromARGB(255, 6, 0, 88);
    }
  }
  Color fSetter() {
    if (setColor) {
      return Color.fromARGB(255, 166, 208, 0);
    } else {
      return Colors.green;
    }
  }
  //widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: setDarkBackground(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerText(),
            _gameContainer(),
            _restartButton(),
          ],
        ),
      ),
    );
  }
  Widget _headerText() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: setButtonColor()),
                onPressed: () {
                  setState(() {
                    setDark = !setDark;
                  });
                },
                child: Text("change theme", style: TextStyle( color: setDarkObj()),)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: fSetter()),
              onPressed: () {
                mode = !mode;
                setColor = !setColor;
                setState(() {
                  initializeGame();
                });
              },
              child: Text(modeButtonText),
            ),
          ],
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row( mainAxisAlignment: MainAxisAlignment.center,children: [
            Text('T',
              style: TextStyle(
                color: setDarkTitle(),
                fontSize: 40,
                fontWeight: FontWeight.w900,
               )),
                
            Text('I',
              style: TextStyle(
                color: setDarkTitle(),
                fontSize: 40,
                fontWeight: FontWeight.w200,
                )),
            Text('C',
              style: TextStyle(
                color: setDarkTitle(),
                fontSize: 40,
                fontWeight: FontWeight.w500, )),
          ],),
           Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Text('T',
              style: TextStyle(
                color: setDarkTitle(),
                fontSize: 40,
                fontWeight: FontWeight.w300, )),
            Text('A',
              style: TextStyle(
                color: setDarkTitle(),
                fontSize: 40,
                fontWeight: FontWeight.w600, )),
            Text('C',
              style: TextStyle(
                color: setDarkTitle(),
                fontSize: 40,
                fontWeight: FontWeight.w100,)),
          ],),
           Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Text('T',
              style: TextStyle(
                color: setDarkTitle(),
                fontSize: 40,
                fontWeight: FontWeight.w400, )),
            Text('O',
              style: TextStyle(
                color: setDarkTitle(),
                fontSize: 40,
                fontWeight: FontWeight.bold, )),
            Text('E',
              style: TextStyle(
                color: setDarkTitle(),
                fontSize: 40,
                fontWeight: FontWeight.w300, )),
          ],),
          
          Text(
            "play, $currentPlayer player!",
            style: TextStyle(
              color: setDarkText(),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ])
      ],
    );
  }
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
  Widget _box(int index) {
    return InkWell(
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
          } else {
            RandomicBotPlayer(gameEnd);
          }
          //checkForWinner();
        });
      },
      child: Container(
        color: occupied[index].isEmpty
            ? setCellColor()
            : occupied[index] == PLAYER_X
                ? setXColor()
                : setOColor(),
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style:  TextStyle(fontSize: 50, color: setDarkText()),
          ),
        ),
      ),
    );
  }
}