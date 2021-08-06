import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberField extends StatefulWidget {
  final TextEditingController? controller;

  const NumberField({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  _NumberFieldState createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: TextField(
        onChanged: (s) {
          setState(() {});
        },
        controller: widget.controller,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            fillColor: widget.controller!.text.isEmpty
                ? Colors.red
                : Colors.blueAccent,
            filled: true),
      ),
    );
  }
}
