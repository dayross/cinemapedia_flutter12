import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      elevation: 0,
      items: [
      BottomNavigationBarItem(icon: Icon(Icons.home_rounded, color: colors.primary,), label: 'Inicio'),
      BottomNavigationBarItem(icon: Icon(Icons.favorite, color: colors.primary,), label: 'Favoritos'),
      BottomNavigationBarItem(icon: Icon(Icons.person, color: colors.primary,), label: 'Perfil'),
    ]);
  }
}
