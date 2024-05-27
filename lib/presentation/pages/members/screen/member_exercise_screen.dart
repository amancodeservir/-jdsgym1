import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:rkfitness/core/config/app_colors.dart';
import 'package:rkfitness/core/config/app_styles.dart';

class MemberExerciseScreen extends StatelessWidget {
  int activeIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExerciseBanner(context),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'Trainers',
                        style: AppStyle.headingBlack,
                      ),
                      Spacer(),
                      Text(
                        'View More',
                        style: AppStyle.heading2,
                      )
                    ],
                  ),
                  _buildTrainerCards(context),
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
                        'New workouts',
                        style: AppStyle.headingBlack,
                      ),
                      Spacer(),
                      Text(
                        'View More',
                        style: AppStyle.heading2,
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildNewWorkoutSlider(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      height: 250,
      decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Stack(
        children: [
          const Positioned(
            top: 16,
            left: 16,
            child: Text('Weight loss\n Training', style: AppStyle.headingWhite),
          ),
          Positioned(
              right: 0,
              bottom: 0,
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/d0796413809bee72b13dcfa5be0511e2-removebg-preview%201.png?alt=media&token=c4e24483-5854-49bf-8130-ff8755439277',
                fit: BoxFit.cover,
                height: 180,
              ))
        ],
      ),
    );
  }

  Widget _buildTrainerCards(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Example number of trainers
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
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
    return Container(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider.builder(
              itemCount: 4, // Example number of workouts
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                aspectRatio: MediaQuery.of(context).size.width / 200,
                autoPlayInterval: const Duration(seconds: 5),
                enableInfiniteScroll: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  activeIndex=index;
                  // Handle page change
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return Container(
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      const Positioned(
                        top: 16,
                        left: 16,
                        child: Text('Weight loss\n Training',
                            style: AppStyle.headingWhite),
                      ),
                      Positioned(
                        top: 16,
                          right: 32,
                          bottom: 16,
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/rkfitness-78b0c.appspot.com/o/newworkout.png?alt=media&token=289d944b-4fb4-433b-acdb-49d2b7b2aa8c', 
                            fit: BoxFit.cover,
                            height: 180,
                          ))
                    ],
                  ),
                );
              },
            ),
          ),
          _buildIndicator(
            4,
          ), // Number of slides
        ],
      ),
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
            color: Colors.grey.withOpacity(index == 0 ? 1 : 0.4),
          ),
        );
      }),
    );
  }
}
