import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/presentation/providers/theme_provider.dart';
import 'package:tok_tik/presentation/screens/discover/discover_screen.dart';
import 'package:tok_tik/presentation/screens/for_you/for_you_screen.dart';
import 'package:tok_tik/presentation/screens/near_you/near_you_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _screens = [
    ForYouScreen(),
    DiscoverScreen(),
    NearYouScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'TokTik',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: primaryColor,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.6),
                width: 1.2,
              ),
            ),
            child: IconButton(
              tooltip: 'Tema actual: ${themeProvider.seasonName} (Toca para cambiar)',
              icon: Icon(
                themeProvider.seasonIcon,
                color: primaryColor,
              ),
              onPressed: () => themeProvider.cycleTheme(),
            ),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Para ti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Descubrir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Cerca de ti',
          ),
        ],
      ),
    );
  }
}
