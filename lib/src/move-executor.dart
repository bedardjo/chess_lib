import 'chess-move.dart';
import 'chess-piece.dart';
import 'castling.dart';

void doMove(ChessMove move, List<List<ChessPiece>> board) {
  if (board[move.start.y][move.start.x] != move.piece) {
    throw Exception("move is invalid");
  }
  if (move.castling != Castling.none) {
    move.castling.doMove(board);
  } else {
    board[move.start.y][move.start.x] = ChessPiece.none;
    board[move.end.y][move.end.x] =
        move.promotion == ChessPiece.none ? move.piece : move.promotion;
    if (move.enPessant) {
      if (board[move.start.y][move.end.x] == ChessPiece.none) {
        throw Exception("not an en pessant");
      }
      board[move.start.y][move.end.x] = ChessPiece.none;
    }
  }
}

void undoMove(ChessMove move, List<List<ChessPiece>> board) {
  if (move.castling != Castling.none) {
    move.castling.undoMove(board);
  } else {
    if (move.capture != ChessPiece.none) {
      if (move.enPessant) {
        board[move.end.y][move.end.x] = ChessPiece.none;
        board[move.start.y][move.end.x] = move.capture;
      } else {
        board[move.end.y][move.end.x] = move.capture;
      }
    } else {
      board[move.end.y][move.end.x] = ChessPiece.none;
    }
    board[move.start.y][move.start.x] = move.piece;
  }
}
