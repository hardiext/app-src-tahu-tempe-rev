class FoodSize {
  final String label;
  final int extraPrice;

  const FoodSize({required this.label, required this.extraPrice});
}

class Food {
  final String id;
  final String name;
  final String restaurantName;
  final String restaurantAddress;
  final String imageUrl;
  final int price;
  final int? originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewCount;
  final String estimatedTime;
  final int deliveryFee;
  final String description;
  final List<FoodSize> sizes;

  const Food({
    required this.id,
    required this.name,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.discountPercent = 0,
    required this.rating,
    required this.reviewCount,
    required this.estimatedTime,
    required this.deliveryFee,
    required this.description,
    this.sizes = const [],
  });

  static Food dummy() {
    return const Food(
      id: 'f001',
      name: 'Golden Crust Cheese Pizza',
      restaurantName: 'Pizza House',
      restaurantAddress: 'Jl. Slamet Riyadi No. 12',
      imageUrl: '',
      price: 78400,
      originalPrice: 98000,
      discountPercent: 20,
      rating: 4.8,
      reviewCount: 320,
      estimatedTime: '25–35 menit',
      deliveryFee: 5000,
      description:
          'Nikmati perpaduan sempurna dari 5 jenis keju premium di atas adonan tipis renyah. Dibuat dengan saus tomat Italia rahasia dan taburan daun basil segar.',
      sizes: [
        FoodSize(label: 'Personal', extraPrice: 0),
        FoodSize(label: 'Regular', extraPrice: 15000),
        FoodSize(label: 'Large', extraPrice: 30000),
      ],
    );
  }
}