import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: const Text(
          'Aquí irá la información del perfil del usuario',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
