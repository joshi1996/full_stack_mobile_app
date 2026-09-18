import 'package:equatable/equatable.dart';

import '../../domain/entities/address.dart';

enum AddressStatus { initial, loading, success, failure, adding, added }

class AddressState extends Equatable {
  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.selectedAddress,
    this.errorMessage,
    this.isRefreshing = false,
  });

  final AddressStatus status;
  final List<Address> addresses;
  final Address? selectedAddress;
  final String? errorMessage;
  final bool isRefreshing;

  AddressState copyWith({
    AddressStatus? status,
    List<Address>? addresses,
    Address? selectedAddress,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    addresses,
    selectedAddress,
    errorMessage,
    isRefreshing,
  ];
}
