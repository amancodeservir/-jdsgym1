import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StaffHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to STAFF',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'What do you workout Today?',
                    style: AppStyle.body,
                  ),
                ],
              ),
            ),
            _buildWorkoutList(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
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
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildCategories(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
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
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDailyExercises(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutList() {
    return CarouselSlider.builder(
      itemCount: 3,
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0, // Set to 1.0 to show one item at a time
        aspectRatio: 16 / 9, // Adjust aspect ratio as needed
        autoPlayInterval: const Duration(seconds: 9),
        enableInfiniteScroll: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: WorkoutItem(
            title: _getWorkoutTitle(index),
            description: _getWorkoutDescription(index),
            imageUrl: _getWorkoutImageUrl(index),
          ),
        );
      },
    );
  }

  Widget _buildCategories() {
    return Container(
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

  Widget _buildDailyExercises(BuildContext context) {
    return Container(
      height: MediaQuery.of(context)
          .size
          .height, // Set height to full screen height
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: const [
          ExerciseItem(
            title: 'Push Ups',
            subTitle: '20 Times',
            description: '6 Minutes',
            icon: Icons.fitness_center,
          ),
          SizedBox(height: 8), // Use height instead of width for spacingr
          ExerciseItem(
            title: 'Running',
            subTitle: '4 Km',
            description: '10 Minutes',
            icon: Icons.spa,
          ),
          SizedBox(height: 8),
          ExerciseItem(
            title: 'Natrajasana Yoga Pose',
            subTitle: '2-6 Times',
            description: '15 Minutes',
            icon: Icons.directions_run,
          ),
          SizedBox(height: 8),
          ExerciseItem(
            title: 'Stretching',
            subTitle: '20 Times',
            description: '6 Minutes',
            icon: Icons.accessibility_new,
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

  String _getWorkoutImageUrl(int index) {
    List<String> imageUrls = [
      'assets/onboarding1.png',
      'assets/onboarding2.png',
      'assets/onboarding3.png',
    ];
    return imageUrls[index % imageUrls.length];
  }
}

class WorkoutItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const WorkoutItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.5), // Light red color
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 8, bottom: 8),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: AppColors.primaryColor,
                        ),
                        child: InkWell(
                          onTap: () {
                            // Add your action here
                          },
                          child: const Row(
                            children: [
                              Text(
                                'ATART',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
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
                ),
                const Spacer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
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
      child: Icon(icon),
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
            child: Icon(icon),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
