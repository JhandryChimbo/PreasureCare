import 'package:flutter/material.dart';

class Page404 extends StatefulWidget {
  const Page404({super.key});

  @override
  _Page404State createState() => _Page404State();
}

class _Page404State extends State<Page404> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página No Encontrada'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
              '404',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
              '¡Vaya! La página que buscas no existe.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF2897FF),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}