import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final int total;
  final String estimatedTime;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.total,
    required this.estimatedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.check, color: AppColors.white, size: 44),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pesanan Berhasil! 🎉',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pesananmu sedang diproses oleh restoran',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _infoRow('Nomor Pesanan', '#$orderId'),
                    const Divider(color: AppColors.white, height: 16),
                    _infoRow('Total Pembayaran', formatRupiah(total),
                        valueColor: AppColors.primaryGreen),
                    const Divider(color: AppColors.white, height: 16),
                    _infoRow('Estimasi Tiba', estimatedTime),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Lacak Pesanan',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: AppColors.primaryGreen, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
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

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.darkBrown,
          ),
        ),
      ],
    );
  }
}