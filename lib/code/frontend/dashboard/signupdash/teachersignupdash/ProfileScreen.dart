import 'package:flutter/material.dart';
import 'package:ai_paper_checking/code/frontend/session/user_session.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String firstName = UserSession.firstName;
    final String lastName = UserSession.lastName.isNotEmpty
        ? UserSession.lastName
        : '';
    final String fullName = '${firstName} ${lastName}'.trim().isNotEmpty
        ? '${firstName} ${lastName}'.trim()
        : 'Teacher';

    final String initials = (firstName.isNotEmpty && lastName.isNotEmpty)
        ? '${firstName[0]}${lastName[0]}'.toUpperCase()
        : firstName.isNotEmpty
        ? firstName[0].toUpperCase()
        : 'T';

    final String email = UserSession.email.isNotEmpty
        ? UserSession.email
        : 'Not provided';

    final String cnic = UserSession.cnic.isNotEmpty
        ? UserSession.cnic
        : 'Not provided';

    final String role = UserSession.gender.toLowerCase() == 'female'
        ? 'Teacher (Mam)'
        : 'Teacher (Sir)';

    final String displayName =
        '${UserSession.gender.toLowerCase() == 'female' ? 'Mam' : 'Sir'} $firstName';

    final int completion = _calcCompletion();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        children: [
          // ── Top Bar ──
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu_rounded, color: Colors.white, size: 30),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Stack(
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5757),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Avatar ──
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF6B8BFF), width: 2.5),
              gradient: const LinearGradient(
                colors: [Color(0xFF4A6CF7), Color(0xFF2A3ECC)],
              ),
            ),
            child: ClipOval(
              child:
                  UserSession.profileImage != null &&
                      UserSession.profileImage!.isNotEmpty
                  ? Image.network(
                      UserSession.profileImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 14),

          // ── Name & Role ──
          Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(
              color: const Color(0xFFB0BAD3).withOpacity(0.8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 24),

          // ── Info Section ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF131A4F).withOpacity(0.7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2A3580), width: 1),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Full Name',
                    value: fullName,
                    showDivider: true,
                  ),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: email,
                    showDivider: true,
                  ),
                  _InfoRow(
                    icon: Icons.badge_outlined,
                    label: 'CNIC',
                    value: cnic,
                    showDivider: true,
                  ),
                  _InfoRow(
                    icon: Icons.school_outlined,
                    label: 'Role',
                    value: role,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Profile Completion ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF131A4F).withOpacity(0.7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2A3580), width: 1),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Complete Your Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$completion%',
                        style: const TextStyle(
                          color: Color(0xFF6B8BFF),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: completion / 100,
                      minHeight: 8,
                      backgroundColor: const Color(0xFF2A3580),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF6B8BFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Menu Items ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF131A4F).withOpacity(0.7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2A3580), width: 1),
              ),
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal Information',
                    subtitle: 'Edit your details',
                    onTap: () {},
                    showDivider: true,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    subtitle: 'Secure your account',
                    onTap: () {},
                    showDivider: true,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'App preferences',
                    onTap: () {},
                    showDivider: true,
                  ),
                  _ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    subtitle: 'Get help and FAQs',
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Complete Profile Button ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B8BFF), Color(0xFF4A6CF7)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A6CF7).withOpacity(0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        'Complete Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static int _calcCompletion() {
    int filled = 0;
    if (UserSession.firstName.isNotEmpty) filled++;
    if (UserSession.lastName.isNotEmpty) filled++;
    if (UserSession.email.isNotEmpty) filled++;
    if (UserSession.cnic.isNotEmpty) filled++;
    if (UserSession.profileImage != null &&
        UserSession.profileImage!.isNotEmpty)
      filled++;
    return filled * 20;
  }
}

// ── Info Row ──
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2570),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF6B8BFF), size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: const Color(0xFFB0BAD3).withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            color: const Color(0xFF2A3580).withOpacity(0.8),
            indent: 52,
          ),
      ],
    );
  }
}

// ── Menu Item ──
class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2570),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF6B8BFF), size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: const Color(0xFFB0BAD3).withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF6B8BFF),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            color: const Color(0xFF2A3580).withOpacity(0.8),
            indent: 70,
            endIndent: 18,
          ),
      ],
    );
  }
}
