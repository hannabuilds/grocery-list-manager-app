import 'package:flutter/material.dart';

class EmptyStateList extends StatelessWidget {
  final String imageAssetname;
  final String title;
  final String description;

  const EmptyStateList({super.key, required this.imageAssetname, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageAssetname,
          height: 100,
          width: 100,),
          const SizedBox(height: 16,),
          Text(title),
          const SizedBox(height: 15,),
          Text(description),
        ],
      ),
    );
  }
}
