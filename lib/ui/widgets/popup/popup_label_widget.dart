import 'package:flutter/material.dart';
import 'package:flutter_base/ui/widgets/popup/label.dart';

class PopupLabelWidget extends StatelessWidget {
  const PopupLabelWidget({super.key, required this.label});
  final PopupMessageLabel label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 22,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: label.borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: label.textColor),
          ),
          const SizedBox(
            width: 4,
          ),
          Flexible(
            child: Text(
              label.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Montserrat',
                package: 'flutter_base',
                fontWeight: FontWeight.w500,
                height: 1,
                fontSize: 14,
                color: label.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
