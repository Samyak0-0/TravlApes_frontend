import 'package:flutter/material.dart';
import '../store/trip_store.dart';
import '../models/destination_model.dart';
import 'planning_screen.dart';

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
      appBar: AppBar(title: const Text("Plan Trip")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _datePicker(
              label: "From Date",
              date: fromDate,
              onTap: () => _pickDate(isFrom: true),
            ),
            const SizedBox(height: 12),
            _datePicker(
              label: "To Date",
              date: toDate,
              onTap: () => _pickDate(isFrom: false),
            ),
            const SizedBox(height: 24),

            const Text(
              "What kind of trip do you want?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _moodChips(),

            const SizedBox(height: 24),
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
                child: const Text("Complete"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // HELPERS
  // --------------------------------------------------

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

  List<Mood> _mapMoodsToEnum() {
    return selectedMoods.map((m) {
      switch (m) {
        case 'Food':
          return Mood.food;
        case 'Cultural':
          return Mood.cultural;
        case 'Entertainment':
          return Mood.entertainment;
        case 'Peaceful':
          return Mood.peaceful;
        case 'Adventurous':
          return Mood.adventurous;
        case 'Nature':
          return Mood.nature;
        default:
          throw Exception('Unknown mood');
      }
    }).toList();
  }

  void _completeTrip() async {
    if (fromDate == null ||
        toDate == null ||
        selectedMoods.isEmpty ||
        budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final budget = double.tryParse(budgetController.text) ?? 0;

    await TripStore().addPlannedTrip(
      destination: widget.destination,
      fromDate: fromDate!,
      toDate: toDate!,
      moods: _mapMoodsToEnum(),
      budget: budget,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PlanningScreen(
          destination: widget.destination,
          fromDate: fromDate!,
          toDate: toDate!,
          moods: _mapMoodsToEnum(),
          budget: budget,
        ),
      ),
    );
  }
}
