import 'dart:core';

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const CellAutomataTwoDimension());
}

class CellAutomataTwoDimension extends StatefulWidget {
  const CellAutomataTwoDimension({super.key});

  @override
  State<CellAutomataTwoDimension> createState() =>
      _CellAutomataTwoDimensionState();
}

class _CellAutomataTwoDimensionState extends State<CellAutomataTwoDimension> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: myApp());
  }
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  Stopwatch watch = Stopwatch();
  Timer? timer;
  bool startStop = true;
  @override
  void initState() {
    super.initState();
  }

  int row = 15;
  int col = 15;
  List selectedIndex = [];
  var neighbourList;
  // List<List<int>> value = [
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  // ];
  List<List<int>> value = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
  ];
  Color colColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Cellular Automaton Two Dimension'),
        ),
        body: Container(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 34.0),
                Container(
                    height: 440.0,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(border: Border.all(width: 1.0)),
                    child: _buildCells()),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () {
                          getGeneration();
                        },
                        child: Container(
                          height: 60.0,
                          width: 140.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.blueAccent),
                          child: const Center(
                              child: Text(
                            'START/GO',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0),
                          )),
                        )),
                    InkWell(
                        onTap: () {
                          clear();
                        },
                        child: Container(
                          height: 60.0,
                          width: 140.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.blueAccent),
                          child: const Center(
                              child: Text(
                            'CLEAR',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0),
                          )),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  startOrStop(var newMatrix) {
    if (startStop) {
      setState(() {
        startStop = false;
        watch.start();
        timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (watch.isRunning) {
            setState(() {
              print("startstop Inside=$startStop");
              value = newMatrix;
            });
          }
        });
      });
    } else {
      setState(() {
        startStop = true;
        watch.stop();
      });
    }
  }

  Widget _buildCells() {
    int gridStateLength = value.length;
    return Column(children: <Widget>[
      AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridStateLength,
            ),
            itemBuilder: _buildGridItems,
            itemCount: gridStateLength * gridStateLength,
          ),
        ),
      ),
    ]);
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = value.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    int temp = value[x][y];
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedIndex.contains(index)) {
            selectedIndex.remove(index);
            x = (index / gridStateLength).floor();
            y = (index % gridStateLength);
            value[x][y] = 0;
          } else {
            selectedIndex.add(index);
            x = (index / gridStateLength).floor();
            y = (index % gridStateLength);
            value[x][y] = 1;
          }
        });
      },
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              color: value[x][y] == 1 ? Colors.blueAccent : Colors.white,
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: Text(temp.toString()),
          ),
        ),
      ),
    );
  }

  //GENERATE NEIGHBOR
  neighbourListCondition(int i, int j) {
    var row = 8;
    var col = 8;
    var neighborleft,
        neighborright,
        neighbortop,
        neighbortopneighborleft,
        neighbortopright,
        neighborbottom,
        neighborbottomneighborleft,
        neighborbottomright;
    if (i == 0 && j == 0) {
      setState(() {
        neighbortop = value[row - 1][j];
        neighbortopright = value[row - 1][j + 1];
        neighborright = value[i][j + 1];
        neighborbottomright = value[i + 1][j + 1];
        neighborbottom = value[i + 1][j];
        neighborbottomneighborleft = value[i + 1][col - 1];
        neighborleft = value[i][col - 1];
        neighbortopneighborleft = value[row - 1][col - 1];
      });
    } else if (i == 0 && (j < col - 1)) {
      // Top case with col from index 1 to lastIndex - 1
      setState(() {
        neighbortop = value[row - 1][j];
        neighbortopright = value[row - 1][j + 1];
        neighborright = value[i][j + 1];
        neighborbottomright = value[i + 1][j + 1];
        neighborbottom = value[i + 1][j];
        neighborbottomneighborleft = value[i + 1][j - 1];
        neighborleft = value[i][j - 1];
        neighbortopneighborleft = value[row - 1][j - 1];
      });
    } else if (j == 0 && (i < row - 1)) {
      // left edge case with row from index 1 to lastIndex - 1
      setState(() {
        neighbortop = value[i - 1][j];
        neighbortopright = value[i - 1][j + 1];
        neighborright = value[i][j + 1];
        neighborbottomright = value[i + 1][j + 1];
        neighborbottom = value[i + 1][j];
        neighborbottomneighborleft = value[i + 1][col - 1];
        neighborleft = value[i][col - 1];
        neighbortopneighborleft = value[i - 1][col - 1];
      });
    } else if ((i == row - 1) && j == 0) {
      // Bottom left  case
      setState(() {
        neighbortop = value[i - 1][j];
        neighbortopright = value[i - 1][j + 1];
        neighborright = value[i][j + 1];
        neighborbottomright = value[0][j + 1];
        neighborbottom = value[0][j];
        neighborbottomneighborleft = value[0][col - 1];
        neighborleft = value[i][col - 1];
        neighbortopneighborleft = value[i - 1][col - 1];
      });
    } else if ((i == row - 1) && (j < col - 1)) {
      // Bottom  case with col from index 1 to lastIndex - 1
      setState(() {
        neighbortop = value[i - 1][j];
        neighbortopright = value[i - 1][j + 1];
        neighborright = value[i][j + 1];
        neighborbottomright = value[0][j + 1];
        neighborbottom = value[0][j];
        neighborbottomneighborleft = value[0][j - 1];
        neighborleft = value[i][j - 1];
        neighbortopneighborleft = value[i - 1][j - 1];
      });
    } else if (i == 0 && (j == col - 1)) {
      // Top right  case
      setState(() {
        neighbortop = value[row - 1][j];
        neighbortopright = value[row - 1][0];
        neighborright = value[i][0];
        neighborbottomright = value[i + 1][0];
        neighborbottom = value[i + 1][j];
        neighborbottomneighborleft = value[i + 1][j - 1];
        neighborleft = value[i][j - 1];
        neighbortopneighborleft = value[row - 1][j - 1];
      });
    } else if ((j == col - 1) && (i < row - 1)) {
      // Right edge case with row from index 1 to lastIndex - 1
      setState(() {
        neighbortop = value[i - 1][j];
        neighbortopright = value[i - 1][0];
        neighborright = value[i][0];
        neighborbottomright = value[i + 1][0];
        neighborbottom = value[i + 1][j];
        neighborbottomneighborleft = value[i + 1][j - 1];
        neighborleft = value[i][j - 1];
        neighbortopneighborleft = value[i - 1][j - 1];
      });
    } else if ((i == row - 1) && (j == col - 1)) {
      // Bottom right edge case
      setState(() {
        neighbortop = value[i - 1][j];
        neighbortopright = value[i - 1][0];
        neighborright = value[i][0];
        neighborbottomright = value[0][0];
        neighborbottom = value[0][j];
        neighborbottomneighborleft = value[0][j - 1];
        neighborleft = value[i][j - 1];
        neighbortopneighborleft = value[i - 1][j - 1];
      });
    } else {
      // Common case i and j start from 1 and end to lastIndex - 1
      setState(() {
        neighbortop = value[i - 1][j];
        neighbortopright = value[i - 1][j + 1];
        neighborright = value[i][j + 1];
        neighborbottomright = value[i + 1][j + 1];
        neighborbottom = value[i + 1][j];
        neighborbottomneighborleft = value[i + 1][j - 1];
        neighborleft = value[i][j - 1];
        neighbortopneighborleft = value[i - 1][j - 1];
      });
    }
    // neighbourList.add(neighbortop.toString());
    // neighbourList.add(neighbortopright.toString());
    // neighbourList.add(neighborright.toString());
    // neighbourList.add(neighborbottomright.toString());
    // neighbourList.add(neighborbottom.toString());
    // neighbourList.add(neighborbottomneighborleft.toString());
    // neighbourList.add(neighborleft.toString());
    // neighbourList.add(neighbortopneighborleft.toString());

    setState(() {
      neighbourList = [
        neighbortop.toString(),
        neighbortopright.toString(),
        neighborright.toString(),
        neighborbottomright.toString(),
        neighborbottom.toString(),
        neighborbottomneighborleft.toString(),
        neighborleft.toString(),
        neighbortopneighborleft.toString()
      ];
    });

    // neighbourList = neighbortop.toString() +
    //     neighbortopright.toString() +
    //     neighborright.toString() +
    //     neighborbottomright.toString() +
    //     neighborbottom.toString() +
    //     neighborbottomneighborleft.toString() +
    //     neighborleft.toString() +
    //     neighbortopneighborleft.toString();
  }

  //FUNCTION GET NEXT GENERATION
  getGeneration() {
    List<List<int>> newMatrix = [];

    var newindex;
    for (int i = 0; i < value.length; i++) {
      print('row ' + i.toString());
      List<int> newRow = <int>[];
      for (int j = 0; j < value.length; j++) {
        neighbourListCondition(i, j);
        print(neighbourList);
        // print(value[i][j]);
        newindex = conwaysRule(value[i][j], neighbourList);
        // print(currentindex);
        newRow.add(newindex);
      }
      newMatrix.add(newRow);
    }
    print('loop i done');
    print(value);
    print(newMatrix);

    if (startStop) {
      setState(() {
        startStop = false;
        watch.start();
        timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (watch.isRunning) {
            setState(() {
              print("startstop Inside=$startStop");
              value = newMatrix;
            });
          }
        });
      });
    } else {
      setState(() {
        startStop = true;
        watch.stop();
      });
    }
    // setState(() {
    //   value = newMatrix;
    // });
    // startOrStop(newMatrix);
  }

  int conwaysRule(var cell, List neighbours) {
    //RULES:
    // 1. Any live cell with <2 alive neighbours dies, as if by underpopulation;
    // 2. Any live cell with 2-3 alive neighbours lives on to the next generation;
    // 3. Any live cell with >3 alive neighbours dies, as if by overpopulation;
    // 4. Any dead cell with 3 alive neighbours becomes a live cell, as if by reproduction.

    int livecell = 0;
    for (int i = 0; i < neighbours.length; i++) {
      if (neighbours[i] == '1') {
        setState(() {
          livecell++;
        });
      }
    }
    if (cell == 1) {
      if (livecell < 2) {
        setState(() {
          cell = 0;
        });
      } else if (livecell > 3) {
        setState(() {
          cell = 0;
        });
      } else if (livecell == 2 || livecell == 3) {
        setState(() {
          cell = 1;
        });
      }
    } else if (cell == 0) {
      if (livecell == 3) {
        setState(() {
          cell = 1;
        });
      }
    }
    print(cell);
    print('LIVECELL =' + livecell.toString());
    return cell;
  }

  //CLEAR CELLS
  void clear() {
    for (int i = 0; i < value.length; i++) {
      for (int j = 0; j < value.length; j++) {
        setState(() {
          value[i][j] = 0;
        });
      }
    }
  }
}
