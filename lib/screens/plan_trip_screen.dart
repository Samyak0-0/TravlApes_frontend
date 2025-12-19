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

  final TextEditingController otherCategoryController =
      TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  final List<String> tripCategories = [
    "Food",
    "Hike",
    "Culture",
    "Adventure",
    "Party",
    "Nature",
    "History",
    "Wildlife",
    "Mountain",
    "Arts",
    "Festival",
    "Other",
  ];

  final List<String> transportModes = [
    "Bus",
    "Car",
    "Walk",
    "Bike",
    "Cycle",
  ];

  final Set<String> selectedCategories = {};
  String? selectedTransport;

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
            _categoryChips(),

            if (selectedCategories.contains("Other"))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextField(
                  controller: otherCategoryController,
                  decoration: const InputDecoration(
                    labelText: "Other (please specify)",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

            const SizedBox(height: 24),
            const Text(
              "Transportation Medium",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _transportChips(),

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

  // 🔹 Date Picker Widget
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

  // 🔹 Category Chips
  Widget _categoryChips() {
    return Wrap(
      spacing: 8,
      children: tripCategories.map((category) {
        final selected = selectedCategories.contains(category);
        return ChoiceChip(
          label: Text(category),
          selected: selected,
          onSelected: (_) {
            setState(() {
              selected
                  ? selectedCategories.remove(category)
                  : selectedCategories.add(category);
            });
          },
        );
      }).toList(),
    );
  }

  // 🔹 Transport Chips
  Widget _transportChips() {
    return Wrap(
      spacing: 8,
      children: transportModes.map((mode) {
        return ChoiceChip(
          label: Text(mode),
          selected: selectedTransport == mode,
          onSelected: (_) {
            setState(() => selectedTransport = mode);
          },
        );
      }).toList(),
    );
  }

  // 🔹 Pick Date
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

  // 🔹 Complete Action
  void _completeTrip() {
    // Save planned trip
    TripStore().addPlannedTrip(widget.destination);

    // Redirect to Trips tab
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainShell(initialIndex: 1),
      ),
      (route) => false,
    );
  }
}
