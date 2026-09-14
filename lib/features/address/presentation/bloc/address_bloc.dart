import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_stack_mobile_app/features/address/domain/entities/address.dart';

import '../../domain/repositories/address_repository.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(this.repository) : super(const AddressState()) {
    on<AddressStarted>(_onAddressStarted);
    on<AddressSelected>(_onAddressSelected);
    on<AddressRefreshed>(_onAddressRefreshed);
    on<AddressAddRequested>(_onAddressAddRequested);
  }

  final AddressRepository repository;

  Future<void> _onAddressStarted(
    AddressStarted event,
    Emitter<AddressState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AddressStatus.loading,
        errorMessage: null,
        isRefreshing: false,
      ),
    );

    final result = await repository.getAddresses();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AddressStatus.failure,
            errorMessage: failure.message,
            isRefreshing: false,
          ),
        );
      },
      (addresses) {
        final defaultAddress = addresses
            .where((address) => address.isDefault)
            .firstOrNull;

        emit(
          state.copyWith(
            status: AddressStatus.success,
            addresses: addresses,
            selectedAddress: defaultAddress,
            errorMessage: null,
            isRefreshing: false,
          ),
        );
      },
    );
  }

  void _onAddressSelected(AddressSelected event, Emitter<AddressState> emit) {
    emit(state.copyWith(selectedAddress: event.address, errorMessage: null));
  }

  Future<void> _onAddressRefreshed(
    AddressRefreshed event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, errorMessage: null));

    final result = await repository.getAddresses();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AddressStatus.failure,
            errorMessage: failure.message,
            isRefreshing: false,
          ),
        );
      },
      (addresses) {
        final selectedId = state.selectedAddress?.id;

        Address? selectedAddress;

        for (final address in addresses) {
          if (address.id == selectedId) {
            selectedAddress = address;
            break;
          }
        }

        selectedAddress ??= addresses
            .where((address) => address.isDefault)
            .firstOrNull;

        emit(
          state.copyWith(
            status: AddressStatus.success,
            addresses: addresses,
            selectedAddress: selectedAddress,
            errorMessage: null,
            isRefreshing: false,
          ),
        );
      },
    );
  }

  Future<void> _onAddressAddRequested(
    AddressAddRequested event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.adding, errorMessage: null));

    final result = await repository.addAddress(event.address);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AddressStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (address) {
        emit(
          state.copyWith(
            status: AddressStatus.added,
            addresses: [...state.addresses, address],
            selectedAddress: address,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
