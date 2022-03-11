import 'chess-move.dart';
import 'chess-piece.dart';

String _getDisambiguation(ChessMove move, List<ChessMove> validMoves) {
  bool disambiguationRequired = false;
  bool fileDisambiguationRequired = false;
  bool rankDisambiguationRequired = false;
  for (ChessMove m in validMoves) {
    if (m == move) {
      continue;
    }
    if (m.piece == move.piece && m.end == move.end) {
      disambiguationRequired = true;
      if (m.start.x == move.start.x) {
        fileDisambiguationRequired = true;
      }
      if (m.start.y == move.start.y) {
        rankDisambiguationRequired = true;
      }
    }
  }
  if (disambiguationRequired) {
    if (fileDisambiguationRequired && rankDisambiguationRequired) {
      return "abcdefgh"[move.start.x] + "12345678"[move.start.y];
    } else if (fileDisambiguationRequired) {
      return "12345678"[move.start.y];
    } else {
      return "abcdefgh"[move.start.x];
    }
  } else {
    return "";
  }
}

String getMoveString(ChessMove move, List<ChessMove> validMoves) {
  String destSqr = "abcdefgh"[move.end.x] + "12345678"[move.end.y];
  String pieceDscr = move.piece.pieceType != PieceType.pawn
      ? move.piece.pieceType.unicodeCharacter
      : "";
  if (move.capture != ChessPiece.none) {
    destSqr = "×" + destSqr;
    if (move.piece.pieceType == PieceType.pawn) {
      pieceDscr = "abcdefgh"[move.start.x];
    }
  }
  String disambiguationPart = move.piece.pieceType != PieceType.pawn
      ? _getDisambiguation(move, validMoves)
      : "";
  return pieceDscr + disambiguationPart + destSqr;
}
