import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String _nameKey = 'user_name';

  String _name = 'Your Name';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_nameKey);

    if (!mounted) return;

    if (savedName != null && savedName.trim().isNotEmpty) {
      setState(() {
        _name = savedName;
      });
    }
  }

  Future<void> _editName() async {
  String enteredName = _name;

  final newName = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Your name'),
        content: TextField(
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          onChanged: (value) {
            enteredName = value;
          },
          decoration: const InputDecoration(
            hintText: 'Enter your name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final name = enteredName.trim();

              if (name.isNotEmpty) {
                Navigator.pop(dialogContext, name);
              }
            },
            child: const Text('SAVE'),
          ),
        ],
      );
    },
  );

  if (newName == null || newName.trim().isEmpty) return;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_nameKey, newName.trim());

  if (!mounted) return;

  setState(() {
    _name = newName.trim();
  });
}

Future<void> _openPortfolio() async {
  final uri = Uri.parse(
    'https://balchandani23.github.io/portfolio/',
  );

  try {
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open portfolio'),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open portfolio'),
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EE),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF2D211B),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: Color(0xFF2D211B),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFILE HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE8DED4),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F3EE),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 48,
                      color: Color(0xFF5F4333),
                    ),
                  ),

                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: _editName,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D211B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: Color(0xFF806F63),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Coffee enthusiast',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF806F63),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'ABOUT DAILED IN.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Color(0xFF806F63),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'DAILED IN. is your personal coffee journal — '
                'a place to record your coffees, recipes, brewing methods '
                'and the little details that make every cup memorable.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF5F5148),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'DEVELOPER',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Color(0xFF806F63),
              ),
            ),

            const SizedBox(height: 12),

  InkWell(
  onTap: _openPortfolio,
  borderRadius: BorderRadius.circular(20),
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Built by Bhavya Balchandani',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D211B),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'A coffee lover building DAILED IN. to make '
                    'coffee journaling simple, personal and beautiful.''Tap to know more about developer',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF806F63),
                    ),
                  ),
            
                ],
              ),
            ),
            ),

            const SizedBox(height: 28),

            const Text(
              'APP',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Color(0xFF806F63),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.coffee_outlined,
                      color: Color(0xFF5F4333),
                    ),
                    title: Text(
                      'Coffee Journal',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D211B),
                      ),
                    ),
                    subtitle: Text('Your coffees. Your recipes.'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Color(0xFF5F4333),
                    ),
                    title: Text(
                      'About',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D211B),
                      ),
                    ),
                    subtitle: Text('DAILED IN.'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.numbers,
                      color: Color(0xFF5F4333),
                    ),
                    title: Text(
                      'Version',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D211B),
                      ),
                    ),
                    subtitle: Text('1.0.0'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                'YOUR COFFEE. YOUR RECIPE. YOUR RECORD.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9A897D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}