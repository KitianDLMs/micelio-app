import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final VoidCallback? onPressed; // Cambia Function por VoidCallback
  final String text;

  const BotonAzul({
    Key? key,
    required this.onPressed, // Asegúrate de que sea VoidCallback
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: Colors.blue,
        shape: const StadiumBorder(),
        minimumSize: const Size(double.infinity, 55),
      ),
      onPressed: onPressed, // Sin error
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
