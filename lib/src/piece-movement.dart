import 'dart:math';

const List<Point<int>> rookDirections = [
  Point<int>(-1, 0),
  Point<int>(1, 0),
  Point<int>(0, -1),
  Point<int>(0, 1),
];

const List<Point<int>> bishopDirections = [
  Point<int>(-1, -1),
  Point<int>(-1, 1),
  Point<int>(1, 1),
  Point<int>(1, -1),
];

List<Point<int>> queenDirections = rookDirections + bishopDirections;

const List<Point<int>> knightMoves = [
  Point<int>(-1, 2),
  Point<int>(1, 2),
  Point<int>(2, 1),
  Point<int>(2, -1),
  Point<int>(-1, -2),
  Point<int>(1, -2),
  Point<int>(-2, 1),
  Point<int>(-2, -1),
];
