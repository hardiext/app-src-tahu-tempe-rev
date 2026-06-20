import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/food.dart';
import '../../models/address.dart';
import 'address_list_screen.dart';
import 'order_confirmation_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final Food food;
  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  int _selectedSizeIndex = 0;
  final TextEditingController _noteController = TextEditingController();
  Address? _selectedAddress;
  bool _isFavorite = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _pickAddress() async {
  final address = await Navigator.push<Address>(
    context,
    MaterialPageRoute(
      builder: (_) => AddressListScreen(
        initialAddresses: Address.dummyList(),
      ),
    ),
  );
  if (address != null) setState(() => _selectedAddress = address);
}

  void _order() {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih alamat pengiriman dulu')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(
          food: widget.food,
          selectedSize: widget.food.sizes.isNotEmpty
              ? widget.food.sizes[_selectedSizeIndex]
              : const FoodSize(label: 'Regular', extraPrice: 0),
          quantity: _quantity,
          note: _noteController.text,
          address: _selectedAddress!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final selectedSize = food.sizes.isNotEmpty
        ? food.sizes[_selectedSizeIndex]
        : const FoodSize(label: 'Regular', extraPrice: 0);
    final totalPrice = (food.price + selectedSize.extraPrice) * _quantity;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.white,
                ),
                onPressed: () => setState(() => _isFavorite = !_isFavorite),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: food.imageUrl.isNotEmpty
                  ? Image.network(food.imageUrl, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.lightGray,
                      child: const Icon(Icons.fastfood,
                          size: 80, color: AppColors.brown),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(food.name,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkBrown,
                            )),
                      ),
                      Text(
                        formatRupiah(food.price),
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(food.restaurantName, style: AppTextStyles.body),
                  const SizedBox(height: 12),
                  Text(food.description, style: AppTextStyles.body),

                  if (food.sizes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('Ukuran', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: List.generate(food.sizes.length, (i) {
                        final selected = i == _selectedSizeIndex;
                        final size = food.sizes[i];
                        return ChoiceChip(
                          label: Text(size.extraPrice > 0
                              ? '${size.label} (+${formatRupiah(size.extraPrice)})'
                              : size.label),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _selectedSizeIndex = i),
                          selectedColor: AppColors.primaryGreen,
                          labelStyle: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12,
                            color: selected
                                ? AppColors.white
                                : AppColors.darkBrown,
                          ),
                        );
                      }),
                    ),
                  ],

                  const SizedBox(height: 20),
                  const Text('Jumlah', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.primaryGreen,
                      ),
                      Text('$_quantity',
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkBrown,
                          )),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.primaryGreen,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text('Alamat Pengiriman',
                      style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickAddress,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.lightGray),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: AppColors.primaryGreen),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedAddress?.fullAddress ??
                                  'Pilih alamat pengiriman',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 13,
                                color: _selectedAddress == null
                                    ? AppColors.brown
                                    : AppColors.darkBrown,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: AppColors.brown),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text('Catatan', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 2,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Contoh: tidak pedas, tanpa kecap...',
                      hintStyle: AppTextStyles.body,
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.lightGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.lightGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.primaryGreen),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border:
              Border(top: BorderSide(color: AppColors.lightGray, width: 0.5)),
        ),
        child: ElevatedButton(
          onPressed: _order,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'Pesan • ${formatRupiah(totalPrice)}',
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}