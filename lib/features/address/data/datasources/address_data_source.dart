import '../../domain/entities/address.dart';

abstract interface class AddressDataSource {
  Future<List<Address>> getAddresses();

  Future<Address?> getDefaultAddress();

  Future<Address> addAddress(Address address);
}

class AddressDataSourceImpl implements AddressDataSource {
  AddressDataSourceImpl();

  final List<Address> _addresses = [
    const Address(
      id: 'address-1',
      label: 'Home',
      fullName: 'Amit Joshi',
      addressLine1: '123 Main Street',
      addressLine2: 'Near City Center',
      city: 'Ahmedabad',
      state: 'Gujarat',
      postalCode: '380001',
      phoneNumber: '+91 9876543210',
      isDefault: true,
    ),
    const Address(
      id: 'address-2',
      label: 'Office',
      fullName: 'Amit Joshi',
      addressLine1: '456 Business Park',
      addressLine2: 'Corporate Road',
      city: 'Ahmedabad',
      state: 'Gujarat',
      postalCode: '380015',
      phoneNumber: '+91 9876543210',
    ),
  ];

  @override
  Future<List<Address>> getAddresses() async {
    return List.unmodifiable(_addresses);
  }

  @override
  Future<Address?> getDefaultAddress() async {
    for (final address in _addresses) {
      if (address.isDefault) {
        return address;
      }
    }

    return null;
  }

  @override
  Future<Address> addAddress(Address address) async {
    _addresses.add(address);
    return address;
  }
}
