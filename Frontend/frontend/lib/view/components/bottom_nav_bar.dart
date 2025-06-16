import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../viewmodel/navigation_view_model.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(navigationViewModelProvider);
    final navigationViewModel = ref.read(navigationViewModelProvider.notifier);

    return ClipRRect(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 75,
            padding:
                const EdgeInsets.symmetric(horizontal: 48.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Home tab
                _buildNavItem(
                  context: context,
                  tab: NavigationTab.home,
                  icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
                  activeIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
                  label: 'Home',
                  isActive: currentTab == NavigationTab.home,
                  onTap: () {
                    navigationViewModel.setCurrentTab(NavigationTab.home);
                    context.go('/dashboard');
                  },
                ),

                // History tab
                _buildNavItem(
                  context: context,
                  tab: NavigationTab.history,
                  icon: Icons.history,
                  activeIcon: Icons.history,
                  label: 'History',
                  isActive: currentTab == NavigationTab.history,
                  onTap: () {
                    navigationViewModel.setCurrentTab(NavigationTab.history);
                    context.go('/history');
                  },
                ),

                // Profile tab
                _buildNavItem(
                  context: context,
                  tab: NavigationTab.profile,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  isActive: currentTab == NavigationTab.profile,
                  onTap: () {
                    navigationViewModel.setCurrentTab(NavigationTab.profile);
                    context.go('/profile');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required NavigationTab tab,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? const Color(0xFF4B4BEE) : Colors.grey.shade400,
            size: 28,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF4B4BEE) : Colors.grey.shade400,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
