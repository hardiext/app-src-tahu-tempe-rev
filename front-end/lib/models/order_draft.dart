import 'food.dart';
import 'address.dart';

class OrderDraft {
  final Food food;
  final FoodSize selectedSize;
  final int quantity;
  final String note;
  final Address address;
  final String paymentMethod;

  const OrderDraft({
    required this.food,
    required this.selectedSize,
    required this.quantity,
    required this.note,
    required this.address,
    this.paymentMethod = 'COD',
  });

  int get subtotal => (food.price + selectedSize.extraPrice) * quantity;
  int get deliveryFee => food.deliveryFee;
  int get discount =>
      food.originalPrice != null
          ? (food.originalPrice! - food.price) * quantity
          : 0;
  int get total => subtotal + deliveryFee;

  String get orderId =>
      'FRQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

  OrderDraft copyWith({
    Food? food,
    FoodSize? selectedSize,
    int? quantity,
    String? note,
    Address? address,
    String? paymentMethod,
  }) {
    return OrderDraft(
      food: food ?? this.food,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}