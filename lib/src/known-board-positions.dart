import 'chess-piece.dart';

List<List<ChessPiece>> startingBoard = [
  [
    ChessPiece.white_rook,
    ChessPiece.white_knight,
    ChessPiece.white_bishop,
    ChessPiece.white_queen,
    ChessPiece.white_king,
    ChessPiece.white_bishop,
    ChessPiece.white_knight,
    ChessPiece.white_rook
  ],
  List.generate(8, (index) => ChessPiece.white_pawn),
  ...List.generate(4, (index) => List.generate(8, (index) => ChessPiece.none)),
  List.generate(8, (index) => ChessPiece.black_pawn),
  [
    ChessPiece.black_rook,
    ChessPiece.black_knight,
    ChessPiece.black_bishop,
    ChessPiece.black_queen,
    ChessPiece.black_king,
    ChessPiece.black_bishop,
    ChessPiece.black_knight,
    ChessPiece.black_rook
  ],
];

List<List<ChessPiece>> createEmptyBoard() =>
    List.generate(8, (index) => List.generate(8, (index) => ChessPiece.none));
