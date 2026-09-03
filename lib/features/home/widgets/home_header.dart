import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, Cleber',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              Text('Alterar usuário'),
            ],
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),

        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ],
    );
  }
}
