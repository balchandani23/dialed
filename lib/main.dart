import 'package:flutter/material.dart';
import 'screens/journal_screen.dart';
import 'screens/log_brew_screen.dart';
import 'services/storage_service.dart';
import './screens/profile_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const DialedApp());
}

class DialedApp extends StatelessWidget {
  const DialedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DIALED',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F3EE),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C4033)),
      ),
      home: const HomeScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _openBrewScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LogBrewScreen()),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────────────────────
              // HEADER
              // ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DIALED IN.',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                          color: Color(0xFF2D211B),
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Your coffee. Your recipe. Your record.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF806F63),
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8DED4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF5F4333),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ─────────────────────────────
              // COFFEE SPACE
              // ─────────────────────────────
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8DED4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.coffee_outlined,
                      color: Color(0xFF6B4F3E),
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR COFFEE SPACE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: Color(0xFF8F806F),
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          'Brew. Record. Remember.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6F6258),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // ─────────────────────────────
              // RECENT BREWS
              // ─────────────────────────────
              const Text(
                'RECENT BREWS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF806F63),
                ),
              ),

              const SizedBox(height: 14),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: StorageService.getBrews(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final brews = snapshot.data ?? [];

                  final totalBrews = brews.length;

                  final methods = brews
                      .map((brew) => brew['method']?.toString())
                      .where((method) => method != null && method.isNotEmpty)
                      .toSet();

                  final roasters = brews
                      .map(
                        (brew) =>
                            brew['roaster']?.toString().trim().toLowerCase(),
                      )
                      .where((roaster) => roaster != null && roaster.isNotEmpty)
                      .toSet();

                  final ratings = brews
                      .map((brew) => (brew['rating'] ?? 0).toDouble())
                      .where((rating) => rating > 0)
                      .toList();

                  final averageRating = ratings.isEmpty
                      ? 0.0
                      : ratings.reduce((a, b) => a + b) / ratings.length;

                  // ─────────────────────────
                  // NO BREWS
                  // ─────────────────────────

                  if (brews.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8DED4),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        'No brews yet.',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D211B),
                        ),
                      ),
                    );
                  }

                  // ─────────────────────────
                  // BREWS EXIST
                  // ─────────────────────────

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8DED4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your coffee journal',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D211B),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '${brews.length} brew${brews.length == 1 ? '' : 's'} logged',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF806F63),
                          ),
                        ),

                        const SizedBox(height: 18),

                        ...brews.reversed
                            .take(3)
                            .map(
                              (brew) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      brew['coffee']?.toString() ??
                                          'Unnamed coffee',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2D211B),
                                      ),
                                    ),

                                    const SizedBox(height: 3),

                                    Text(
                                      brew['roaster']?.toString() ??
                                          'Unknown roaster',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4F7CAC),
                                      ),
                                    ),

                                    const SizedBox(height: 3),

                                    Text(
                                      brew['method']?.toString() ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF808663),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                        const SizedBox(height: 8),

                        // ─────────────────────
                        // INSIGHTS
                        // ─────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3ECE5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _HomeInsight(
                                label: 'BREWS',
                                value: totalBrews.toString(),
                              ),

                              _HomeInsight(
                                label: 'METHODS',
                                value: methods.length.toString(),
                              ),

                              _HomeInsight(
                                label: 'ROASTERS',
                                value: roasters.length.toString(),
                              ),

                              _HomeInsight(
                                label: 'AVG. RATING',
                                value: averageRating == 0
                                    ? '—'
                                    : averageRating.toStringAsFixed(1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // ─────────────────────────────────
      // BOTTOM NAVIGATION
      // ─────────────────────────────────
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8DED4),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // HOME
              const _NavItem(
                icon: Icons.home_filled,
                label: 'Home',
                selected: true,
              ),

              // BREW
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogBrewScreen(),
                    ),
                  );
                },
                child: const _NavItem(
                  icon: Icons.add_circle_outline,
                  label: 'Brew',
                ),
              ),

              // JOURNAL
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JournalScreen(),
                    ),
                  );
                },
                child: const _NavItem(
                  icon: Icons.menu_book_outlined,
                  label: 'Journal',
                ),
              ),

              // SEARCH
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: const _NavItem(icon: Icons.search, label: 'Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LOG A BREW SCREEN
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
// REUSABLE INPUT FIELD
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
// QUICK CARD
// ─────────────────────────────────────────────

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _QuickCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: const Color(0xFF5C4033)),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF2D211B),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF806F63)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NAVIGATION ITEM
// ─────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 22,
          color: selected ? const Color(0xFF5C4033) : const Color(0xFF806F63),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? const Color(0xFF5C4033) : const Color(0xFF806F63),
          ),
        ),
      ],
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24,
          color: selected ? const Color(0xFF5C4033) : const Color(0xFF808080),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? const Color(0xFF5C4033) : const Color(0xFF808080),
          ),
        ),
      ],
    );
  }
}

class _HomeInsight extends StatelessWidget {
  final String label;
  final String value;

  const _HomeInsight({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F211B),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: Color(0xFF8F8063),
          ),
        ),
      ],
    );
  }
}
