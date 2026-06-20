import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/food.dart';
import '../../models/address.dart';
import '../../models/order_draft.dart';
import 'order_success_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final Food food;
  final FoodSize selectedSize;
  final int quantity;
  final String note;
  final Address address;

  const OrderConfirmationScreen({
    super.key,
    required this.food,
    required this.selectedSize,
    required this.quantity,
    required this.note,
    required this.address,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  String _paymentMethod = 'COD';

  late final OrderDraft _draft = OrderDraft(
    food: widget.food,
    selectedSize: widget.selectedSize,
    quantity: widget.quantity,
    note: widget.note,
    address: widget.address,
    paymentMethod: _paymentMethod,
  );

  void _createOrder() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(
          orderId: _draft.orderId,
          total: _draft.total,
          estimatedTime: widget.food.estimatedTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                children: [
                  _buildOrderSummaryCard(),
                  const SizedBox(height: 16),
                  _sectionTitle('Alamat Pengiriman'),
                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: widget.address.label,
                    subtitle: widget.address.fullAddress,
                    trailing: 'Ganti',
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Estimasi Pengiriman'),
                  _buildInfoCard(
                    icon: Icons.access_time,
                    title: widget.food.estimatedTime,
                    subtitle: 'Diantar ke lokasi kamu',
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Metode Pembayaran'),
                  _buildPaymentSelector(),
                  const SizedBox(height: 16),
                  _sectionTitle('Rincian Harga'),
                  _buildPriceDetailCard(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.darkBrown),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Konfirmasi Pesanan',
              textAlign: TextAlign.center,
              style: AppTextStyles.title,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTextStyles.sectionTitle),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_pizza, color: AppColors.brown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.food.name,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBrown,
                  ),
                ),
                Text(
                  '${widget.food.restaurantName} · ${widget.selectedSize.label} · x${widget.quantity}',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 4),
                Text(formatRupiah(_draft.subtotal),
                    style: AppTextStyles.priceGreen.copyWith(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBrown,
                  ),
                ),
                Text(subtitle, style: AppTextStyles.body),
              ],
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryGreen,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentSelector() {
    return Row(
      children: [
        Expanded(child: _paymentOption('QRIS', Icons.qr_code)),
        const SizedBox(width: 12),
        Expanded(child: _paymentOption('COD', Icons.payments)),
      ],
    );
  }

  Widget _paymentOption(String method, IconData icon) {
    final isSelected = _paymentMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = method),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withOpacity(0.1)
              : AppColors.lightGray,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected ? AppColors.primaryGreen : AppColors.brown),
            const SizedBox(height: 4),
            Text(
              method,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryGreen : AppColors.darkBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGray, width: 0.5),
      ),
      child: Column(
        children: [
          _priceRow('Subtotal', formatRupiah(_draft.subtotal)),
          _priceRow('Ongkir', formatRupiah(_draft.deliveryFee)),
          if (_draft.discount > 0)
            _priceRow('Diskon', '- ${formatRupiah(_draft.discount)}',
                color: AppColors.red),
          const Divider(color: AppColors.lightGray, height: 16),
          _priceRow('Total', formatRupiah(_draft.total), bold: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: bold ? 15 : 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              color: AppColors.darkBrown,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: bold ? 15 : 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: color ?? AppColors.darkBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border:
            Border(top: BorderSide(color: AppColors.lightGray, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total', style: AppTextStyles.body),
              Text(
                formatRupiah(_draft.total),
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBrown,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _createOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: AppColors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Buat Pesanan',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}