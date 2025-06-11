import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/Widgets/custom_snack_bar.dart';
import 'package:recomindweb/core/Widgets/primary_button.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';
import 'package:recomindweb/features/product_details/view%20model/product%20details%20cubit/product_details_cubit.dart';
import 'package:recomindweb/features/product_details/view%20model/product%20details%20cubit/product_details_state.dart';

class AddReviewSection extends StatefulWidget {
  final Product product;
  const AddReviewSection({super.key, required this.product});

  @override
  State<AddReviewSection> createState() => _AddReviewSectionState();
}

class _AddReviewSectionState extends State<AddReviewSection> {
  int _selectedStars = 0;
  final TextEditingController _controller = TextEditingController();
  bool _submitted = false;

  void _submitReview() {
    if (_selectedStars == 0 && _controller.text.trim().isEmpty) {
      CustomSnackbar.show(
        context,
        'Please select a star rating and write a review.',
        icon: Icons.warning_amber_rounded,
        backgroundColor: Themes.secondary.withAlpha(200),
      );
      return;
    }

    setState(() {
      _submitted = true;
    });

    final cubit = context.read<ProductDetailsCubit>();
    cubit.addReview(
      productId: widget.product.id,
      rating: _selectedStars,
      commit: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailsCubit, ProductDetailsState>(
      listener: (context, state) {
        if (state is SuccessProductDetails) {
             ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Snackbar test worked")));
          _selectedStars = 0;
          _controller.clear();
          setState(() {
            _submitted = false;
          });

          CustomSnackbar.show(
            context,
            'Thank you for your review!',
            icon: Icons.check_circle,
            backgroundColor: Themes.primary.withAlpha(200),
          );
        } else if (state is FailureProductDetails) {
          setState(() {
            _submitted = false;
          });

          CustomSnackbar.show(
            context,
            state.failure.errMessage,
            icon: Icons.error,
            backgroundColor: Colors.redAccent,
          );
        }
      },
      child: Card(
        elevation: 3,
        color: Themes.bg,
        shadowColor: Themes.text,
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
                  color: Themes.text,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color:
                          index < _selectedStars
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
                  labelStyle: TextStyle(color: Themes.text.withAlpha(100)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Themes.text),
                    borderRadius: BorderRadius.circular(8),
                  ),
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
      ),
    );
  }
} 