import 'package:full_stack_mobile_app/features/address/domain/entities/address.dart';
import 'package:full_stack_mobile_app/features/checkout/domain/entities/checkout_address.dart';

CheckoutAddress toCheckoutAddress(Address address) {
  return CheckoutAddress(
    id: address.id,
    label: address.label,
    recipientName: address.fullName,
    addressLine1: address.addressLine1,
    addressLine2: address.addressLine2.isEmpty ? null : address.addressLine2,
    city: address.city,
    state: address.state,
    postalCode: address.postalCode,
    phone: address.phoneNumber,
  );
}
