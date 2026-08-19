import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allBrews = [];
  List<Map<String, dynamic>> _results = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBrews();
    _searchController.addListener(_search);
  }

  @override
  void dispose() {
    _searchController.removeListener(_search);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBrews() async {
    final brews = await StorageService.getBrews();

    if (!mounted) return;

    setState(() {
      _allBrews = brews.reversed.toList();
      _results = brews.reversed.toList();
      _isLoading = false;
    });
  }

  void _search() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _results = _allBrews;
      });
      return;
    }

    final filtered = _allBrews.where((brew) {
      final coffee = _value(brew, 'coffee').toLowerCase();
      final roaster = _value(brew, 'roaster').toLowerCase();
      final origin = _value(brew, 'origin').toLowerCase();
      final method = _value(brew, 'method').toLowerCase();
      final notes = _value(brew, 'notes').toLowerCase();

      return coffee.contains(query) ||
          roaster.contains(query) ||
          origin.contains(query) ||
          method.contains(query) ||
          notes.contains(query);
    }).toList();

    setState(() {
      _results = filtered;
    });
  }

  String _value(Map<String, dynamic> brew, String key) {
    return brew[key]?.toString() ?? '';
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
          'SEARCH',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: Color(0xFF2D211B),
          ),
        ),
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF5C4033),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search your coffee journal...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF8F8178),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF5C4033),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              color: const Color(0xFF8F8178),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Color(0xFFB39B89),
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: _results.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            return _SearchResultCard(
                              brew: _results[index],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    final hasSearch = _searchController.text.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearch ? Icons.search_off : Icons.coffee_outlined,
              size: 52,
              color: const Color(0xFFB39B89),
            ),
            const SizedBox(height: 16),
            Text(
              hasSearch ? 'No brews found' : 'Your journal is empty',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D211B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasSearch
                  ? 'Try searching for another coffee, roaster or method.'
                  : 'Log your first brew and it will appear here.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF8F8178),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> brew;

  const _SearchResultCard({
    required this.brew,
  });

  String _value(String key) {
    return brew[key]?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final coffee = _value('coffee');
    final roaster = _value('roaster');
    final method = _value('method');
    final origin = _value('origin');
    final rating = brew['rating'];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            coffee.isEmpty ? 'Unnamed coffee' : coffee,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D211B),
            ),
          ),

          const SizedBox(height: 5),

          if (roaster.isNotEmpty)
            Text(
              roaster,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6386AF),
              ),
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              if (method.isNotEmpty)
                _InfoChip(
                  icon: Icons.coffee_outlined,
                  text: method,
                ),

              if (origin.isNotEmpty) ...[
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.public,
                  text: origin,
                ),
              ],
            ],
          ),

          if (rating != null && rating != 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 17,
                  color: Color(0xFFB89B25),
                ),
                const SizedBox(width: 5),
                Text(
                  '$rating/5',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6F625A),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF3EEE8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: const Color(0xFF806F63),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF806F63),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}