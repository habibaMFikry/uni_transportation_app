import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButtons extends StatelessWidget {
  final String textButton1;
  final String textButton2;
  final void Function()? onPressedButton1;
  final void Function()? onPressedButton2;

  const CustomButtons({
    super.key,
    required this.textButton1,
    required this.textButton2,
    this.onPressedButton1,
    this.onPressedButton2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
            ),
            onPressed: onPressedButton1,
            child: Text(
              textButton1,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            children: [
              const Expanded(
                child: Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: const Text(
                  'OR',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const Expanded(
                child: Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onPressedButton2,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side:  BorderSide(color: Colors.grey[900]!),
            ),
            child: Text(
              textButton2,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
