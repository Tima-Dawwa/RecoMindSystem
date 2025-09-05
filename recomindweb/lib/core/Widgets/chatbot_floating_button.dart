// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/state_manager.dart';
// import 'package:recomindweb/core/theme.dart';
// import 'package:recomindweb/features/Cart/view/cart_page.dart';
// import 'package:recomindweb/features/Favourites/view/favourites_page.dart';
// import 'package:recomindweb/features/Home/view/home_page.dart';

// class DraggableFloatingButton extends StatefulWidget {
//   final VoidCallback? onPressed;
//   final bool isChatOpen;

//   const DraggableFloatingButton({
//     super.key,
//     this.onPressed,
//     this.isChatOpen = false,
//   });

//   @override
//   State<DraggableFloatingButton> createState() =>
//       _DraggableFloatingButtonState();
// }

// class _DraggableFloatingButtonState extends State<DraggableFloatingButton> {
//   Offset position = const Offset(20, 100);
//   bool _isDragging = false;

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final buttonSize = 60.0;

//     return Positioned(
//       left: position.dx,
//       top: position.dy,
//       child: GestureDetector(
//         onPanStart: (_) => setState(() => _isDragging = true),
//         onPanEnd: (_) => setState(() => _isDragging = false),
//         onPanUpdate: (details) {
//           setState(() {
//             position = Offset(
//               (position.dx + details.delta.dx).clamp(
//                 0,
//                 screenSize.width - buttonSize,
//               ),
//               (position.dy + details.delta.dy).clamp(
//                 0,
//                 screenSize.height - buttonSize,
//               ),
//             );
//           });
//         },
//         onTap: () {
//           if (!_isDragging) {
//             showModalBottomSheet(
//               context: context,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               builder: (context) {
//                 return Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.home, size: 32),
//                         onPressed: () {
//                           Navigator.pop(context);
//                           Get.to(HomePage());
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.settings, size: 32),
//                         onPressed: () {
//                           Navigator.pop(context);
//                           Get.to(CartPage());
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.person, size: 32),
//                         onPressed: () {
//                           Navigator.pop(context);
//                           Get.to(FavouritesPage());
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },

//         child: Material(
//           color: Colors.transparent,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: widget.isChatOpen ? Themes.secondary : Themes.primary,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: (widget.isChatOpen ? Themes.secondary : Themes.primary)
//                       .withOpacity(0.4),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Tooltip(
//               message: 'Ask AI Assistant',
//               child: CircleAvatar(
//                 radius: 26,
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   Icons.smart_toy_rounded,
//                   size: 28,
//                   color: widget.isChatOpen ? Themes.secondary : Themes.primary,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:recomindweb/core/theme.dart';
// import 'package:recomindweb/features/Home/view/home_page.dart';

// class DraggableFloatingButton extends StatefulWidget {
//   final bool isChatOpen;

//   const DraggableFloatingButton({super.key, this.isChatOpen = false});

//   @override
//   State<DraggableFloatingButton> createState() =>
//       _DraggableFloatingButtonState();
// }

// class _DraggableFloatingButtonState extends State<DraggableFloatingButton> {
//   Offset position = const Offset(20, 100);
//   bool _isDragging = false;

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     const buttonSize = 60.0;

