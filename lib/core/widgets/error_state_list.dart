import 'package:flutter/material.dart';

class ErrorStateList extends StatelessWidget {
  final String imageAssetname;
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorStateList(
      {super.key,
      required this.imageAssetname,
      required this.errorMessage, required this.onRetry,
      });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageAssetname,
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text('Something went wrong...'),
            const SizedBox(
              height: 15,
            ),
            Text(errorMessage, textAlign: TextAlign.center,),
            const SizedBox(
              height: 15,
            ),
            OutlinedButton(onPressed: onRetry, child: const Text('Try Again'),),
            const Text('or'),
            const Text('Contact Support'),
          ],
        ),
      ),
    );
  }
}
