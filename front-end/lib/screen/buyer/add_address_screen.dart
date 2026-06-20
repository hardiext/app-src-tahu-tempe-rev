import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/address.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _alamatController = TextEditingController();
  final _jalanController = TextEditingController();
  final _kodePosController = TextEditingController();
  final _apartemenController = TextEditingController();
  String _selectedLabel = 'RUMAH';

  @override
  void dispose() {
    _alamatController.dispose();
    _jalanController.dispose();
    _kodePosController.dispose();
    _apartemenController.dispose();
    super.dispose();
  }

  void _saveLocation() {
    if (_alamatController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat tidak boleh kosong')),
      );
      return;
    }

    final newAddress = Address(
      id: 'a${DateTime.now().millisecondsSinceEpoch}',
      label: _selectedLabel,
      street: _jalanController.text.trim().isNotEmpty
          ? _jalanController.text.trim()
          : _alamatController.text.trim(),
      city: _alamatController.text.trim(),
      postalCode: _kodePosController.text.trim(),
      apartment: _apartemenController.text.trim().isEmpty
          ? null
          : _apartemenController.text.trim(),
    );

    Navigator.pop(context, newAddress);
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMapPlaceholder(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Alamat'),
                          _textField(
                            controller: _alamatController,
                            hint: 'Jl. Jendral Soedirman',
                            icon: Icons.location_on,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label('Jalan'),
                                    _textField(controller: _jalanController),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label('Kode Pos'),
                                    _textField(controller: _kodePosController),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _label('Apartemen'),
                          _textField(
                            controller: _apartemenController,
                            hint: 'Contoh: Tower A, Lantai 5, No. 12',
                          ),
                          const SizedBox(height: 20),
                          const Text('Beri Label Sebagai', style: AppTextStyles.sectionTitle),
                          const SizedBox(height: 10),
                          Row(
                            children: ['RUMAH', 'KANTOR', 'LAINNYA']
                                .map(_buildLabelPill)
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildSaveButton(),
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
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Alamat Baru',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: AppColors.lightGray,
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.location_pin, size: 48, color: AppColors.red),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.my_location, color: AppColors.primaryGreen, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkBrown,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    String hint = '',
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontFamily: AppTextStyles.fontFamily, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body,
        prefixIcon: icon != null
            ? Icon(icon, size: 18, color: AppColors.primaryGreen)
            : null,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
      ),
    );
  }

  Widget _buildLabelPill(String label) {
    final isSelected = label == _selectedLabel;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedLabel = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreen : AppColors.lightGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.white : AppColors.darkBrown,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _saveLocation,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Simpan Lokasi',
            style: TextStyle(
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