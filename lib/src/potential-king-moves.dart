import 'dart:math';

import 'castling.dart';
import 'chess-move.dart';
import 'chess-piece.dart';
import 'piece-movement.dart';
import 'potential-moves.dart';

List<ChessMove> getPotentialKingMoves(ChessPiece p, Point<int> s,
    List<List<ChessPiece>> board, Set<Castling> availableCastling) {
  List<ChessMove> moves = [];
  for (Point<int> d in queenDirections) {
    Point<int> e = s + d;
    if (pointIsOnBoard(e)) {
      ChessPiece movePiece = board[e.y][e.x];
      if (movePiece == ChessPiece.none || movePiece.isWhite != p.isWhite) {
        moves.add(ChessMove(piece: p, start: s, end: e, capture: movePiece));
      }
    }
  }
  if (p.isWhite) {
    if (availableCastling.contains(Castling.white_long) &&
        Castling.white_long.isPossible(board)) {
      moves.add(ChessMove(
          piece: p,
          start: s,
          end: Point<int>(2, 0),
          castling: Castling.white_long));
    }
    if (availableCastling.contains(Castling.white_short) &&
        Castling.white_short.isPossible(board)) {
      moves.add(ChessMove(
          piece: p,
          start: s,
          end: Point<int>(6, 0),
          castling: Castling.white_short));
    }
  } else {
    if (availableCastling.contains(Castling.black_long) &&
        Castling.black_long.isPossible(board)) {
      moves.add(ChessMove(
          piece: p,
          start: s,
          end: Point<int>(2, 7),
          castling: Castling.black_long));
    }
    if (availableCastling.contains(Castling.black_short) &&
        Castling.black_short.isPossible(board)) {
      moves.add(ChessMove(
          piece: p,
          start: s,
          end: Point<int>(6, 7),
          castling: Castling.black_short));
    }
  }
  return moves;
}
