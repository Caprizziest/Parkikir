import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/navigation_view_model.dart';
import '../viewmodel/auth_view_model.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
    // Set current tab to profile when profile is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(navigationViewModelProvider.notifier)
          .setCurrentTab(NavigationTab.profile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg_dashboard1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Background decoration bird image
            Positioned(
              top: 10,
              left: 160,
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  'assets/burung.png',
                  width: 140,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Background decoration car image
            Positioned(
              top: 225,
              right: 30,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/mobil.png',
                  width: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App bar
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 15.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Image.asset(
                          'assets/logowhite.png',
                          height: 35,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Profile Section
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Avatar
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Username
                          const Text(
                            'USERNAME',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Menu Items Container
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 24,
                            offset: const Offset(0, -8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Change Password
                          _buildMenuItem(
                            icon: Icons.lock_outline,
                            title: 'Change Password',
                            onTap: () {
                              // Navigate to change password
                            },
                          ),

                          const SizedBox(height: 8),

                          // Settings
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            onTap: () {
                              // Navigate to settings
                            },
                          ),

                          const SizedBox(height: 8),

                          // Preferences
                          _buildMenuItem(
                            icon: Icons.tune_outlined,
                            title: 'Preferences',
                            onTap: () {
                              // Navigate to preferences
                            },
                          ),

                          const SizedBox(height: 8),

                          // About ParkirKi'
                          _buildMenuItem(
                            icon: Icons.info_outline,
                            title: 'About ParkirKi\'',
                            onTap: () {
                              // Navigate to about
                            },
                          ),

                          const SizedBox(height: 8),

                          // Help Center
                          _buildMenuItem(
                            icon: Icons.help_outline,
                            title: 'Help Center',
                            onTap: () {
                              // Navigate to help center
                            },
                          ),

                          const SizedBox(height: 8),

                          // Logout
                          _buildMenuItem(
                            icon: Icons.logout,
                            title: 'Logout',
                            isLogout: true,
                            onTap: () {
                              // Handle logout
                              _showLogoutDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ], // end of Column children
                ), // end of Column
              ), // end of SingleChildScrollView
            ), // end of Padding
          ], // end of Stack children
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isLogout ? Colors.red : Colors.black87,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isLogout ? Colors.red : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Handle actual logout logic here
                await ref.read(authViewModelProvider).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
