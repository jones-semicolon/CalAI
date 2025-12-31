import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration graphCardDecoration(BuildContext context) => BoxDecoration(
  borderRadius: BorderRadius.circular(25),
  color: Theme.of(context).scaffoldBackgroundColor,
  border: Border.all(color: Theme.of(context).splashColor, width: 2),
  boxShadow: [
    BoxShadow(
      color: Theme.of(context).splashColor,
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ],
);
