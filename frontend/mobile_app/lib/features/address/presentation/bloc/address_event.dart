import 'package:equatable/equatable.dart';

import '../../domain/entities/address.dart';

sealed class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

final class AddressStarted extends AddressEvent {
  const AddressStarted();
}

final class AddressSelected extends AddressEvent {
  const AddressSelected(this.address);

  final Address address;

  @override
  List<Object?> get props => [address];
}

final class AddressRefreshed extends AddressEvent {
  const AddressRefreshed();
}

final class AddressAddRequested extends AddressEvent {
  const AddressAddRequested(this.address);

  final Address address;

  @override
  List<Object?> get props => [address];
}