//     return Positioned(
//       left: position.dx,
//       top: position.dy,
//       child: GestureDetector(
//         onPanStart: (_) => setState(() => _isDragging = true),
//         onPanEnd: (_) => setState(() => _isDragging = false),
//         onPanUpdate: (details) {
//           setState(() {
//             position = Offset(
//               (position.dx + details.delta.dx).clamp(
//                 0,
//                 screenSize.width - buttonSize,
//               ),
//               (position.dy + details.delta.dy).clamp(
//                 0,
//                 screenSize.height - buttonSize,
//               ),
//             );
//           });
//         },
//         onTap: () {
//           if (!_isDragging) {
//             _showOptions(context);
//           }
//         },
//         child: Material(
//           color: Colors.transparent,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: widget.isChatOpen ? Themes.secondary : Themes.primary,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: (widget.isChatOpen ? Themes.secondary : Themes.primary)
//                       .withOpacity(0.4),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Tooltip(
//               message: 'Ask AI Assistant',
//               child: CircleAvatar(
//                 radius: 26,
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   Icons.smart_toy_rounded,
//                   size: 28,
//                   color: widget.isChatOpen ? Themes.secondary : Themes.primary,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildOption(
//                 icon: Icons.home,
//                 label: "Home",
//                 onTap: () {
//                   Navigator.pop(context);
//                   Get.to(HomePage());
//                 },
//               ),
//               _buildOption(
//                 icon: Icons.settings,
//                 label: "Settings",
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, '/settings');
//                 },
//               ),
//               _buildOption(
//                 icon: Icons.person,
//                 label: "Profile",
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, '/profile');
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildOption({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: Icon(icon, size: 32, color: Themes.primary),
//           onPressed: onTap,
//         ),
//         Text(label, style: TextStyle(color: Themes.text)),
//       ],
//     );
//   }
// }
//-----------------------------------
// import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';
// import 'package:recomindweb/core/theme.dart';
// import 'package:recomindweb/features/Cart/view/cart_page.dart';
// import 'package:recomindweb/features/ChatBot/chatbot.dart';
// import 'package:recomindweb/features/Favourites/view/favourites_page.dart';
// import 'package:recomindweb/features/Home/view/home_page.dart';
// import 'package:recomindweb/features/Orders/views/orders_page.dart';

// class DraggableFloatingButton extends StatefulWidget {
//   const DraggableFloatingButton({super.key});

//   @override
//   State<DraggableFloatingButton> createState() =>
//       _DraggableFloatingButtonState();
// }

// class _DraggableFloatingButtonState extends State<DraggableFloatingButton>
//     with SingleTickerProviderStateMixin {
//   Offset position = const Offset(20, 100);
//   bool _isDragging = false;
//   bool _isOpen = false;

//   late AnimationController _controller;
//   late Animation<double> _rotateAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 250),
//     );
//     _rotateAnimation = Tween<double>(
//       begin: 0,
//       end: 0.125,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggleMenu() {
//     setState(() {
//       _isOpen = !_isOpen;
//       if (_isOpen) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     const buttonSize = 60.0;

//     return Stack(
//       children: [
//         if (_isOpen) ...[
//           _buildOption(
//             icon: Icons.home,
//             label: "Home",
//             dx: -80,
//             dy: 0,
//             onTap: () {
//               _toggleMenu();
//               Get.to(HomePage());
//             },
//           ),
//           _buildOption(
//             icon: Icons.favorite,
//             label: "Favorite",
//             dx: 0,
//             dy: -80,
//             onTap: () {
//               _toggleMenu();
//               Get.to(FavouritesPage());
//             },
//           ),
//           _buildOption(
//             icon: Icons.shopping_cart_outlined,
//             label: "Cart",
//             dx: 80,
//             dy: 0,
//             onTap: () {
//               _toggleMenu();
//               Get.to(CartPage());
//             },
//           ),
//           _buildOption(
//             icon: Icons.shopping_bag_outlined,
//             label: "Orders",
//             dx: 80,
//             dy: 0,
//             onTap: () {
//               _toggleMenu();
//               Get.to(OrdersPage());
//             },
//           ),
//           _buildOption(
//             icon: Icons.smart_toy_rounded,
//             label: "Chat",
//             dx: 80,
//             dy: 0,
//             onTap: () {
//               _toggleMenu();
//               Get.to(ChatPage());
//             },
//           ),
//         ],

//         Positioned(
//           left: position.dx,
//           top: position.dy,
//           child: GestureDetector(
//             onPanStart: (_) => setState(() => _isDragging = true),
//             onPanEnd: (_) => setState(() => _isDragging = false),
//             onPanUpdate: (details) {
//               setState(() {
//                 position = Offset(
//                   (position.dx + details.delta.dx).clamp(
//                     0,
//                     screenSize.width - buttonSize,
//                   ),
//                   (position.dy + details.delta.dy).clamp(
//                     0,
//                     screenSize.height - buttonSize,
//                   ),
//                 );
//               });
//             },
//             onTap: () {
//               if (!_isDragging) _toggleMenu();
//             },
//             child: Material(
//               color: Colors.transparent,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: Themes.primary,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Themes.primary.withOpacity(0.4),
//                       blurRadius: 12,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 26,
//                   backgroundColor: Colors.white,
//                   child: RotationTransition(
//                     turns: _rotateAnimation,
//                     child: Icon(
//                       Icons.navigate_next_outlined,
//                       size: 28,
//                       color: Themes.primary,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildOption({
//     required IconData icon,
//     required String label,
//     required double dx,
//     required double dy,
//     required VoidCallback onTap,
//   }) {
//     return Positioned(
//       left: position.dx + dx,
//       top: position.dy + dy,
//       child: Column(
//         children: [
//           FloatingActionButton(
//             mini: true,
//             backgroundColor: Colors.white,
//             onPressed: onTap,
//             child: Icon(icon, color: Themes.primary),
//           ),
//           const SizedBox(height: 4),
//           Text(label, style: TextStyle(color: Themes.text, fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recomindweb/core/theme.dart';
import 'package:recomindweb/features/Cart/view/cart_page.dart';
import 'package:recomindweb/features/ChatBot/chatbot.dart';
import 'package:recomindweb/features/Favourites/view/favourites_page.dart';
import 'package:recomindweb/features/Home/view/home_page.dart';
import 'package:recomindweb/features/Orders/views/orders_page.dart';

class DraggableFloatingButton extends StatefulWidget {
  const DraggableFloatingButton({super.key});

  @override
  State<DraggableFloatingButton> createState() =>
      _DraggableFloatingButtonState();
}

class _DraggableFloatingButtonState extends State<DraggableFloatingButton>
    with SingleTickerProviderStateMixin {
  Offset position = const Offset(20, 100);
  bool _isDragging = false;
  bool _isOpen = false;

  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 0.125,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const buttonSize = 60.0;

    final bool isOnRight = position.dx > screenSize.width / 2;

    return Stack(
      children: [
        if (_isOpen) ...[
          _buildOption(
            icon: Icons.home,
            label: "Home",
            dx: isOnRight ? -80 : 80,
            dy: 0,
            onTap: () {
              _toggleMenu();
              Get.to(HomePage());
            },
          ),
          _buildOption(
            icon: Icons.favorite,
            label: "Favorite",
            dx: 0,
            dy: -80,
            onTap: () {
              _toggleMenu();
              Get.to(FavouritesPage());
            },
          ),
          _buildOption(
            icon: Icons.shopping_cart_outlined,
            label: "Cart",
            dx: isOnRight ? -80 : 80,
            dy: -80,
            onTap: () {
              _toggleMenu();
              Get.to(CartPage());
            },
          ),
          _buildOption(
            icon: Icons.shopping_bag_outlined,
            label: "Orders",
            dx: isOnRight ? -80 : 80,
            dy: 80,
            onTap: () {
              _toggleMenu();
              Get.to(OrdersPage());
            },
          ),
          _buildOption(
            icon: Icons.smart_toy_rounded,
            label: "Chat",
            dx: 0,
            dy: 80,
            onTap: () {
              _toggleMenu();
              Get.to(ChatPage());
            },
          ),
        ],

        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanStart: (_) => setState(() => _isDragging = true),
            onPanEnd: (_) => setState(() => _isDragging = false),
            onPanUpdate: (details) {
              setState(() {
                position = Offset(
                  (position.dx + details.delta.dx).clamp(
                    0,
                    screenSize.width - buttonSize,
                  ),
                  (position.dy + details.delta.dy).clamp(
                    0,
                    screenSize.height - buttonSize,
                  ),
                );
              });
            },
            onTap: () {
              if (!_isDragging) _toggleMenu();
            },
            child: Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Themes.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Themes.primary.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: RotationTransition(
                    turns: _rotateAnimation,
                    child: Icon(
                      Icons.navigate_next_outlined,
                      size: 28,
                      color: Themes.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required double dx,
    required double dy,
    required VoidCallback onTap,
  }) {
    return Positioned(
      left: position.dx + dx,
      top: position.dy + dy,
      child: Column(
        children: [
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            onPressed: onTap,
            child: Icon(icon, color: Themes.primary),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Themes.text, fontSize: 12)),
        ],
      ),
    );
  }
}
