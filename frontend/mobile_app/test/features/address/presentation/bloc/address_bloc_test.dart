import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:full_stack_mobile_app/core/error/failure.dart';
import 'package:full_stack_mobile_app/features/address/domain/entities/address.dart';
import 'package:full_stack_mobile_app/features/address/domain/repositories/address_repository.dart';
import 'package:full_stack_mobile_app/features/address/presentation/bloc/address_bloc.dart';
import 'package:full_stack_mobile_app/features/address/presentation/bloc/address_event.dart';
import 'package:full_stack_mobile_app/features/address/presentation/bloc/address_state.dart';

class FakeAddressRepository implements AddressRepository {
  FakeAddressRepository({
    this.addressesResult,
    this.defaultAddressResult,
    this.addAddressResult,
  });

  final Either<Failure, List<Address>>? addressesResult;
  final Either<Failure, Address>? defaultAddressResult;
  final Either<Failure, Address>? addAddressResult;

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    return addressesResult ?? const Right([]);
  }

  @override
  Future<Either<Failure, Address>> getDefaultAddress() async {
    return defaultAddressResult ??
        const Left(UnknownFailure('No default address found.'));
  }

  @override
  Future<Either<Failure, Address>> addAddress(Address address) async {
    return addAddressResult ?? Right(address);
  }
}

void main() {
  const homeAddress = Address(
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
  );

  const officeAddress = Address(
    id: 'address-2',
    label: 'Office',
    fullName: 'Amit Joshi',
    addressLine1: '456 Business Park',
    addressLine2: 'Corporate Road',
    city: 'Ahmedabad',
    state: 'Gujarat',
    postalCode: '380015',
    phoneNumber: '+91 9876543210',
  );

  group('AddressBloc', () {
    blocTest<AddressBloc, AddressState>(
      'emits loading and success when addresses load successfully',
      build: () {
        final repository = FakeAddressRepository(
          addressesResult: const Right([homeAddress, officeAddress]),
        );

        return AddressBloc(repository);
      },
      act: (bloc) => bloc.add(const AddressStarted()),
      expect: () => [
        const AddressState(status: AddressStatus.loading),
        const AddressState(
          status: AddressStatus.success,
          addresses: [homeAddress, officeAddress],
          selectedAddress: homeAddress,
        ),
      ],
    );

    blocTest<AddressBloc, AddressState>(
      'emits failure when loading addresses fails',
      build: () {
        final repository = FakeAddressRepository(
          addressesResult: const Left(
            UnknownFailure('Unable to load addresses'),
          ),
        );

        return AddressBloc(repository);
      },
      act: (bloc) => bloc.add(const AddressStarted()),
      expect: () => [
        const AddressState(status: AddressStatus.loading),
        const AddressState(
          status: AddressStatus.failure,
          errorMessage: 'Unable to load addresses',
        ),
      ],
    );

    blocTest<AddressBloc, AddressState>(
      'updates selected address when address is selected',
      build: () {
        return AddressBloc(FakeAddressRepository());
      },
      seed: () => const AddressState(
        status: AddressStatus.success,
        addresses: [homeAddress, officeAddress],
        selectedAddress: homeAddress,
      ),
      act: (bloc) {
        bloc.add(const AddressSelected(officeAddress));
      },
      expect: () => [
        const AddressState(
          status: AddressStatus.success,
          addresses: [homeAddress, officeAddress],
          selectedAddress: officeAddress,
        ),
      ],
    );

    blocTest<AddressBloc, AddressState>(
      'adds address and selects the newly added address',
      build: () {
        final repository = FakeAddressRepository(
          addAddressResult: const Right(officeAddress),
        );

        return AddressBloc(repository);
      },
      seed: () => const AddressState(
        status: AddressStatus.success,
        addresses: [homeAddress],
        selectedAddress: homeAddress,
      ),
      act: (bloc) {
        bloc.add(const AddressAddRequested(officeAddress));
      },
      expect: () => [
        const AddressState(
          status: AddressStatus.adding,
          addresses: [homeAddress],
          selectedAddress: homeAddress,
        ),
        const AddressState(
          status: AddressStatus.added,
          addresses: [homeAddress, officeAddress],
          selectedAddress: officeAddress,
        ),
      ],
    );

    blocTest<AddressBloc, AddressState>(
      'emits failure when adding address fails',
      build: () {
        final repository = FakeAddressRepository(
          addAddressResult: const Left(UnknownFailure('Unable to add address')),
        );

        return AddressBloc(repository);
      },
      seed: () => const AddressState(
        status: AddressStatus.success,
        addresses: [homeAddress],
        selectedAddress: homeAddress,
      ),
      act: (bloc) {
        bloc.add(const AddressAddRequested(officeAddress));
      },
      expect: () => [
        const AddressState(
          status: AddressStatus.adding,
          addresses: [homeAddress],
          selectedAddress: homeAddress,
        ),
        const AddressState(
          status: AddressStatus.failure,
          addresses: [homeAddress],
          selectedAddress: homeAddress,
          errorMessage: 'Unable to add address',
        ),
      ],
    );

    blocTest<AddressBloc, AddressState>(
      'refreshes addresses and keeps the previously selected address',
      build: () {
        final repository = FakeAddressRepository(
          addressesResult: const Right([homeAddress, officeAddress]),
        );

        return AddressBloc(repository);
      },
      seed: () => const AddressState(
        status: AddressStatus.success,
        addresses: [homeAddress],
        selectedAddress: homeAddress,
      ),
      act: (bloc) {
        bloc.add(const AddressRefreshed());
      },
      expect: () => [
        const AddressState(
          status: AddressStatus.success,
          addresses: [homeAddress],
          selectedAddress: homeAddress,
          isRefreshing: true,
        ),
        const AddressState(
          status: AddressStatus.success,
          addresses: [homeAddress, officeAddress],
          selectedAddress: homeAddress,
        ),
      ],
    );
  });
}
