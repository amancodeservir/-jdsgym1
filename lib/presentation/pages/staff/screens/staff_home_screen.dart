import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';

class StaffHomeScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_color,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildCarousel(),
                const SizedBox(height: 20),
                _buildCategoriesSection(),
                const SizedBox(height: 20),
                _buildDailyExercisesSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${userController.userData.value!.name}',
            style: AppStyle.heading,
          ),
          const SizedBox(height: 8),
          const Text(
            'What do you want to workout today?',
            style: AppStyle.heading2,
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider.builder(
      itemCount: 3,
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 9),
        enableInfiniteScroll: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: _buildWorkoutItem(index),
        );
      },
    );
  }

  Widget _buildWorkoutItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getWorkoutTitle(index),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getWorkoutDescription(index),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: AppColors.primaryColor,
            ),
            child: InkWell(
              onTap: () {
                // Add your action here
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'START',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_right_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Categories',
                style: AppStyle.headingBlack,
              ),
              Spacer(),
              Text(
                'See all',
                style: AppStyle.heading2,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCategories(),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 84,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CategoryItem(
            title: 'Weightlifting',
            icon: Icons.fitness_center,
          ),
          SizedBox(width: 8),
          CategoryItem(
            title: 'Yoga',
            icon: Icons.spa,
          ),
          SizedBox(width: 8),
          CategoryItem(
            title: 'Cardio',
            icon: Icons.directions_run,
          ),
          SizedBox(width: 8),
          CategoryItem(
            title: 'Stretching',
            icon: Icons.accessibility_new,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyExercisesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Daily Exercises',
                style: AppStyle.headingBlack,
              ),
              Spacer(),
              Text(
                'See all',
                style: AppStyle.heading2,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDailyExercises(),
        ],
      ),
    );
  }

  Widget _buildDailyExercises() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: const [
        ExerciseItem(
          title: 'Push Ups',
          subTitle: '20 Times',
          description: '6 Minutes',
          icon: Icons.fitness_center,
        ),
        SizedBox(height: 8),
        ExerciseItem(
          title: 'Running',
          subTitle: '4 Km',
          description: '10 Minutes',
          icon: Icons.directions_run,
        ),
        SizedBox(height: 8),
        ExerciseItem(
          title: 'Natrajasana Yoga Pose',
          subTitle: '2-6 Times',
          description: '15 Minutes',
          icon: Icons.spa,
        ),
        SizedBox(height: 8),
        ExerciseItem(
          title: 'Stretching',
          subTitle: '20 Times',
          description: '6 Minutes',
          icon: Icons.accessibility_new,
        ),
      ],
    );
  }

  String _getWorkoutTitle(int index) {
    List<String> titles = [
      'Start practicing \n Your workout!',
      'Cardio Blast',
      'Leg Day',
    ];
    return titles[index % titles.length];
  }

  String _getWorkoutDescription(int index) {
    List<String> descriptions = [
      '45 minutes',
      '30 minutes',
      '60 minutes',
    ];
    return descriptions[index % descriptions.length];
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryItem({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      width: 84,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Icon(icon, size: 32),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String description;
  final IconData icon;

  const ExerciseItem({
    required this.title,
    required this.subTitle,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, size: 32),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.watch_later,
                        color: Colors.blue,
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
