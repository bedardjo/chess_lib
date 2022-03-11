# chess_lib

The `chess_lib` package for Dart allows you to model chess games. All the rules of chess are modelled as well as parsing forsyth edwards notation and also algebraic notation for moves.

## Getting Started

To import

```dart
import 'package:chess_lib/chess_lib.dart';
```

And here is a simple usage:

```dart
ChessGameState state = ChessGameState.initialBoardPosition();
state = state.playMove(state.moves[0]);
state = state.playMove(state.moves[0]);
state = state.playMove(state.moves[0]);
print(state.forsythEdwardsNotation);
```
