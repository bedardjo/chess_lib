import 'package:chess_lib/chess_lib.dart';

void main() {
  ChessGameState newGame = ChessGameState.initialBoardPosition();
  // play a few random moves
  List<ChessMove> movesPlayed = [];
  for (int i = 0; i < 5; i++) {
    List<ChessMove> moves = newGame.moves;
    moves.shuffle();
    movesPlayed.add(moves.first);
    newGame = newGame.playMove(moves.first);
  }
  // print the moves
  for (ChessMove m in movesPlayed) {
    print(m.moveString);
  }
  // print the current fen
  print(newGame.forsythEdwardsNotation);
}
