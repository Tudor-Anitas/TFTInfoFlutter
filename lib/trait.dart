import 'package:flutter/material.dart';


class Trait{
  /// the name of the trait
  String name;
  /// (0 = No style, 1 = Bronze, 2 = Silver, 3 = Gold, 4 = Chromatic)
  int style;
  // the number of traits in all matches
  int count;

  Trait({this.name, this.style, this.count = 0});

  @override
  bool operator ==(Object other) =>
    other is Trait &&
    other.name == name &&
    other.style == style;

  @override
  int get hashCode => hashValues(name, style);
}