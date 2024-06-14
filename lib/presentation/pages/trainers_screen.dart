import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';

class TrainersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainers'),
        backgroundColor: AppColors.primaryColor,
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
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        _getImageUrl(index), // Function to get different trainer images
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  _getTrainerName(index), // Function to get different trainer names
                  style: AppStyle.headingBlack,
                ),
                subtitle: Text(
                  'Specialization: ${_getSpecialization(index)}', // Function to get different trainer specializations
                  style: AppStyle.body,
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor),
                onTap: () {
                  // Handle trainer details navigation
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Example function to get different trainer images based on index
  String _getImageUrl(int index) {
    // Add your logic to return different trainer images
    // Here's a placeholder image URL
    return 'https://via.placeholder.com/150';
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
