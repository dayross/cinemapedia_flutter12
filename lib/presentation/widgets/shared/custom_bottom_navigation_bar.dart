import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigation({super.key, required this.currentIndex});

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      // home
      case 0:
        return context.go('/home/0');
      //favs
      case 1:
        return context.go('/home/1');
      //perfil
      case 2:
        return context.go('/home/2');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BottomNavigationBar(
        elevation: 0,
        onTap: (value) {
          return onItemTapped(context, value);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
                color: colors.primary,
              ),
              label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: colors.primary,
              ),
              label: 'Favoritos'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: colors.primary,
              ),
              label: 'Perfil'),
        ]);
  }
}
