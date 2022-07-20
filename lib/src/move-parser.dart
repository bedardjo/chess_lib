import 'dart:math';

import 'castling.dart';
import 'chess-game-state.dart';
import 'chess-move.dart';
import 'chess-piece.dart';

const _LONG_CASTLE = "O-O-O";
const _SHORT_CASTLE = "O-O";

ChessMove _moveForPiece(String moveString, PieceType type, Point<int> dest,
    PieceType? promotion, List<ChessMove> validMoves) {
  List<ChessMove> ms = [];
  for (ChessMove m in validMoves) {
    if (m.piece.pieceType == type && m.end == dest) {
      if (promotion != null) {
        if (promotion == m.promotion.pieceType) {
          ms.add(m);
        }
      } else {
        ms.add(m);
      }
    }
  }
  if (ms.isEmpty) {
    throw Exception(
        "could not find move! $moveString ${type.unicodeCharacter} ${dest.toString()}");
  }
  if (ms.length != 1) {
    throw Exception("invalid! ${ms.length}");
  }
  return ms.first;
}

ChessMove _moveForPieceAtStart(String moveString, PieceType type,
    Point<int> start, Point<int> dest, List<ChessMove> validMoves) {
  for (ChessMove m in validMoves) {
    if (m.piece.pieceType == type && m.start == start && m.end == dest) {
      return m;
    }
  }
  throw Exception("invalid! $moveString");
}

ChessMove _moveForPieceAtFile(String moveString, PieceType type, int file,
    Point<int> dest, List<ChessMove> validMoves) {
  for (ChessMove m in validMoves) {
    if (m.piece.pieceType == type && m.start.x == file && m.end == dest) {
      return m;
    }
  }
  throw Exception("invalid! $moveString");
}

ChessMove _moveForPieceAtRank(
    PieceType type, int rank, Point<int> dest, List<ChessMove> validMoves) {
  for (ChessMove m in validMoves) {
    if (m.piece.pieceType == type && m.start.y == rank && m.end == dest) {
      return m;
    }
  }
  throw Exception("invalid!");
}

ChessMove _parseWithPiece(
    String moveString,
    String disambiguation,
    bool isCap,
    PieceType type,
    Point<int> dest,
    PieceType? promotion,
    List<ChessMove> validMoves) {
  if (disambiguation.length == 0) {
    return _moveForPiece(moveString, type, dest, promotion, validMoves);
  } else {
    if (disambiguation.length > 3) {
      throw new Exception("invalid disambiguation!");
    }

    if (disambiguation.length == 2) {
      Point<int> start = Point("abcdefgh".indexOf(disambiguation[0]),
          "12345678".indexOf(disambiguation[1]));
      return _moveForPieceAtStart(moveString, type, start, dest, validMoves);
    } else if ("abcdefgh".contains(disambiguation)) {
      return _moveForPieceAtFile(moveString, type,
          "abcdefgh".indexOf(disambiguation[0]), dest, validMoves);
    } else if ("12345678".contains(disambiguation)) {
      return _moveForPieceAtRank(
          type, "12345678".indexOf(disambiguation[0]), dest, validMoves);
    }
  }
  throw new Exception("invalid could not disambiguate! $moveString");
}

ChessMove _getPawnMoveAtFile(int file, Point<int> dest, PieceType? promotion,
    List<ChessMove> validMoves) {
  for (ChessMove m in validMoves) {
    if (m.piece.pieceType == PieceType.pawn &&
        m.start.x == file &&
        m.end == dest) {
      if (promotion != null) {
        if (m.promotion.pieceType == promotion) {
          return m;
        }
      } else {
        return m;
      }
    }
  }
  throw Exception("couldn't find move");
}

ChessMove _parseWithDest(String moveString, String prefix, bool isCap,
    Point<int> dest, PieceType? promotion, List<ChessMove> validMoves) {
  if ("RBNQK".contains(prefix[0])) {
    PieceType pieceType = pieceTypeFromChar(prefix[0]);
    return _parseWithPiece(moveString, prefix.substring(1), isCap, pieceType,
        dest, promotion, validMoves);
  } else {
    if (!isCap) {
      throw Exception("invalid move string $moveString");
    }
    int file = "abcdefgh".indexOf(prefix);
    return _getPawnMoveAtFile(file, dest, promotion, validMoves);
  }
}

