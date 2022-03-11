import 'package:chess_lib/src/known-board-positions.dart';

import 'castling.dart';
import 'chess-game-state.dart';
import 'chess-piece.dart';
import 'player.dart';

const STARTING_POSITION_IDENTIFIER =
    "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq";

String getFenBoard(List<List<ChessPiece>> board) {
  String str = "";
  for (int y = 0; y < 8; y++) {
    int emptySquares = 0;
    for (int x = 0; x < 8; x++) {
      ChessPiece p = board[7 - y][x];
      if (p == ChessPiece.none) {
        emptySquares++;
      } else {
        if (emptySquares > 0) {
          str += emptySquares.toString();
        }
        str += p.unicodeCharacter;
        emptySquares = 0;
      }
    }
    if (emptySquares > 0) {
      str += emptySquares.toString();
    }
    if (y < 7) {
      str += "/";
    }
  }
  return str;
}

String getFenCastling(Set<Castling> availableCastling) {
  if (availableCastling.isEmpty) {
    return "-";
  } else {
    String str = "";
    for (Castling c in [
      Castling.white_short,
      Castling.white_long,
      Castling.black_short,
      Castling.black_long
    ]) {
      if (availableCastling.contains(c)) {
        str += c.fenChar;
      }
    }
    return str;
  }
}

// the board, whose turn it is, and the castling string
String getFenPositionId(ChessGameState state) {
  String str = getFenBoard(state.board);
  str += " ";
  str += state.currentPlayer.fenChar;
  str += " ";
  str += getFenCastling(state.availableCastling);
  return str;
}

String getForsythEdwardsNotation(ChessGameState state) {
  String str = getFenBoard(state.board);
  str += " ";
  str += state.currentPlayer.fenChar;
  str += " ";
  str += getFenCastling(state.availableCastling);
  str += " ";
  // TODO available en pessant
  str += "-";
  str += " ";
  // TODO half move clock?
  str += "0";
  str += " ";
  // TODO This might be wrong? move count / 2?
  str += "${state.moveCount}";
  return str;
}

List<List<ChessPiece>> _getBoardFromFenBoard(String fenBoard) {
  List<List<ChessPiece>> board = createEmptyBoard();

  List<String> rows = fenBoard.split("/");
  for (int y = 0; y < 8; y++) {
    int x = 0;
    for (int i = 0; i < rows[y].length; i++) {
      String c = rows[y].substring(i, i + 1);

      int numIdx = "012345678".indexOf(c);
      if (numIdx != -1) {
        x += numIdx;
      } else {
        for (ChessPiece p in ChessPiece.values) {
          if (p.unicodeCharacter == c) {
            board[7 - y][x] = p;
            x++;
          }
        }
      }
    }
  }
  return board;
}

Set<Castling> _getCastling(String fenPart) {
  Set<Castling> availableCastling = {};
  for (Castling c in Castling.values) {
    if (c != Castling.none && fenPart.contains(c.fenChar)) {
      availableCastling.add(c);
    }
  }
  return availableCastling;
}

ChessGameState fromFen(String fen) {
  List<String> parts = fen.split(" ");
  return ChessGameState(
      board: _getBoardFromFenBoard(parts[0]),
      currentPlayer: parts[1] == 'w' ? Player.white : Player.black,
      availableCastling: _getCastling(parts[2]),
      moveCount: int.parse(parts[5]));
}
