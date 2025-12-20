// import 'package:flutter/material.dart';
// import '../services/recommendation_service.dart';
// import 'recommendation_result_screen.dart';

// class RecommendationLoadingScreen extends StatefulWidget {
//   final String location;

//   const RecommendationLoadingScreen({
//     super.key,
//     required this.location,
//   });

//   @override
//   State<RecommendationLoadingScreen> createState() =>
//       _RecommendationLoadingScreenState();
// }

// class _RecommendationLoadingScreenState
//     extends State<RecommendationLoadingScreen> {
//   final RecommendationService _service = RecommendationService();

//   @override
//   void initState() {
//     super.initState();
//     _loadRecommendations();
//   }

//   Future<void> _loadRecommendations() async {
//     try {
//       final data = await _service.recommendPlaces(
//         location: widget.location,
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => RecommendationResultScreen(data: data),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 12),
//             Text("Finding the best places for you..."),
//           ],
//         ),
//       ),
//     );
//   }
// }
