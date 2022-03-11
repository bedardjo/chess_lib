import 'dart:math';

import 'castling.dart';
import 'chess-piece.dart';

class ChessMove {
  final ChessPiece piece;
  final Point<int> start;
  final Point<int> end;
  final ChessPiece capture;
  final ChessPiece promotion;
  final Castling castling;
  final bool enPessant;

  String moveString = "";

  ChessMove(
      {required this.piece,
      required this.start,
      required this.end,
      this.capture = ChessPiece.none,
      this.promotion = ChessPiece.none,
      this.castling = Castling.none,
      this.enPessant = false});

  @override
  bool operator ==(o) =>
      o is ChessMove &&
      piece == o.piece &&
      start == o.start &&
      end == o.end &&
      capture == o.capture &&
      promotion == o.promotion &&
      castling == o.castling;

  @override
  int get hashCode =>
      31 *
          (31 *
                  (31 *
                          (31 *
                                  (31 * (31 + promotion.hashCode) +
                                      capture.hashCode) +
                              end.hashCode) +
                      start.hashCode) +
              piece.hashCode) +
      castling.hashCode;
}
