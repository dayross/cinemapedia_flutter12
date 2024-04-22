import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  int getCurrentIndex(BuildContext context){
    final String location = GoRouterState.of(context).uri.toString();
    switch(location){
      case '/':
        return 0;
      case '/perfil':
        return 2;
      case '/favourites':
        return 1;
      default:
        return 0;
    }
  }

  void onItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/favourites');
        break;
       case 2:
        context.go('/');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: getCurrentIndex(context),
      onTap: (index) => onItemTap(context, index),
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
