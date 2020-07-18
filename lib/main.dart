import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/const.dart';
import 'data/cell.dart';
import 'dart:math';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';

int row=9;
int column=9;
int activeBomb=12;
String faceImage=smile;
String actionImage=brust;
int action=1;
int count=0;
Timer timer;
Stopwatch stopwatch=Stopwatch();
int minutes;
int seconds;

void main() => runApp(BoardGame());


class BoardGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MineSweeper",
      home:SafeArea(child: Scaffold(body: Board())),
    );
  }
}

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var bomber;
  var board;

  void initialize() {
    activeBomb=12;
    bomber=List.generate(
        row, (i) => List.generate(column, (j) => 0), growable: false);
    board=List.generate(row, (i) => List.generate(column, (j) => tileState.covered));
    stopwatch.reset();
    timer?.cancel();
    timer=Timer.periodic(dur, (timer) {setState(() {
      minutes=(stopwatch.elapsedMilliseconds ~/1000)~/60;
      seconds=(stopwatch.elapsedMilliseconds ~/1000)%60;
      print(minutes.toString()+':'+seconds.toString());
    });});
    stopwatch.start();

    for (int i = 0; i < 12; i++) {
      int r = Random().nextInt(row);
      int c=Random().nextInt(column);
      if (bomber[r][c] != -1) {
        bomber[r][c] = -1;
        for (int m = -1; m < 2; m++) {
          for (int n = -1; n < 2; n++) {
            if(r+m<row &&c+n<column && r+m>-1 &&c+n>-1) {
              if (bomber[r + m][c + n] != -1) {
                bomber[r + m][c + n] += 1;
              }
            }
          }
        }
      }
      else
        i--;
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Widget buildBoard()
  {
    List<Row> boardRow=<Row>[];
    for(int i=0;i<row;i++)
    {
      List<Widget> rowChildren = <Widget>[];
      for(int j=0;j<column;j++)
      {
        rowChildren.add(
          GestureDetector(
            child:Cell(isBomb: bomber[j][i]==-1, bombAround: bomber[j][i] , state: board[j][i]),
            onTap:(){ click(j,i);},
            onLongPressStart:(details){ longPress(j,i);},
            onLongPressEnd: (details){longPressEnd(j,i);},
          )
        );
      }
      boardRow.add(Row(children: rowChildren,));

    }
    return Column(
      children: <Widget>[
        Column(children: boardRow,),
      ],
    );
  }

  Widget controlBar()
  {
    return Container(
      color:Color(0xFFC0C0C0),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 35.0,
            width: 75.0,
            margin: EdgeInsets.all(5.0),
            color: Color(0xFF400202),
            child: Text(
                activeBomb.toString().padLeft(3, '0'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF40303),
                fontSize: 30.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(
              width:20.0
          ),
          Container(
            height: 50.0,
            width: 50.0,
            child: GestureDetector(
              child: Image.asset(faceImage),
              onTap: (){
                setState(() {
                  if(faceImage==smile){
                    Alert(
                        context: context,
                        style: AlertStyle(
                          animationType: AnimationType.fromLeft,
                          animationDuration: Duration(milliseconds: 400),
                          backgroundColor: Colors.white,
                        ),
                        title: 'New Game',
                        type: AlertType.none,
                        buttons:[
                          DialogButton(
                            child:Text("OK",
                              style: TextStyle(color:Colors.black,fontSize: 15.0),
                            ),
                            color:cellColor,
                            onPressed:(){
                              Navigator.pop(context);
                              setState(() {
                                initialize();
                              });
                            },
                          ),
                         DialogButton(
                            child:Text("Cancel",
                              style: TextStyle(color:Colors.black,fontSize: 15.0),
                            ),
                            color:cellColor,
                            onPressed:(){
                            Navigator.pop(context);
                            },
                         ),
                        ]
                    ).show();
                  }
                  else {
                    setState(() {
                      faceImage=smile;
                      initialize();
                    });
                  }
                });
              },
            ),
          ),
          Container(
            height: 50.0,
            width: 50.0,
            child: GestureDetector(
              child: Image.asset(actionImage),
              onTap: (){
                setState(() {
                  actionImage=actionImage==brust?flag:brust;
                });
                action=actionImage==brust?1:2;
              },
            ),
          ),
          SizedBox(
              width:20.0
          ),
          Container(
            height: 35.0,
            width: 100.0,
            margin: EdgeInsets.all(5.0),
            color: Color(0xFF400202),
            child: Text(
              minutes.toString().padLeft(2, '0')+':'+seconds.toString().padLeft(2,'0'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFFF40303),
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: controlBar(),
          ),
          Container(
              child: buildBoard()
          )
        ],
        ),
      );
  }


  void click(int x,int y)
  {
    setState(() {
      if(board[x][y] == tileState.covered && action==1) {
        if (bomber[x][y] > 0)
          board[x][y] = tileState.open;
        else if (bomber[x][y] == 0)
          open(x, y);
        else if (bomber[x][y] == -1) {
          board[x][y] = tileState.blown;
          revealall(x, y);
        }
      }
      else if(action==2)
      {
        if(board[x][y]==tileState.flagged) {
          board[x][y] = tileState.covered;
          activeBomb++;
        }
        else if(board[x][y]==tileState.covered && activeBomb>0) {
          board[x][y] = tileState.flagged;
          activeBomb--;
        }
      }
    });
  }


  void open(x,y)
  {
    if(!inBoard(x,y))return;
    if(board[x][y]==tileState.open )return;
    if(board[x][y]==tileState.flagged )return;
    board[x][y]=tileState.open;
    if(bomber[x][y]>0)return;

    open(x-1, y);
    open(x+1, y);
    open(x,y+1);
    open(x, y-1);
    open(x-1, y-1);
    open(x+1, y+1);
    open(x+1,y-1);
    open(x-1, y+1);
  }

  bool inBoard(int x,int y)=> x>=0 && x<column &&y>=0 && y<row;

  void revealall(int x,int y) {
    faceImage=upset;
    stopwatch.stop();
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        if (!(i == x && j == y)) {
          if(board[i][j]==tileState.flagged){
            if(bomber[i][j]!=-1) {
              board[i][j] = tileState.wrFlg;
            }
          }
          else {
            board[i][j] = tileState.revealed;
          }
        }
      }
    }
  }

  void longPress(int x,int y)
  {
    setState(() {
      if(board[x][y]==tileState.covered){
        board[x][y]=tileState.flagged;
      }
      else if(board[x][y]==tileState.flagged){
        board[x][y]=tileState.covered;
      }
      else if(bomber[x][y]>0 && board[x][y]==tileState.open){
        count=0;
        for(int i=-1;i<2;i++){
          for(int j=-1;j<2;j++){
            if(inBoard(x+i, y+j)) {
              if (board[x + i][y + j] == tileState.covered) {
                board[x + i][y + j] = tileState.sneak;
              }
              else if (board[x + i][y + j] == tileState.flagged)
                count++;
            }
          }
        }
      }
    });
  }

  void longPressEnd(int x,int y)
  {
    if(count>=bomber[x][y]){
      for(int i=-1;i<2;i++) {
        for (int j = -1; j < 2; j++) {
          if (board[x + i][y + j] == tileState.sneak) {
            board[x + i][y + j] = tileState.open;
            if (bomber[x + i][y + j] == -1) {
              board[x + i][y + j] = tileState.blown;
              revealall(x + i, y + j);
              return;
            }
          }
        }
      }
    }
    else{
      for(int i=-1;i<2;i++) {
        for (int j = -1; j < 2; j++) {
          if (board[x + i][y + j] == tileState.sneak) {
            board[x + i][y + j] = tileState.covered;
          }
        }
      }
    }
    count=0;
  }
}
