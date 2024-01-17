import 'package:bouggr/components/btn.dart';
import 'package:flutter/material.dart';

class BoggleCart extends StatelessWidget {

  String title;
  String action;
  VoidCallback onPressed;

  Widget? child;


  BoggleCart({
    super.key,
    required this.title,
    required this.action,
    required  this.onPressed,
    this.child,
  }
  )


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.white),
      child: Center(child: Column(
        children: [Text(title),
        child!,
          BtnBoggle(onPressed: onPressed)
        ],
      )),
    );
  }










}