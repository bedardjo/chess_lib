import 'dart:math';

import 'castling.dart';
import 'chess-move.dart';
import 'chess-piece.dart';
import 'piece-movement.dart';
import 'player.dart';
import 'potential-king-moves.dart';
import 'potential-pawn-moves.dart';

bool pointIsOnBoard(Point<int> p) =>
    p.x >= 0 && p.x <= 7 && p.y >= 0 && p.y <= 7;

List<ChessMove> getPotentialMovesForDirectionalPiece(ChessPiece p, Point<int> s,
    List<Point<int>> directions, List<List<ChessPiece>> board) {
  List<ChessMove> moves = [];
  for (Point<int> d in directions) {
    Point<int> e = s + d;
    while (pointIsOnBoard(e)) {
      ChessPiece movePiece = board[e.y][e.x];
      if (movePiece == ChessPiece.none) {
        moves.add(ChessMove(piece: p, start: s, end: e));
        e += d;
      } else {
        if (movePiece.isWhite != p.isWhite) {
          moves.add(ChessMove(piece: p, start: s, end: e, capture: movePiece));
        }
        break;
      }
    }
  }
  return moves;
}

List<ChessMove> getPotentialMovesForKnight(
    ChessPiece p, Point<int> s, List<List<ChessPiece>> board) {
  List<ChessMove> moves = [];
  for (Point<int> d in knightMoves) {
    Point<int> e = s + d;
    if (pointIsOnBoard(e)) {
      ChessPiece movePiece = board[e.y][e.x];
      if (movePiece == ChessPiece.none || movePiece.isWhite != p.isWhite) {
        moves.add(ChessMove(piece: p, start: s, end: e, capture: movePiece));
      }
    }
  }
  return moves;
}

List<ChessMove> getPotentialMovesForPiece(
    ChessMove? lastMove,
    Player player,
    ChessPiece piece,
    int x,
    int y,
    List<List<ChessPiece>> board,
    Set<Castling> availableCastling) {
  switch (piece) {
    case ChessPiece.white_pawn:
    case ChessPiece.black_pawn:
      return getPotentialPawnMoves(lastMove, x, y, board);
    case ChessPiece.white_knight:
    case ChessPiece.black_knight:
      return getPotentialMovesForKnight(piece, Point<int>(x, y), board);
    case ChessPiece.white_bishop:
    case ChessPiece.black_bishop:
      return getPotentialMovesForDirectionalPiece(
          piece, Point<int>(x, y), bishopDirections, board);
    case ChessPiece.white_rook:
    case ChessPiece.black_rook:
      return getPotentialMovesForDirectionalPiece(
          piece, Point<int>(x, y), rookDirections, board);
    case ChessPiece.white_queen:
    case ChessPiece.black_queen:
      return getPotentialMovesForDirectionalPiece(
          piece, Point<int>(x, y), queenDirections, board);
    case ChessPiece.white_king:
    case ChessPiece.black_king:
      return getPotentialKingMoves(
          piece, Point<int>(x, y), board, availableCastling);
    case ChessPiece.none:
      return [];
  }
}

List<ChessMove> getPotentialMoves(ChessMove? lastMove, Player player,
    List<List<ChessPiece>> board, Set<Castling> availableCastling) {
  List<ChessMove> moves = [];
  for (int y = 0; y < 8; y++) {
    for (int x = 0; x < 8; x++) {
      ChessPiece p = board[y][x];
      if (p != ChessPiece.none && p.owner == player) {
        moves.addAll(getPotentialMovesForPiece(
            lastMove, player, board[y][x], x, y, board, availableCastling));
      }
    }
  }
  return moves;
}
