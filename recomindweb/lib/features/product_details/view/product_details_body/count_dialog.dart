import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/features/product_details/models/product_model.dart';
import 'package:recomindweb/features/product_details/view%20model/product%20details%20cubit/product_details_cubit.dart';

class ShowDialog extends StatefulWidget {
  final Product product;

  const ShowDialog({super.key, required this.product});

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  final TextEditingController controller = TextEditingController(text: '1');
  String? errorText;

  int get _enteredCount {
    final value = int.tryParse(controller.text);
    return value ?? 1;
  }

  void _submit() {
    final count = _enteredCount;

    if (count < 1 || count > widget.product.quantity) {
      setState(() {
        errorText = "Enter a number between 1 and ${widget.product.quantity}";
      });
      return;
    }

    final cubit = context.read<ProductDetailsCubit>();
    cubit.addToCart(productId: widget.product.id, count: count);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final String leftValue =
        widget.product.willFinish
            ? "${widget.product.quantity - _enteredCount} left"
            : "";

    return AlertDialog(
      title: const Text("Select Quantity"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leftValue.isNotEmpty)
            Text(leftValue, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Quantity",
              errorText: errorText,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (_) {
              setState(() {
                errorText = null;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(onPressed: _submit, child: const Text("Add")),
      ],
    );
  }
}
