import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/address.dart';
import 'add_address_screen.dart';

class AddressListScreen extends StatefulWidget {
  final List<Address> initialAddresses;

  const AddressListScreen({super.key, required this.initialAddresses});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late List<Address> _addresses;

  @override
  void initState() {
    super.initState();
    _addresses = List.of(widget.initialAddresses);
  }

  void _selectAddress(Address address) {
    Navigator.pop(context, address);
  }

  void _deleteAddress(Address address) {
    setState(() => _addresses.removeWhere((a) => a.id == address.id));
  }

  Future<void> _addNewAddress() async {
    final newAddress = await Navigator.push<Address>(
      context,
      MaterialPageRoute(builder: (_) => const AddAddressScreen()),
    );
    if (newAddress != null) {
      setState(() => _addresses.add(newAddress));
    }
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
                  ..._addresses.map(_buildAddressCard),
                  const SizedBox(height: 8),
                  _buildMapPlaceholder(),
                  const SizedBox(height: 16),
                  _buildAddButton(),
                ],
              ),
            ),
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
              'Alamat Saya',
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

  Widget _buildAddressCard(Address address) {
    final icon = address.label == 'RUMAH'
        ? Icons.home
        : address.label == 'KANTOR'
            ? Icons.business
            : Icons.location_on;

    return GestureDetector(
      onTap: () => _selectAddress(address),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: address.isSelected ? AppColors.primaryGreen : AppColors.lightGray,
            width: address.isSelected ? 2 : 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  address.label,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const Spacer(),
                if (address.isSelected)
                  const Icon(Icons.check_circle, size: 20, color: AppColors.primaryGreen),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              address.street,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBrown,
              ),
            ),
            Text(address.city, style: AppTextStyles.body),
            const Divider(color: AppColors.lightGray, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 14, color: AppColors.darkBrown),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _deleteAddress(address),
                  icon: const Icon(Icons.delete, size: 14, color: AppColors.darkBrown),
                  label: const Text(
                    'Hapus',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.my_location, size: 16, color: AppColors.primaryGreen),
              SizedBox(width: 6),
              Text(
                'Cari lokasi sekitar Anda',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13,
                  color: AppColors.darkBrown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addNewAddress,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: const Icon(Icons.add, color: AppColors.primaryGreen),
        label: const Text(
          'Tambahkan Alamat Baru',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
    );
  }
}