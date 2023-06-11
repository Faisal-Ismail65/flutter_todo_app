import 'package:flutter/material.dart';
import 'package:flutter_todo/ui/theme.dart';
import 'package:get/get.dart';

class BottomSheetButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  final Color clr;
  final bool isClose;
  const BottomSheetButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.clr,
    this.isClose = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isClose ? Colors.transparent : clr,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
        ),
        child: Text(
          label,
          style: isClose
              ? titleStyle
              : titleStyle.copyWith(
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
