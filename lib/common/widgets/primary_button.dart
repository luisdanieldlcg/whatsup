import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool loading;
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimary;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: loading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              title,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
    );
  }
}
