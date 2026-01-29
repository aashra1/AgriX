import 'package:flutter/material.dart';

class OffersList extends StatelessWidget {
  const OffersList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return SizedBox(
      height: h * 0.22,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: w * 0.05),
        children: [
          _buildOfferCard(
            context,
            'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
          ),
          _buildOfferCard(
            context,
            'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
          ),
          _buildOfferCard(
            context,
            'https://images.unsplash.com/photo-1592982537447-6f2a6a0c7c18?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, String imageUrl) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      width: w * 0.65,
      margin: EdgeInsets.only(right: w * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
