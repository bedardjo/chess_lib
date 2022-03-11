enum Player { white, black }

extension PlayerUtil on Player {
  Player get opposite {
    switch (this) {
      case Player.white:
        return Player.black;
      case Player.black:
        return Player.white;
    }
  }

  String get fenChar {
    switch (this) {
      case Player.white:
        return "w";
      case Player.black:
        return "b";
    }
  }
}
