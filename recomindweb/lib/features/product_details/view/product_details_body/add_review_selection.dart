import 'package:flutter/material.dart';
import 'package:recomindweb/core/Widgets/custom_snack_bar.dart';
import 'package:recomindweb/core/Widgets/primary_button.dart';

class AddReviewSection extends StatefulWidget {
  const AddReviewSection({super.key});

  @override
  State<AddReviewSection> createState() => _AddReviewSectionState();
}

class _AddReviewSectionState extends State<AddReviewSection> {
  int _selectedStars = 0;
  final TextEditingController _controller = TextEditingController();
  bool _submitted = false;

  void _submitReview() {
    if (_selectedStars == 0 || _controller.text.trim().isEmpty) {
      CustomSnackbar.show(
        context,
        'Please select a star rating and write a review.',
        icon: Icons.warning_amber_rounded,
        backgroundColor: Colors.redAccent,
      );
      return;
    }

    setState(() {
      _submitted = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _selectedStars = 0;
        _controller.clear();
        _submitted = false;
      });
      CustomSnackbar.show(
        context,
        'Thank you for your review!',
        icon: Icons.check_circle,
        backgroundColor: Colors.green,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Review",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _selectedStars
                        ? Colors.amber
                        : Colors.grey[300],
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedStars = index + 1;
                    });
                  },
                  tooltip: "${index + 1} Star${index == 0 ? '' : 's'}",
                );
              }),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 4,
              minLines: 2,
              decoration: InputDecoration(
                labelText: "Write your review",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              enabled: !_submitted,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: CustomPrimaryButton(
                label: "Submit Review",
                icon: Icons.send,
                loading: _submitted,
                onPressed: _submitReview,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
