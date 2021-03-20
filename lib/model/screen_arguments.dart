import 'package:flutter_assignment/model/match_pattern.dart';

class ScreenArguments {
  final List<MatchPattern> match;
  final split;
  final String jawaban;
  final String kataKunci;
  ScreenArguments(
    this.match,
    this.split,
    this.jawaban,
    this.kataKunci,
  );
}
