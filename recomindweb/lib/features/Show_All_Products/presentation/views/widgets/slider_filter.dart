// import 'package:flutter/material.dart';
// import 'package:recomindweb/core/theme.dart';

// // ignore: must_be_immutable
// class SliderFilter extends StatefulWidget {
//   SliderFilter({super.key, required this.price});

//   late double price;

//   @override
//   State<SliderFilter> createState() => _SliderFilterState();
// }

// class _SliderFilterState extends State<SliderFilter> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SliderTheme(
//           data: SliderTheme.of(context).copyWith(
//             valueIndicatorTextStyle: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//             ),
//             valueIndicatorColor: Themes.primary,
//             showValueIndicator: ShowValueIndicator.always,
//           ),
//           child: Slider(
//             value: widget.price,
//             min: 0,
//             max: 1000,
//             divisions: 100,
//             label: "\$${widget.price.round()}",
//             onChanged: (value) {
//               setState(() {
//                 widget.price = value;
//               });
//             },
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text("\$0", style: TextStyle(color: Colors.grey[600])),
//             Text(
//               "\$${widget.price.round()}",
//               style: TextStyle(
//                 color: Themes.primary,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text("\$1000", style: TextStyle(color: Colors.grey[600])),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:recomindweb/core/theme.dart';

// ignore: must_be_immutable
class SliderFilter extends StatefulWidget {
  SliderFilter({super.key, required this.rangeValues});

  late RangeValues rangeValues;

  @override
  State<SliderFilter> createState() => _SliderFilterState();
}

class _SliderFilterState extends State<SliderFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            valueIndicatorColor: Themes.primary,
            showValueIndicator: ShowValueIndicator.always,
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 8,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: RangeSlider(
            values: widget.rangeValues,
            min: 0,
            max: 100000,
            divisions: 100,
            labels: RangeLabels(
              "\$${widget.rangeValues.start.round()}",
              "\$${widget.rangeValues.end.round()}",
            ),
            onChanged: (RangeValues values) {
              setState(() {
                widget.rangeValues = values;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("\$0", style: TextStyle(color: Colors.grey[600])),

            Text("\$100000", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Padding(padding: const EdgeInsets.only(right: 16)),
        Text(
          "\$${widget.rangeValues.start.round()} - \$${widget.rangeValues.end.round()}",
          style: TextStyle(color: Themes.primary, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
