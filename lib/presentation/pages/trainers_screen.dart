import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/presentation/pages/TrainerDetailsPage.dart';

class TrainersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final bgColor = isDarkMode ? Colors.black : AppColors.white;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final shadowColor =
        isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.1);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trainers',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10, // Example number of trainers
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(
                  color: Color.fromARGB(159, 221, 218, 221),
                  width: 0.5,
                ),
              ),
              elevation: 4,
              shadowColor: shadowColor,
              color: cardColor,
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        _getImageUrl(index),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  _getTrainerName(index),
                  style: AppStyle.headingBlack.copyWith(color: Colors.black),
                ),
                subtitle: Text(
                  'Specialization: ${_getSpecialization(index)}',
                  style: AppStyle.body.copyWith(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainerDetailsPage(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      backgroundColor: bgColor,
    );
  }

  // Example function to get different trainer images based on index
  String _getImageUrl(int index) {
    // Add your logic to return different trainer images
    // Here's a placeholder image URL
    return 'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/imp%2Ftrainer.webp?alt=media&token=f37808e7-5dc5-426a-8e17-e8b7101a0afb';
  }

  // Example function to get different trainer names based on index
  String _getTrainerName(int index) {
    // Add your logic to return different trainer names
    return 'Trainer ${index + 1}';
  }

  // Example function to get different trainer specializations based on index
  String _getSpecialization(int index) {
    // Add your logic to return different trainer specializations
    return 'Yoga, Strength Training';
  }
}
