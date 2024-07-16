import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';

class TrainerDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trainer Details',
          style: TextStyle(color: Colors.white), // Adjust the color as needed
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white, // Adjust the color as needed
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            _buildTopImageSection(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: AppStyle.heading2Black.copyWith(color: AppColors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Certified Personal Trainer',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'About',
                    style: AppStyle.heading2Black.copyWith(color: AppColors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed varius luctus orci, at fermentum elit tempor ut. Suspendisse nec suscipit urna. Vivamus pharetra diam id quam tincidunt interdum.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Specializations',
                    style: AppStyle.heading2Black.copyWith(color: AppColors.black),
                  ),
                  const SizedBox(height: 8),
                  _buildSpecializationsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopImageSection() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/imp%2Ftrainer.webp?alt=media&token=f37808e7-5dc5-426a-8e17-e8b7101a0afb'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildSpecializationsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpecializationItem('Weight Loss'),
        _buildSpecializationItem('Muscle Gain'),
        _buildSpecializationItem('Cardio Fitness'),
        _buildSpecializationItem('Flexibility Training'),
      ],
    );
  }

  Widget _buildSpecializationItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TrainerDetailsPage(),
  ));
}
