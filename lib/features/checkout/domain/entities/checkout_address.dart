import 'package:equatable/equatable.dart';

class CheckoutAddress extends Equatable {
  const CheckoutAddress({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.phone,
  });

  final String id;
  final String label;
  final String recipientName;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String phone;

  @override
  List<Object?> get props => [
    id,
    label,
    recipientName,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    phone,
  ];
}
