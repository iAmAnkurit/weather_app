import 'package:flutter/material.dart';

class weatherItem extends StatelessWidget {
  const weatherItem({
    super.key,
    required this.value,
    required this.text,
    required this.unit,
    required this.imageUrl,

  });

  final int value;
  final String text;
  final String unit;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            // height: 60,
            // width: 60,
            decoration: const BoxDecoration(
              color: Color(0xffE0E8FB),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Image.asset(imageUrl,width: 50,height: 50,),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "$value $unit",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}