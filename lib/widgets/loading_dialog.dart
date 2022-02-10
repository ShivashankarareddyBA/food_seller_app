import 'package:flutter/material.dart';
import 'package:food_seller_app/widgets/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({required this.message}); // loading constructor

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        key: key,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            circularProgress(),
            const SizedBox(height: 10),
            Text(message + "Please Wait.."),
          ],
        ));
  }
}
