import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';

class WorkoutDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Details',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _buildTopImage(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weight Loss Training',
                    style: AppStyle.heading.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Description:',
                    style: AppStyle.heading2.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam quis dolor nec leo tincidunt rutrum. Suspendisse potenti.',
                    style: AppStyle.body.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Specifications:',
                    style: AppStyle.heading2.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 8),
                  _buildSpecificationItem('Duration', '45 minutes', textColor),
                  _buildSpecificationItem('Intensity', 'High', textColor),
                  _buildSpecificationItem('Equipment', 'Dumbbells, Yoga Mat', textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/imp%2Fwo-removebg-preview.png?alt=media&token=0a0b3bf0-43d8-46f8-b49c-ab29996c1ac8',
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildSpecificationItem(String label, String value, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyle.body.copyWith(color: textColor),
        ),
        Text(
          value,
          style: AppStyle.body.copyWith(color: AppColors.lightGrey),
        ),
      ],
    );
  }
}
