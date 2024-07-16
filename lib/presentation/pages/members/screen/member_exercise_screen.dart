import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';
import 'package:rkfitness/presentation/pages/trainers_screen.dart';
import 'package:rkfitness/presentation/pages/workout_screen.dart';

class MemberExerciseScreen extends StatefulWidget {
  @override
  _MemberExerciseScreenState createState() => _MemberExerciseScreenState();
}

class _MemberExerciseScreenState extends State<MemberExerciseScreen> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final bgColor =
        isDarkMode ? Colors.black : const Color.fromRGBO(220, 218, 218, 0.384);
    final primaryColor =
        isDarkMode ? AppColors.darkGrey : AppColors.primaryColor;
    final shadowColor =
        isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.1);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExerciseBanner(context, primaryColor),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  _buildSectionHeader('Trainers', context, textColor),
                  _buildTrainerCards(context),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  _buildSectionHeader('New workouts', context, textColor),
                  const SizedBox(height: 8),
                  _buildNewWorkoutSlider(context, primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, BuildContext context, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyle.heading2Black.copyWith(color: textColor),
        ),
        TextButton(
          onPressed: () {
            _navigateToScreen(title);
          },
          child: Text(
            'View More',
            style: AppStyle.body.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }

  void _navigateToScreen(String title) {
    if (title == 'Trainers') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TrainersScreen()),
      );
    } else if (title == 'New workouts') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkoutsScreen()),
      );
    }
  }

  Widget _buildExerciseBanner(BuildContext context, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      height: 230,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 16,
            left: 16,
            child: Text(
              'Weight loss\n Training',
              style: AppStyle.headingWhite,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/imp%2Fweight.png?alt=media&token=33fad8e0-84d1-4c78-a510-beb81b7e780e',
              fit: BoxFit.cover,
              height: 180,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCards(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/imp%2Ftrainer.webp?alt=media&token=f37808e7-5dc5-426a-8e17-e8b7101a0afb',
                fit: BoxFit.fill,
                height: 54,
                width: 54,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewWorkoutSlider(BuildContext context, Color primaryColor) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: 4,
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            aspectRatio: MediaQuery.of(context).size.width / 200,
            autoPlayInterval: const Duration(seconds: 5),
            enableInfiniteScroll: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(0, 0.5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Positioned(
                    top: 16,
                    left: 16,
                    child: Text(
                      'Weight loss\n Training',
                      style: AppStyle.headingWhite,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    bottom: 16,
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/imp%2Fwo-removebg-preview.png?alt=media&token=0a0b3bf0-43d8-46f8-b49c-ab29996c1ac8',
                      fit: BoxFit.cover,
                      height: 180,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildIndicator(4),
      ],
    );
  }

  Widget _buildIndicator(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withOpacity(index == activeIndex ? 1 : 0.4),
          ),
        );
      }),
    );
  }
}
