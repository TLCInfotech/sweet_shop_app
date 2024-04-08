import 'package:flutter/material.dart';

class CommonListSkeleton extends StatefulWidget {
  const CommonListSkeleton({super.key});

  @override
  State<CommonListSkeleton> createState() => _CommonListSkeletonState();
}

class _CommonListSkeletonState extends State<CommonListSkeleton> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
