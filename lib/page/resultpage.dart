import 'package:flutter/material.dart';
import 'package:flutter_assignment/model/match_pattern.dart';
import 'package:flutter_assignment/model/screen_arguments.dart';

class ResultPage extends StatefulWidget {
  static const routeName = '/result';

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: args.match.length > 0
                        ? Column(
                            children: [
                              Text(
                                  "${args.match.length} / ${args.split.length} match pattern"),
                              Divider(),
                              Text.rich(
                                TextSpan(
                                  children: getResult(
                                      args.match, args.jawaban, args.kataKunci),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          )
                        : Text("Tidak ada kata kunci yang cocok"),
                  ),
                ),
        ),
      ),
    );
  }

  List<TextSpan> getResult(
      List<MatchPattern> matchPattern, String jawaban, String kataKunci) {
    List<TextSpan> res = [];
    List<dynamic> kata = jawaban.toLowerCase().split('');
    var split = kataKunci.split('؛');

    // List<String> kata = jawabanController.text.toLowerCase().split('');
    // split = kataKunciController.text.toLowerCase().split('؛');
    if (split.length > 1) {}
    // int patlen = kataKunciController.text.length;

    for (int i = 0; i < kata.length; i++) {
      if (matchPattern.where((e) => e.startIndex == i).isNotEmpty) {
        var found = matchPattern.singleWhere((e) => e.startIndex == i);
        res.add(
          TextSpan(
            text: jawaban.substring(
                found.startIndex, found.startIndex + found.length),
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        );
        i += found.length;
        // kata.removeRange(i, i + patlen);
      }
      if (i < split.length) {
        res.add(
          TextSpan(text: split[i]),
        );
        // i += patlen;
      }
    }

    return res.toList();
  }
}
