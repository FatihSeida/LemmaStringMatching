import 'package:flutter_assignment/model/match_pattern.dart';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/service/fetchcsv.dart';

class CSVInput extends StatefulWidget {
  @override
  _CSVInputState createState() => _CSVInputState();
}

class _CSVInputState extends State<CSVInput> {
  List<List<dynamic>> data = [];

  List<MatchPattern> matchPattern = [];

  List<String> answerDosen = [];

  bool isLoading = false;

  List<double> skor = [0, 0, 0, 0, 0];

  List<Map> dataForPost = [];

  _getCSVAndConvert() async {
    setState(() {
      isLoading = true;
    });
    String path = await FilePicker.getFilePath();
    if (path != null) {
      await convertCSV(path).then((value) {});
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future convertCSV(path) async {
    final input = new File(path).openRead();
    List<List<dynamic>> fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    print(fields);

    // compareString(fields);
    await iterateToCurrentData(fields);

    await postAndGet();
  }

  iterateToCurrentData(List<List<dynamic>> fields) {
    dataForPost.clear();
    for (List<dynamic> field in fields) {
      Map dataCSV = {
        "name": field[0],
        "answers": [
          field[1],
          field[2],
          field[3],
          field[4],
          field[5],
          field[6],
          field[7],
          field[8],
          field[9],
          field[10],
        ],
      };

      dataForPost.add(dataCSV);
    }
  }

  postAndGet() {
    FetchDatacsv fetchDatacsv = FetchDatacsv();
    fetchDatacsv.storeData(dataForPost).then((value) async {
      if (value.length > 0) {
        print(value);
        await compareString(value);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  compareString(List<dynamic> fields) async {
    for (int i = 0; i < fields.length; i++) {
      matchPattern.clear();
      answerDosen.clear();

      var answers = fields[i]['answers'];
      var answerMurid;
      double totalSkor = 0;
      for (int j = 0; j < 5; j++) {
        matchPattern.clear();
        answerDosen.clear();
        answerMurid = answers[j];
        answerDosen = answers[j + 5].split("؛");
        for (var answer in answerDosen) {
          search(answerMurid.toLowerCase(), answer.toLowerCase());
        }
        print(
            "${fields[i]['name']} : di $j ${matchPattern.length} / ${answerDosen.length} match pattern");
        skor[j] = (matchPattern.length / answerDosen.length) * 20;
        print("Skor ${fields[i]['name']} : ${skor[j]}");
        totalSkor += skor[j];
      }
      print("TotalSkor ${fields[i]['name']} : $totalSkor");
      //totalSkor = skor[0] + skor[1] + skor[2] + skor[3] + skor[4];
      List<dynamic> row = [];
      row.add(fields[i]['name']);
      row.add(
          totalSkor == null ? '0' : totalSkor.toStringAsFixed(2).toString());
      setState(() {
        data.add(row);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> search(String text, String pattern) async {
    int m = pattern.length;
    int n = text.length;
    List<int> badchar = badCharacterHeuristic(pattern);

    int s = 0;
    int isMeetFirst = 0;

    while (s <= (n - m)) {
      int j = m - 1;
      while (j >= 0 && pattern[j] == text[s + j]) j--;
      if (j < 0) {
        matchPattern.add(MatchPattern(s, m));
        s += (s + m < n) ? m - badchar[text.codeUnitAt(s + m)] : 1;

        isMeetFirst = 1;
      } else {
        s += maxOfAnB(1, j - badchar[text.codeUnitAt(s + j)]);
        if (isMeetFirst == 1) {
          break;
        }
      }
    }
  }

  int maxOfAnB(int a, int b) => (a > b) ? a : b;

  List<int> badCharacterHeuristic(String str) {
    int noOfCharacter = 20000;
    List<int> badChar =
        List<int>.filled(noOfCharacter.bitLength, noOfCharacter);
    int i;

    for (i = 0; i < noOfCharacter; i++) {
      badChar[i] = -1;
    }

    for (i = 0; i < str.length; i++) {
      badChar[str.codeUnitAt(i)] = i;
    }

    return badChar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Input'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(),
            isLoading
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: Center(child: CircularProgressIndicator()))
                : data.isEmpty
                    ? Spacer()
                    : Column(
                        children: <Widget>[
                          Table(
                              columnWidths: {
                                0: FixedColumnWidth(150.0),
                                1: FixedColumnWidth(150.0),
                              },
                              border: TableBorder.all(width: 1.0),
                              children: [
                                TableRow(children: <Widget>[
                                  Container(
                                    color: Colors.blue,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Nama',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.blue,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Skor',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ),
                                  )
                                ])
                              ]),
                          Container(
                            height: 400,
                            child: SingleChildScrollView(
                              child: Table(
                                columnWidths: {
                                  0: FixedColumnWidth(150.0),
                                  1: FixedColumnWidth(150.0),
                                },
                                border: TableBorder.all(width: 1.0),
                                children: data.map((item) {
                                  return TableRow(
                                      children: item.map((row) {
                                    return Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          row.toString(),
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      ),
                                    );
                                  }).toList());
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
            Container(
              width: 100,
              height: 50,
              child: data.isEmpty
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: Colors.blue,
                      ),
                      child: Text(
                        'Import',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      onPressed: () {
                        _getCSVAndConvert();
                      },
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: Colors.blue,
                      ),
                      child: Text(
                        'Clear',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      onPressed: () {
                        setState(() {
                          data.clear();
                        });
                      },
                    ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
