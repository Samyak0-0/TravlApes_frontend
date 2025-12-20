import 'package:flutter/material.dart';
import 'package:paryatan_mantralaya_f/models/trip_model.dart';
import 'package:paryatan_mantralaya_f/store/trip_store.dart';

class PastTripScreen extends StatelessWidget {
  final String tripId;
  
  const PastTripScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    final trip = TripStore().getTripById(tripId);

    if (trip == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Past Trip'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(
          child: Text('Trip not found'),
        ),
      );
    }

    // Calculate expenses (budget minus remaining budget)
    final initialBudget = trip.budget ?? 0.0;
    // Get the original budget from trip creation (you'll need to add originalBudget field to Trip model)
    // For now, we'll assume the remaining budget is what's left after expenses
    // totalExpenses = originalBudget - currentBudget
    // Since we don't have originalBudget, we'll need to add expense tracking
    final totalExpenses = trip.expense!; // This should be calculated from tracked expenses
    
    // Get all attractions from all days
    final allAttractions = <String>[];
    final attractionImages = <String>[];
    trip.dayWiseAttractions.forEach((day, attractions) {
      for (var attraction in attractions) {
        allAttractions.add(attraction.name);
        if (attraction.imageUrl.isNotEmpty) {
          attractionImages.add(attraction.imageUrl);
        }
      }
    });

    // Get accommodation
    final accommodation = trip.accommodations.isNotEmpty 
        ? trip.accommodations.first.name 
        : 'No accommodation recorded';

    // Calculate trip duration
    final fromDate = trip.fromDate ?? DateTime.now();
    final toDate = trip.toDate ?? DateTime.now();
    final duration = toDate.difference(fromDate).inDays + 1;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          trip.destinations.isNotEmpty 
              ? trip.destinations.first.name 
              : 'Past Trip',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Trip Completed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${_formatDate(fromDate)} - ${_formatDate(toDate)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$duration ${duration == 1 ? 'day' : 'days'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Trip Summary Section
            const Text(
              'Trip Summary',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Expenses Card
            _summaryCard(
              icon: Icons.attach_money,
              iconColor: Colors.orange,
              title: 'Total Expenses',
              subtitle: '\$${totalExpenses.toStringAsFixed(2)}',
              gradient: [Colors.orange.shade50, Colors.orange.shade100],
            ),

            // Attractions Card
            if (allAttractions.isNotEmpty)
              _summaryCard(
                icon: Icons.place,
                iconColor: Colors.teal,
                title: 'Places Visited',
                subtitle: '${allAttractions.length} attraction${allAttractions.length == 1 ? '' : 's'}',
                gradient: [Colors.teal.shade50, Colors.teal.shade100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Attractions:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...allAttractions.take(5).map((attraction) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: Colors.teal),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              attraction,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )),
                    if (allAttractions.length > 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+ ${allAttractions.length - 5} more',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Accommodation Card
            _summaryCard(
              icon: Icons.hotel,
              iconColor: Colors.purple,
              title: 'Accommodation',
              subtitle: accommodation,
              gradient: [Colors.purple.shade50, Colors.purple.shade100],
            ),

            // Moods/Experience Card
            if (trip.moods != null && trip.moods!.isNotEmpty)
              _summaryCard(
                icon: Icons.sentiment_satisfied_alt,
                iconColor: Colors.blue,
                title: 'Trip Vibe',
                subtitle: trip.moods!.map((m) => m.name).join(', '),
                gradient: [Colors.blue.shade50, Colors.blue.shade100],
              ),

            const SizedBox(height: 24),

            // Explored Places Images Section
            if (attractionImages.isNotEmpty) ...[
              const Text(
                'Places You Explored',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: attractionImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 280,
                      margin: EdgeInsets.only(
                        right: index < attractionImages.length - 1 ? 16 : 0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              attractionImages[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Gradient overlay for better text visibility
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    allAttractions[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          trip.destinations.isNotEmpty
                                              ? trip.destinations.first.location
                                              : 'Unknown',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (child != null) child,
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
