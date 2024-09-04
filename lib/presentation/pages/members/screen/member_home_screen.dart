import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:rkfitness/presentation/controllers/user_controller.dart';

class MemberHomeScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  final List<Map<String, dynamic>> dummyWorkouts = [
    {
      'title': 'Yoga',
      'description': 'Start your day with a peaceful yoga session.',
      'imagePath': 'assets/one.png',
    },
    {
      'title': 'Cardio',
      'description': 'High-intensity cardio workout for maximum fat burn.',
      'imagePath': 'assets/two.png',
    },
    {
      'title': 'Strength',
      'description':
          'Build muscle and strength with this weightlifting session.',
      'imagePath': 'assets/three.jpeg',
    },
    {
      'title': 'Pilates ',
      'description':
          'Strengthen your core and improve flexibility with pilates.',
      'imagePath': 'assets/four.png',
    },
    {
      'title': 'HIIT',
      'description': 'Short but intense workout to boost metabolism.',
      'imagePath': 'assets/five.png',
    },
    {
      'title': 'Stretching ',
      'description':
          'Relax and improve flexibility with a soothing stretching session.',
      'imagePath': 'assets/five.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final bgColor =
        isDarkMode ? Colors.black : const Color.fromRGBO(220, 218, 218, 0.384);
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final shadowColor =
        isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.1);

    return Scaffold(
      backgroundColor: bgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, theme),
                _buildCarousel(theme, cardColor!, shadowColor),
                const SizedBox(height: 20),
                _buildCategoriesSection(theme, cardColor, shadowColor),
                const SizedBox(height: 20),
                _buildDailyExercisesSection(theme, cardColor, shadowColor),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final userName = userController.userData.value?.name ?? 'User';
            return Text(
              'Welcome, $userName',
              style: theme.textTheme.titleLarge,
            );
          }),
          const SizedBox(height: 8),
          Text(
            'What do you want to workout today?',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(ThemeData theme, Color cardColor, Color shadowColor) {
    return CarouselSlider.builder(
      itemCount: dummyWorkouts.length,
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
          child: _buildWorkoutItem(index, theme, cardColor, shadowColor),
        );
      },
    );
  }

  Widget _buildWorkoutItem(
      int index, ThemeData theme, Color cardColor, Color shadowColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getWorkoutTitle(index),
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  _getWorkoutDescription(index),
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme.primaryColor,
                  ),
                  child: InkWell(
                    onTap: () {
                      // Add your action here
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'START',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
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
          ),
          const SizedBox(width: 16), // Adjust spacing as needed
          Expanded(
            flex: 1, // Adjust flex values as needed
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                child: Image.asset(
                  dummyWorkouts[index]['imagePath'] ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildCategoriesSection(
      ThemeData theme, Color cardColor, Color shadowColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Categories',
                style: theme.textTheme.labelLarge,
              ),
              const Spacer(),
              Text(
                'See all',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCategories(theme, cardColor, shadowColor),
        ],
      ),
    );
  }

  Widget _buildCategories(ThemeData theme, Color cardColor, Color shadowColor) {
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

  Widget _buildDailyExercisesSection(
      ThemeData theme, Color cardColor, Color shadowColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Daily Exercises',
                style: theme.textTheme.labelLarge,
              ),
              const Spacer(),
              Text(
                'See all',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDailyExercises(theme, cardColor, shadowColor),
        ],
      ),
    );
  }

  Widget _buildDailyExercises(
      ThemeData theme, Color cardColor, Color shadowColor) {
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final shadowColor =
        isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.1);

    return Container(
      height: 84,
      width: 84,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
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
            child: Icon(icon, size: 32, color: theme.iconTheme.color),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final shadowColor =
        isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.1);

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, size: 32, color: theme.iconTheme.color),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    subTitle,
                    style: theme.textTheme.bodySmall,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later,
                        color: theme.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall,
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
