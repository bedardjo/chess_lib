import 'chess-piece.dart';
import 'known-board-positions.dart';

List<List<ChessPiece>> copyBoard(List<List<ChessPiece>> board) {
  List<List<ChessPiece>> newBoard = createEmptyBoard();
  for (int y = 0; y < 8; y++) {
    for (int x = 0; x < 8; x++) {
      newBoard[y][x] = board[y][x];
    }
  }
  return newBoard;
}
