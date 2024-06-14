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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExerciseBanner(context),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  _buildSectionHeader('Trainers', context),
                  _buildTrainerCards(context),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  _buildSectionHeader('New workouts', context),
                  const SizedBox(height: 8),
                  _buildNewWorkoutSlider(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyle.headingBlack,
        ),
        TextButton(
          onPressed: () {
            _navigateToTrainersScreen(title);
          },
          child: Text(
            'View More',
            style: AppStyle.heading2.copyWith(color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }

  void _navigateToTrainersScreen(String title) {
    if (title == "Trainers") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TrainersScreen()),
      );
    } else if (title == "New workouts") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkoutsScreen()),
      );
    }
  }

  Widget _buildExerciseBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      height: 230,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
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
              'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/d0796413809bee72b13dcfa5be0511e2-removebg-preview%201.png?alt=media&token=c4e24483-5854-49bf-8130-ff8755439277',
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
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/trained%20.png?alt=media&token=f56ca4aa-f71b-438e-86de-66dff93cc903',
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

  Widget _buildNewWorkoutSlider(BuildContext context) {
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
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: Offset(0, 2),
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
                      'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/newworkout.png?alt=media&token=289d944b-4fb4-433b-acdb-49d2b7b2aa8c',
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
