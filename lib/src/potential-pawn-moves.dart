import 'dart:math';

import 'chess-move.dart';
import 'chess-piece.dart';

List<ChessPiece> _blackPromotions = [
  ChessPiece.black_bishop,
  ChessPiece.black_knight,
  ChessPiece.black_queen,
  ChessPiece.black_rook
];

List<ChessPiece> _whitePromotions = [
  ChessPiece.white_bishop,
  ChessPiece.white_knight,
  ChessPiece.white_queen,
  ChessPiece.white_rook
];

Iterable<ChessMove> _createMoves(ChessPiece p, int x, int y, int ex, int ey,
    [ChessPiece capture = ChessPiece.none]) {
  if (ey == 0 || ey == 7) {
    return (p.isWhite ? _whitePromotions : _blackPromotions).map((e) =>
        ChessMove(
            piece: p,
            start: Point<int>(x, y),
            end: Point<int>(ex, ey),
            promotion: e,
            capture: capture));
  } else {
    return [
      ChessMove(
          piece: p,
          start: Point<int>(x, y),
          end: Point<int>(ex, ey),
          capture: capture)
    ];
  }
}

List<ChessMove> getPotentialPawnMoves(
    ChessMove? lastMove, int x, int y, List<List<ChessPiece>> board) {
  List<ChessMove> moves = [];
  ChessPiece p = board[y][x];
  int newY = p.isWhite ? y + 1 : y - 1;
  if (board[newY][x] == ChessPiece.none) {
    moves.addAll(_createMoves(p, x, y, x, newY));
  }
  // move 2 spaces on first move
  if (p.isWhite &&
      y == 1 &&
      board[2][x] == ChessPiece.none &&
      board[3][x] == ChessPiece.none) {
    moves.add(ChessMove(
      piece: p,
      start: Point<int>(x, y),
      end: Point<int>(x, 3),
    ));
  } else if (!p.isWhite &&
      y == 6 &&
      board[5][x] == ChessPiece.none &&
      board[4][x] == ChessPiece.none) {
    moves.add(
        ChessMove(piece: p, start: Point<int>(x, y), end: Point<int>(x, 4)));
  }
  // Captures
  if (x > 0 &&
      board[newY][x - 1] != ChessPiece.none &&
      board[newY][x - 1].isWhite != p.isWhite) {
    // take left
    moves.addAll(_createMoves(p, x, y, x - 1, newY, board[newY][x - 1]));
  }
  if (x < 7 &&
      board[newY][x + 1] != ChessPiece.none &&
      board[newY][x + 1].isWhite != p.isWhite) {
    // take left
    moves.addAll(_createMoves(p, x, y, x + 1, newY, board[newY][x + 1]));
  }
  // En pessant
  if (lastMove != null) {
    if ((lastMove.piece == ChessPiece.white_pawn &&
            !p.isWhite &&
            newY == 2 &&
            lastMove.start.y == 1 &&
            lastMove.end.y == 3 &&
            (x - lastMove.end.x).abs() == 1) ||
        (lastMove.piece == ChessPiece.black_pawn &&
            p.isWhite &&
            newY == 5 &&
            lastMove.start.y == 6 &&
            lastMove.end.y == 4 &&
            (x - lastMove.end.x).abs() == 1)) {
      moves.add(ChessMove(
          piece: p,
          start: Point<int>(x, y),
          end: Point<int>(lastMove.end.x, newY),
          capture: lastMove.piece,
          enPessant: true));
    }
  }
  return moves;
}
