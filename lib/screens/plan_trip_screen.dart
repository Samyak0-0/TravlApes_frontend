import 'package:flutter/material.dart';
import 'main_shell.dart';
import '../store/trip_store.dart';

class PlanTripScreen extends StatefulWidget {
  final String destination;

  const PlanTripScreen({
    super.key,
    required this.destination,
  });

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  DateTime? fromDate;
  DateTime? toDate;

  final TextEditingController budgetController = TextEditingController();

  // ✅ BACKEND-COMPATIBLE MOODS ONLY
  final List<String> moods = [
    "Food",
    "Cultural",
    "Entertainment",
    "Peaceful",
    "Adventurous",
    "Nature",
  ];

  final Set<String> selectedMoods = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plan Trip"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📅 FROM DATE
            _datePicker(
              label: "From Date",
              date: fromDate,
              onTap: () => _pickDate(isFrom: true),
            ),
            const SizedBox(height: 12),

            // 📅 TO DATE
            _datePicker(
              label: "To Date",
              date: toDate,
              onTap: () => _pickDate(isFrom: false),
            ),

            const SizedBox(height: 24),

            // 🎯 MOODS
            const Text(
              "What kind of trip do you want?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _moodChips(),

            const SizedBox(height: 24),

            // 💰 BUDGET
            const Text(
              "Budget",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter your budget",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 40),

            // ✅ COMPLETE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _completeTrip,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Complete",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 DATE PICKER
  Widget _datePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date == null
                  ? label
                  : "${date.day}/${date.month}/${date.year}",
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  // 🔹 MOOD CHIPS
  Widget _moodChips() {
    return Wrap(
      spacing: 8,
      children: moods.map((mood) {
        final selected = selectedMoods.contains(mood);
        return ChoiceChip(
          label: Text(mood),
          selected: selected,
          onSelected: (_) {
            setState(() {
              selected
                  ? selectedMoods.remove(mood)
                  : selectedMoods.add(mood);
            });
          },
        );
      }).toList(),
    );
  }

  // 🔹 PICK DATE
  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        isFrom ? fromDate = picked : toDate = picked;
      });
    }
  }

  // 🔹 COMPLETE ACTION
  void _completeTrip() {
    // (Later: send this to /places/recommend)
    TripStore().addPlannedTrip(widget.destination);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainShell(initialIndex: 1),
      ),
      (route) => false,
    );
  }
}
