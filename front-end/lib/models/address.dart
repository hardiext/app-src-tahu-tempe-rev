class Address {
  final String id;
  final String label;
  final String street;
  final String city;
  final String postalCode;
  final String? apartment;
  final bool isSelected;

  const Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    this.postalCode = '',
    this.apartment,
    this.isSelected = false,
  });

  String get fullAddress => '$street, $city';

  Address copyWith({
    String? id,
    String? label,
    String? street,
    String? city,
    String? postalCode,
    String? apartment,
    bool? isSelected,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      apartment: apartment ?? this.apartment,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  static List<Address> dummyList() {
    return const [
      Address(
        id: 'a001',
        label: 'RUMAH',
        street: 'Jl. Melati No. 12',
        city: 'Jakarta Selatan',
        postalCode: '51424',
        isSelected: true,
      ),
      Address(
        id: 'a002',
        label: 'KANTOR',
        street: 'Gedung Wisma Asri, Lt. 5',
        city: 'Kuningan, Jakarta Pusat',
        postalCode: '51422',
      ),
    ];
  }
}