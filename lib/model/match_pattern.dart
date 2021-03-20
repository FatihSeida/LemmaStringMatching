import 'package:flutter/cupertino.dart';

class MatchPattern with ChangeNotifier {
  final int startIndex;
  final int length;
  MatchPattern(
    this.startIndex,
    this.length,
  );
}

class MPattern with ChangeNotifier {
  List<MatchPattern> matchPattern = [];

  void addItems(s, m) {
    matchPattern.add(MatchPattern(s, m));
    notifyListeners();
  }

  List<MatchPattern> get items {
    return [...matchPattern];
  }
}
