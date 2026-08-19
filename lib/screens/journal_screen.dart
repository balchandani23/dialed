import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'log_brew_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<Map<String, dynamic>> brews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBrews();
  }

  Future<void> _loadBrews() async {
    final savedBrews = await StorageService.getBrews();

    if (!mounted) return;

    setState(() {
      brews = savedBrews.reversed.toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EE),
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        title: const Text(
          'MY JOURNAL',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Color(0xFF2D211B),
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5C4033)),
            )
          : brews.isEmpty
          ? _EmptyJournal()
          : RefreshIndicator(
              color: const Color(0xFF5C4033),
              onRefresh: _loadBrews,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                itemCount: brews.length,
                itemBuilder: (context, index) {
                  final brew = Map<String, dynamic>.from(brews[index]);

                  brew['storageIndex'] = brews.length - 1 - index;
                  return _BrewCard(
                    brew: brew,
                    onDelete: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text('Delete brew?'),
                            content: const Text(
                              'Are you sure you want to delete this brew? '
                              'This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, false);
                                },
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, true);
                                },
                                child: const Text('DELETE'),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldDelete != true) return;

                      final originalIndex = brews.length - 1 - index;

                      await StorageService.deleteBrew(originalIndex);

                      await _loadBrews();
                    },

                    onEdit: () async {
                      final originalIndex = brews.length - 1 - index;

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogBrewScreen(
                            brewToEdit: brews[index],
                            brewIndex: originalIndex,
                          ),
                        ),
                      );

                      await _loadBrews();
                    },
                  );
                },
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────
// EMPTY JOURNAL
// ─────────────────────────────────────────────

class _EmptyJournal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE8DED4),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                size: 38,
                color: Color(0xFF5C4033),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Your journal is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D211B),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Log your first brew and start building your coffee history.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF806F63),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BREW CARD
// ─────────────────────────────────────────────

class _BrewCard extends StatelessWidget {
  final Map<String, dynamic> brew;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const _BrewCard({required this.brew, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final rating = (brew['rating'] ?? 0).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coffee + method
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8DED4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.coffee_outlined,
                  color: Color(0xFF5C4033),
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _value('coffee'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D211B),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${_value('roaster')} • ${_value('method')}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF806F63),
                      ),
                    ),
                  ],
                ),
              ),

              // EDIT BUTTON
              if (onEdit != null)
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF808663),
                  ),
                  onPressed: onEdit,
                  tooltip: 'Edit brew',
                ),

              // DELETE BUTTON
              if (onDelete != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFF808663),
                  ),
                  onPressed: onDelete,
                  tooltip: 'Delete brew',
                ),
            ],
          ),

          const SizedBox(height: 18),

          // Recipe information
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

            decoration: BoxDecoration(
              color: const Color(0xFFF7F3EE),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _RecipeValue(label: 'COFFEE', value: '${_value('dose')} g'),
                _RecipeValue(label: 'WATER', value: '${_value('water')} g'),
                _RecipeValue(label: 'TEMP', value: '${_value('temperature')}°'),
                _RecipeValue(label: 'TIME', value: _value('time')),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Rating
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 20,
                  color: const Color(0xFF5C4033),
                );
              }),

              const SizedBox(width: 8),

              Text(
                rating > 0 ? '${rating.toInt()}/5' : 'Not rated',
                style: const TextStyle(fontSize: 12, color: Color(0xFF806F63)),
              ),
            ],
          ),

          // Notes
          if (_value('notes').isNotEmpty) ...[
            const SizedBox(height: 14),

            Text(
              '"${_value('notes')}"',
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                fontStyle: FontStyle.italic,
                color: Color(0xFF5C4033),
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Bottom details
          Row(
            children: [
              const Icon(
                Icons.public_outlined,
                size: 16,
                color: Color(0xFF806F63),
              ),

              const SizedBox(width: 5),

              Text(
                _value('origin'),
                style: const TextStyle(fontSize: 12, color: Color(0xFF806F63)),
              ),

              const Spacer(),

              Text(
                _formatDate(_value('date')),
                style: const TextStyle(fontSize: 12, color: Color(0xFF806F63)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _value(String key) {
    final value = brew[key];

    if (value == null) {
      return '';
    }

    return value.toString();
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '';

    try {
      final parsed = DateTime.parse(date);

      return '${parsed.day}/${parsed.month}/${parsed.year}';
    } catch (_) {
      return '';
    }
  }
}

// ─────────────────────────────────────────────
// RECIPE VALUE
// ─────────────────────────────────────────────

class _RecipeValue extends StatelessWidget {
  final String label;
  final String value;

  const _RecipeValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Color(0xFF806F63),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D211B),
          ),
        ),
      ],
    );
  }
}
