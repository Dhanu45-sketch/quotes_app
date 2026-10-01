import 'package:flutter/material.dart';
import 'package:quotes_app/screens/home_screen.dart';
import 'package:quotes_app/screens/quotes_screen.dart';
import 'package:quotes_app/theme/app_theme.dart';
import 'package:quotes_app/widgets/app_logo.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const List<Widget> _pages = [HomeScreen(), QuotesScreen()];

  int _index = 0;
  final Set<int> _visited = {0};

  @override
  Widget build(BuildContext context) {
    return PopScope(

      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) setState(() => _index = 0);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            for (var i = 0; i < _pages.length; i++)
              _visited.contains(i) ? _pages[i] : const SizedBox.shrink(),
          ],
        ),
        bottomNavigationBar: _BottomNavBar(
          currentIndex: _index,
          onTap: (i) => setState(() {
            _index = i;
            _visited.add(i);
          }),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.navBar,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              _NavItem(
                label: 'Home',
                icon: const Icon(Icons.home_filled),
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                label: 'Quotes',
                icon: const QuoteMarkIcon(),
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.navUnselected;

    return Expanded(
      child: Semantics(
        selected: selected,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(color: color, size: 26),
                child: icon,
              ),
              const SizedBox(height: 4),
              Text(label, style: AppTextStyles.navLabel.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
