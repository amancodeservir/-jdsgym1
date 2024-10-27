import 'package:flutter/material.dart';
import 'package:rkfitness/core/config/app_styles.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms and Conditions',
          style: AppStyle.whiteText18,
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Membership',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              '• Membership is personal and non-transferable.\n'
              '• Fees must be paid on time. Late payments may result in suspension.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16.0),
            Text(
              'Facility Use',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              '• Follow gym policies and hours. Proper attire is required.\n'
              '• JDS Gym is not responsible for lost or stolen items.',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(height: 16.0),
            Text(
              'Health & Safety',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              '• Use the facilities at your own risk. Consult a doctor before starting a new exercise program.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16.0),
            Text(
              'Conduct',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(height: 8.0),
            Text(
              '• Respect other members and staff. Misconduct may result in termination.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16.0),
            Text(
              'Liability',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8.0),
            Text(
              '• JDS Gym is not liable for injuries or damages occurring on the premises.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
