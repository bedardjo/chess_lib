import 'castling.dart';
import 'chess-move.dart';
import 'chess-piece.dart';
import 'copy-board.dart';
import 'move-executor.dart';
import 'move-string-generator.dart';
import 'player.dart';
import 'potential-moves.dart';
import 'threat-detection.dart';

List<ChessMove> getValidMoves(ChessMove? lastMove, Player player,
    List<List<ChessPiece>> board, Set<Castling> availableCastling) {
  List<ChessMove> moves =
      getPotentialMoves(lastMove, player, board, availableCastling);
  List<List<ChessPiece>> boardCopy = copyBoard(board);
  List<ChessMove> validMoves = [];
  for (ChessMove m in moves) {
    if (m.castling != Castling.none) {
      ChessMove intermediateMove = m.castling.intermediateKingMove;
      doMove(intermediateMove, boardCopy);
      bool check = isCheck(player, boardCopy);
      undoMove(intermediateMove, boardCopy);
      if (check) {
        continue;
      }
    }
    doMove(m, boardCopy);
    if (!isCheck(player, boardCopy)) {
      validMoves.add(m);
    }
    undoMove(m, boardCopy);
  }
  return validMoves
      .map((e) => ChessMove(
          piece: e.piece,
          start: e.start,
          end: e.end,
          capture: e.capture,
          promotion: e.promotion,
          castling: e.castling,
          enPessant: e.enPessant,
          moveString: getMoveString(e, validMoves)))
      .toList();
}
