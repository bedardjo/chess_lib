import 'dart:math';

import 'chess-move.dart';
import 'chess-piece.dart';

enum CastlingType { long, short }
enum Castling { white_short, white_long, black_short, black_long, none }

extension CastlingUtil on Castling {
  CastlingType get type {
    switch (this) {
      case Castling.white_long:
      case Castling.black_long:
        return CastlingType.long;
      case Castling.white_short:
      case Castling.black_short:
        return CastlingType.short;
      default:
        throw Exception("INVALID!");
    }
  }

  bool isPossible(List<List<ChessPiece>> board) {
    switch (this) {
      case Castling.white_long:
        return board[0][0] == ChessPiece.white_rook &&
            board[0][1] == ChessPiece.none &&
            board[0][2] == ChessPiece.none &&
            board[0][3] == ChessPiece.none &&
            board[0][4] == ChessPiece.white_king;
      case Castling.white_short:
        return board[0][7] == ChessPiece.white_rook &&
            board[0][6] == ChessPiece.none &&
            board[0][5] == ChessPiece.none &&
            board[0][4] == ChessPiece.white_king;
      case Castling.black_long:
        return board[7][0] == ChessPiece.black_rook &&
            board[7][1] == ChessPiece.none &&
            board[7][2] == ChessPiece.none &&
            board[7][3] == ChessPiece.none &&
            board[7][4] == ChessPiece.black_king;
      case Castling.black_short:
        return board[7][7] == ChessPiece.black_rook &&
            board[7][6] == ChessPiece.none &&
            board[7][5] == ChessPiece.none &&
            board[7][4] == ChessPiece.black_king;
      case Castling.none:
        throw Exception("invalid");
    }
  }

  bool isEventuallyPossible(List<List<ChessPiece>> board) {
    switch (this) {
      case Castling.white_long:
        return board[0][0] == ChessPiece.white_rook &&
            board[0][4] == ChessPiece.white_king;
      case Castling.white_short:
        return board[0][7] == ChessPiece.white_rook &&
            board[0][4] == ChessPiece.white_king;
      case Castling.black_long:
        return board[7][0] == ChessPiece.black_rook &&
            board[7][4] == ChessPiece.black_king;
      case Castling.black_short:
        return board[7][7] == ChessPiece.black_rook &&
            board[7][4] == ChessPiece.black_king;
      case Castling.none:
        throw Exception("invalid");
    }
  }

  void doMove(List<List<ChessPiece>> board) {
    if (!this.isPossible(board)) {
      throw Exception("invalid");
    }
    switch (this) {
      case Castling.white_long:
        board[0][0] = ChessPiece.none;
        board[0][1] = ChessPiece.none;
        board[0][2] = ChessPiece.white_king;
        board[0][3] = ChessPiece.white_rook;
        board[0][4] = ChessPiece.none;
        break;
      case Castling.white_short:
        board[0][4] = ChessPiece.none;
        board[0][5] = ChessPiece.white_rook;
        board[0][6] = ChessPiece.white_king;
        board[0][7] = ChessPiece.none;
        break;
      case Castling.black_long:
        board[7][0] = ChessPiece.none;
        board[7][1] = ChessPiece.none;
        board[7][2] = ChessPiece.black_king;
        board[7][3] = ChessPiece.black_rook;
        board[7][4] = ChessPiece.none;
        break;
      case Castling.black_short:
        board[7][4] = ChessPiece.none;
        board[7][5] = ChessPiece.black_rook;
        board[7][6] = ChessPiece.black_king;
        board[7][7] = ChessPiece.none;
        break;
      case Castling.none:
        throw Exception("invalid");
    }
  }

  void undoMove(List<List<ChessPiece>> board) {
    switch (this) {
      case Castling.white_long:
        board[0][0] = ChessPiece.white_rook;
        board[0][1] = ChessPiece.none;
        board[0][2] = ChessPiece.none;
        board[0][3] = ChessPiece.none;
        board[0][4] = ChessPiece.white_king;
        break;
      case Castling.white_short:
        board[0][4] = ChessPiece.white_king;
        board[0][5] = ChessPiece.none;
        board[0][6] = ChessPiece.none;
        board[0][7] = ChessPiece.white_rook;
        break;
      case Castling.black_long:
        board[7][0] = ChessPiece.black_rook;
        board[7][1] = ChessPiece.none;
        board[7][2] = ChessPiece.none;
        board[7][3] = ChessPiece.none;
        board[7][4] = ChessPiece.black_king;
        break;
      case Castling.black_short:
        board[7][4] = ChessPiece.black_king;
        board[7][5] = ChessPiece.none;
        board[7][6] = ChessPiece.none;
        board[7][7] = ChessPiece.black_rook;
        break;
      case Castling.none:
        throw Exception("invalid");
    }
  }

  ChessMove get intermediateKingMove {
    switch (this) {
      case Castling.white_long:
        return ChessMove(
            piece: ChessPiece.white_king, start: Point(4, 0), end: Point(3, 0));
      case Castling.white_short:
        return ChessMove(
            piece: ChessPiece.white_king, start: Point(4, 0), end: Point(5, 0));
      case Castling.black_long:
        return ChessMove(
            piece: ChessPiece.black_king, start: Point(4, 7), end: Point(3, 7));
      case Castling.black_short:
        return ChessMove(
            piece: ChessPiece.black_king, start: Point(4, 7), end: Point(5, 7));
      case Castling.none:
        throw Exception("invalid");
    }
  }

  String get fenChar {
    switch (this) {
      case Castling.white_long:
        return "Q";
      case Castling.white_short:
        return "K";
      case Castling.black_long:
        return "q";
      case Castling.black_short:
        return "k";
      case Castling.none:
        throw Exception("invalid");
    }
  }
}
