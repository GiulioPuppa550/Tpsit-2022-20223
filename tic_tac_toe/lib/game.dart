import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const String PLAYER_X = "X";
  static const String PLAYER_O = "O";

  late bool mode = true;
  late String modeButtonText;

  bool setColor = false;
  late MaterialColor buttonColor;
  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    /*currentPlayer = PLAYER_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""]; */ //9 empty places
    if (mode) {
      currentPlayer = PLAYER_X;
      gameEnd = false;
      occupied = ["", "", "", "", "", "", "", "", ""]; //9 empty places
      modeButtonText = 'change mode to 1 VS Random mode';
    } else {
      currentPlayer = PLAYER_X;
      gameEnd = false;
      occupied = ["", "", "", "", "", "", "", "", ""]; //9 empty places
      RandomicBotPlayer(gameEnd);
      modeButtonText = 'return to 1 VS 1 mode';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        Text("TicTacToe",
            style: TextStyle(
              color: Color.fromARGB(221, 0, 0, 0),
              fontSize: 50,
              fontWeight: FontWeight.bold,
            )),
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
        Text(
          "it is $currentPlayer turn",
          style: const TextStyle(
            color: Color.fromARGB(221, 103, 103, 103),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
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
          if(mode){
           
            changeTurn();
          }else{
            
            RandomicBotPlayer(gameEnd);
            
          }
          //checkForWinner();
          
          
        });
      },
      child: Container(
        color: occupied[index].isEmpty
            ? Color.fromARGB(255, 122, 122, 122)
            : occupied[index] == PLAYER_X
                ? Colors.red
                : const Color.fromARGB(255, 34, 82, 120),
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
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

  showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Game Over \n $message",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          )),
    );
  }

  showChangingModeMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Color.fromARGB(255, 34, 82, 120),
          content: Text(
            '$message',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          )),
    );
  }

  Color fSetter() {
    if (setColor) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }
}
