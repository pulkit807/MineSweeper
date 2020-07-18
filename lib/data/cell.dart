import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/utils/const.dart';

class Cell extends StatefulWidget {
  final bool isBomb;
  final int bombAround;
  Cell({@required this.isBomb,@required this.bombAround,@required this.state});

  tileState state;
  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {

  Widget cellChild()
  {
    if(widget.state==tileState.covered)
    {
      return Container(
        height: 39.8,
        width: 39.8,
        child: Image.asset('images/facingDown.png'),
      );
    }
    else if(widget.state==tileState.blown){
      return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black),
            color: Color.fromARGB(255, 254, 0, 0),
          ),
          height: 39.8,
          width: 39.8,

        child: Image.asset('images/bomb.png'),
      );
    }
    else if(widget.state==tileState.flagged){
      return Container(
          height: 39.8,
          width: 39.8,
          child: Image.asset('images/flagged.PNG'),
      );
    }
    else if(widget.state==tileState.wrFlg){
      return Container(
        height: 39.8,
        width: 39.8,
        child: Image.asset('images/wrFlg.png'),
      );
    }
    else if(widget.state==tileState.sneak){
      return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.black),
          color: cellColor,
        ),
        height: 39.8,
        width: 39.8,
      );
    }
    else {
      if (widget.isBomb)
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black),
            color: cellColor,
          ),
          height: 39.8,
          width: 39.8,
          child: Image.asset('images/bomb.png'),
        );
      else if (widget.bombAround != 0)
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black),
            color: cellColor,
          ),
          height: 39.8,
          width: 39.8,
          child: Center(
            child: Text(
              (widget.bombAround).toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                  color: numberColor[widget.bombAround-1],

              ),
            ),
          ),
        );
      else
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black),
            color: cellColor,
          ),
          height: 39.8,
          width: 39.8,
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    return cellChild();
  }

}
