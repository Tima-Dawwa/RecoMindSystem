import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recomindweb/core/helpers/constant.dart';
import 'package:recomindweb/core/utils.dart';
import 'package:recomindweb/features/ChatBot/Model/product.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatbot_cubit.dart';
import 'package:recomindweb/features/ChatBot/view%20model/chatbot_status.dart';

class ProductImage extends StatefulWidget {
  final ProductModel product;

  const ProductImage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  late bool isFavorite;
  bool isProcessingFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.isFavorite;
  }

  void _toggleFavorite() {
    if (isProcessingFavorite) return;

    final cubit = context.read<ChatBotCubit>();

    setState(() {
      isProcessingFavorite = true;
    });

    if (isFavorite) {
      cubit.removeFromFavorites(widget.product.id);
    } else {
      cubit.addToFavorites(widget.product.id);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return BlocListener<ChatBotCubit, ChatBotStatus>(
      listener: (context, state) {
        if (state is FavoritesUpdatedSuccessfully &&
            state.productId == widget.product.id) {
          setState(() {
            isProcessingFavorite = false;
            isFavorite = state.isFavorite;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isFavorite
                    ? 'Added to favorites!'
                    : 'Removed from favorites!',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is FailureChatBot && isProcessingFavorite) {
          setState(() {
            isProcessingFavorite = false;
            isFavorite = !isFavorite;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to update favorites: ${state.failure.errMessage}',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            children: [
              Image.network(
                ngrok + product.imageUrl,
                headers: {"ngrok-skip-browser-warning": "true"},
                fit: BoxFit.fill,
                width: double.infinity,
                errorBuilder:
                    (_, __, ___) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(child: Icon(Icons.image, size: 40)),
                    ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getTagColor(product.tagType),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    product.tagType.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: isProcessingFavorite ? null : _toggleFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child:
                        isProcessingFavorite
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.red,
                                ),
                              ),
                            )
                            : Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 20,
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