ChessMove _parseSimplePawnMove(
    Point<int> dest, PieceType? promotion, List<ChessMove> validMoves) {
  for (ChessMove m in validMoves) {
    if (m.piece.pieceType == PieceType.pawn && m.end == dest) {
      if (promotion != null) {
        if (promotion == m.promotion.pieceType) {
          return m;
        }
      } else {
        return m;
      }
    }
  }
  throw Exception("couldn't find move");
}

ChessMove parseMoveString(String moveString, ChessGameState state) {
  if (moveString.endsWith("+") || moveString.endsWith("#")) {
    // check or mate, can safely delete last char
    moveString = moveString.substring(0, moveString.length - 1);
  }
  List<ChessMove> validMoves = state.moves;
  if (moveString == _LONG_CASTLE) {
    return validMoves.firstWhere((element) =>
        element.castling != Castling.none &&
        element.castling.type == CastlingType.long);
  } else if (moveString == _SHORT_CASTLE) {
    return validMoves.firstWhere((element) =>
        element.castling != Castling.none &&
        element.castling.type == CastlingType.short);
  }
  PieceType? promotion;
  if (moveString.contains("=")) {
    // promotion, determine which piece to promote to
    int eqIdx = moveString.indexOf("=");
    String promotionPiece = moveString.substring(moveString.indexOf("=") + 1);
    promotion = pieceTypeFromChar(promotionPiece);
    moveString = moveString.substring(0, eqIdx);
  }
  Point<int> dest = Point("abcdefgh".indexOf(moveString[moveString.length - 2]),
      "12345678".indexOf(moveString[moveString.length - 1]));
  if (moveString.length == 2) {
    return _parseSimplePawnMove(dest, promotion, validMoves);
  } else {
    if (moveString.contains("×")) {
      return _parseWithDest(
          moveString,
          moveString.substring(0, moveString.length - 3),
          true,
          dest,
          promotion,
          validMoves);
    } else if (moveString.contains("x")) {
      return _parseWithDest(
          moveString,
          moveString.substring(0, moveString.length - 3),
          true,
          dest,
          promotion,
          validMoves);
    } else {
      return _parseWithDest(
          moveString,
          moveString.substring(0, moveString.length - 2),
          false,
          dest,
          promotion,
          validMoves);
    }
  }
}

Point<int> _parseCoord(String coord) {
  return Point<int>("abcdefgh".indexOf(coord[0]), int.parse(coord[1]) - 1);
}

ChessMove parseLongAlgebraicNotation(String notation, ChessGameState state) {
  Point<int> begin = _parseCoord(notation.substring(0, 2));
  Point<int> end = _parseCoord(notation.substring(2, 4));
  ChessPiece promotion = ChessPiece.none;
  if (notation.length == 5) {
    String promotionChar = notation.substring(4);
    for (ChessPiece p in ChessPiece.values) {
      if (p.pieceType.lowercaseChar == promotionChar) {
        promotion = p;
        break;
      }
    }
  }
  if (state.moves.isEmpty) {
    print("NO MOVES");
  }
  return state.moves.firstWhere(
      (m) => m.start == begin && m.end == end && m.promotion == promotion,
      orElse: () {
    print(
        "NO MOVE WAS FOUND FOR NOTATION ${notation} and state ${state.forsythEdwardsNotation}. Returning first move.");
    return state.moves.first;
  });
}

class MoveList {
  final ChessGameState result;
  final List<ChessMove> moves;

  MoveList(this.result, this.moves);
}

MoveList parseMoveList(ChessGameState startingState, List<String> moveList) {
  List<ChessMove> moves = [];
  ChessGameState state = startingState;
  for (String moveString in moveList) {
    ChessMove m = parseMoveString(moveString, state);
    state = state.playMove(m);
    moves.add(m);
  }
  return MoveList(state, moves);
}
