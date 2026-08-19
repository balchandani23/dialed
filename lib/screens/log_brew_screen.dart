import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class LogBrewScreen extends StatefulWidget {
  final Map<String, dynamic>? brewToEdit;
  final int? brewIndex;

  const LogBrewScreen({
    super.key,
    this.brewToEdit,
    this.brewIndex,
  });

  @override
  State<LogBrewScreen> createState() => _LogBrewScreenState();
}

class _LogBrewScreenState extends State<LogBrewScreen> {
  final TextEditingController coffeeController = TextEditingController();
  final TextEditingController roasterController = TextEditingController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController waterController = TextEditingController();
  final TextEditingController temperatureController =
      TextEditingController();
  final TextEditingController grindController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String selectedMethod = 'V60';
  double rating = 0;

  // Default date is today, but you can change it manually.
  DateTime selectedDate = DateTime.now();

  final List<String> brewMethods = [
    'V60',
    'AeroPress',
    'French Press',
    'Espresso',
    'Chemex',
    'Moka Pot',
    'Cold Brew',
    'Other',
  ];

  @override
void initState() {
  super.initState();

  final brew = widget.brewToEdit;

  if (brew != null) {
    coffeeController.text = brew['coffee']?.toString() ?? '';
    roasterController.text = brew['roaster']?.toString() ?? '';
    originController.text = brew['origin']?.toString() ?? '';
    doseController.text = brew['dose']?.toString() ?? '';
    waterController.text = brew['water']?.toString() ?? '';
    temperatureController.text = brew['temperature']?.toString() ?? '';
    grindController.text = brew['grind']?.toString() ?? '';
    timeController.text = brew['time']?.toString() ?? '';
    notesController.text = brew['notes']?.toString() ?? '';

    selectedMethod = brew['method']?.toString() ?? 'V60';

    final savedDate = brew['date']?.toString();
    if (savedDate != null) {
      selectedDate = DateTime.tryParse(savedDate) ?? DateTime.now();
    }

    rating = (brew['rating'] ?? 0).toDouble();
  }
}

  @override
  void dispose() {
    coffeeController.dispose();
    roasterController.dispose();
    originController.dispose();
    doseController.dispose();
    waterController.dispose();
    temperatureController.dispose();
    grindController.dispose();
    timeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveBrew() async {
  final brew = {
    'coffee': coffeeController.text.trim(),
    'roaster': roasterController.text.trim(),
    'origin': originController.text.trim(),
    'date': selectedDate.toIso8601String(),
    'method': selectedMethod,
    'dose': doseController.text.trim(),
    'water': waterController.text.trim(),
    'temperature': temperatureController.text.trim(),
    'grind': grindController.text.trim(),
    'time': timeController.text.trim(),
    'rating': rating,
    'notes': notesController.text.trim(),
  };

if (widget.brewIndex != null) {
  await StorageService.updateBrew(widget.brewIndex!, brew);
} else {
  await StorageService.saveBrew(brew);
}

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Brew saved! ☕'),
      behavior: SnackBarBehavior.floating,
    ),
  );

  Navigator.pop(context);
}

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF7F3EE),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF5C4033),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EE),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7EE),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'LOG A BREW',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Color(0xFF2D211B),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // INTRO
            const Text(
              'Record your brew.',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D211B),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Keep track of every cup and build your coffee history.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF806F63),
              ),
            ),

            const SizedBox(height: 28),

            // COFFEE
            TextField(
              controller: coffeeController,
              decoration: _inputDecoration(
                'Coffee',
                Icons.coffee_outlined,
              ),
            ),

            const SizedBox(height: 14),

            // ROASTER
            TextField(
              controller: roasterController,
              decoration: _inputDecoration(
                'Roaster',
                Icons.storefront_outlined,
              ),
            ),

            const SizedBox(height: 14),

            // ORIGIN
            TextField(
              controller: originController,
              decoration: _inputDecoration(
                'Origin',
                Icons.public_outlined,
              ),
            ),

            const SizedBox(height: 24),

            // DATE
            const Text(
              'BREW DATE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Color(0xFF806F63),
              ),
            ),

            const SizedBox(height: 8),

            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F3EE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF5C4033),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        _formatDate(selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D211B),
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF806F63),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // BREW METHOD
            const Text(
              'BREW METHOD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Color(0xFF806F63),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F3EE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMethod,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: brewMethods.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedMethod = value;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // RECIPE
            const Text(
              'RECIPE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Color(0xFF806F63),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: doseController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      'Coffee dose (g)',
                      Icons.scale_outlined,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller: waterController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      'Water (g)',
                      Icons.water_drop_outlined,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: temperatureController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      'Temp (°C)',
                      Icons.thermostat_outlined,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller: grindController,
                    decoration: _inputDecoration(
                      'Grind size',
                      Icons.tune,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            TextField(
              controller: timeController,
              decoration: _inputDecoration(
                'Brew time',
                Icons.timer_outlined,
              ),
            ),

            const SizedBox(height: 28),

            // RATING
            const Text(
              'RATING',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Color(0xFF806F63),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                ...List.generate(5, (index) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        rating = index + 1.0;
                      });
                    },
                    icon: Icon(
                      index < rating
                          ? Icons.star
                          : Icons.star_border,
                      size: 32,
                      color: const Color(0xFF5C4033),
                    ),
                  );
                }),

                const SizedBox(width: 12),

                Text(
                  rating == 0
                      ? 'Not rated'
                      : '${rating.toInt()}/5',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF806F63),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // NOTES
            TextField(
              controller: notesController,
              maxLines: 5,
              decoration: _inputDecoration(
                'Notes',
                Icons.notes_outlined,
              ),
            ),

            const SizedBox(height: 28),

            // SAVE
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _saveBrew,
                icon: const Icon(Icons.check),
                label: const Text(
                  'SAVE BREW',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C4033),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}