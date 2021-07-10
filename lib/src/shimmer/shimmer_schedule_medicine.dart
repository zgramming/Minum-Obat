import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class ShimmerScheduleMedicine extends StatelessWidget {
  const ShimmerScheduleMedicine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: kToolbarHeight,
            color: colorPallete.monochromaticColor,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.all(12.0),
                color: colorPallete.monochromaticColor,
                width: double.infinity,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
