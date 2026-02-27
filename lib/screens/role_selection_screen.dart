import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/user_role.dart';
import '../providers/role_provider.dart';
import '../theme/vatsalya_theme.dart';

/// Screen for selecting user role after login
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              VatsalyaTheme.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.medical_services,
                  size: 80,
                  color: VatsalyaTheme.primaryColor,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to SUDHA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: VatsalyaTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Select your care mode',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 48),
                _buildRoleCard(
                  context: context,
                  role: UserRole.general,
                  icon: Icons.local_hospital,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                _buildRoleCard(
                  context: context,
                  role: UserRole.pregnant,
                  icon: Icons.pregnant_woman,
                  color: VatsalyaTheme.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required UserRole role,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // 🔍 Debug print
          print("👤 ROLE BUTTON CLICKED: ${role.displayName}");
          
          // ✅ Step 1: Update role provider
          final roleProvider = context.read<RoleProvider>();
          roleProvider.setRole(role);
          
          // ✅ Step 2: Pop back to root so AppEntry rebuilds with new role
          Future.delayed(const Duration(milliseconds: 100), () {
            Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      role.displayName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: color,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                role.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
