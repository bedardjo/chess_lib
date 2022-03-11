import 'player.dart';

enum PieceType { pawn, rook, knight, bishop, queen, king }

PieceType pieceTypeFromChar(String c) {
  for (PieceType pt in PieceType.values) {
    if (pt.unicodeCharacter == c) {
      return pt;
    }
  }
  throw Exception("invalid piece type string ${c}");
}

extension PieceTypeUtil on PieceType {
  String get unicodeCharacter {
    switch (this) {
      case PieceType.pawn:
        return "P";
      case PieceType.knight:
        return "N";
      case PieceType.bishop:
        return "B";
      case PieceType.rook:
        return "R";
      case PieceType.queen:
        return "Q";
      case PieceType.king:
        return "K";
    }
  }

  String get lowercaseChar {
    switch (this) {
      case PieceType.pawn:
        return "p";
      case PieceType.knight:
        return "n";
      case PieceType.bishop:
        return "b";
      case PieceType.rook:
        return "r";
      case PieceType.queen:
        return "q";
      case PieceType.king:
        return "k";
    }
  }
}

enum ChessPiece {
  white_pawn,
  white_rook,
  white_knight,
  white_bishop,
  white_queen,
  white_king,

  black_pawn,
  black_rook,
  black_knight,
  black_bishop,
  black_queen,
  black_king,

  none
}

extension ChessPieceUtils on ChessPiece {
  String get unicodeCharacter {
    switch (this) {
      case ChessPiece.white_pawn:
        return "P";
      case ChessPiece.black_pawn:
        return "p";
      case ChessPiece.white_knight:
        return "N";
      case ChessPiece.white_bishop:
        return "B";
      case ChessPiece.black_knight:
        return "n";
      case ChessPiece.black_bishop:
        return "b";
      case ChessPiece.white_rook:
        return "R";
      case ChessPiece.black_rook:
        return "r";
      case ChessPiece.white_queen:
        return "Q";
      case ChessPiece.black_queen:
        return "q";
      case ChessPiece.white_king:
        return "K";
      case ChessPiece.black_king:
        return "k";
      case ChessPiece.none:
        return "";
    }
  }

  bool get isWhite {
    switch (this) {
      case ChessPiece.white_pawn:
        return true;
      case ChessPiece.black_pawn:
        return false;
      case ChessPiece.white_knight:
        return true;
      case ChessPiece.white_bishop:
        return true;
      case ChessPiece.black_knight:
        return false;
      case ChessPiece.black_bishop:
        return false;
      case ChessPiece.white_rook:
        return true;
      case ChessPiece.black_rook:
        return false;
      case ChessPiece.white_queen:
        return true;
      case ChessPiece.black_queen:
        return false;
      case ChessPiece.white_king:
        return true;
      case ChessPiece.black_king:
        return false;
      case ChessPiece.none:
        throw Exception("invalid");
    }
  }

  Player get owner {
    switch (this) {
      case ChessPiece.white_pawn:
        return Player.white;
      case ChessPiece.black_pawn:
        return Player.black;
      case ChessPiece.white_knight:
        return Player.white;
      case ChessPiece.white_bishop:
        return Player.white;
      case ChessPiece.black_knight:
        return Player.black;
      case ChessPiece.black_bishop:
        return Player.black;
      case ChessPiece.white_rook:
        return Player.white;
      case ChessPiece.black_rook:
        return Player.black;
      case ChessPiece.white_queen:
        return Player.white;
      case ChessPiece.black_queen:
        return Player.black;
      case ChessPiece.white_king:
        return Player.white;
      case ChessPiece.black_king:
        return Player.black;
      case ChessPiece.none:
        throw Exception("invalid");
    }
  }

  PieceType get pieceType {
    switch (this) {
      case ChessPiece.white_pawn:
      case ChessPiece.black_pawn:
        return PieceType.pawn;
      case ChessPiece.white_knight:
      case ChessPiece.black_knight:
        return PieceType.knight;
      case ChessPiece.white_bishop:
      case ChessPiece.black_bishop:
        return PieceType.bishop;
      case ChessPiece.white_rook:
      case ChessPiece.black_rook:
        return PieceType.rook;
      case ChessPiece.white_queen:
      case ChessPiece.black_queen:
        return PieceType.queen;
      case ChessPiece.white_king:
      case ChessPiece.black_king:
        return PieceType.king;
      case ChessPiece.none:
        throw Exception("invalid");
    }
  }
}
