import 'package:flutter/material.dart';
import 'package:full_stack_mobile_app/core/theme/app_text_styles.dart';
import 'package:full_stack_mobile_app/shared/widgets/app_text_field.dart';

import '../../../../core/theme/app_spacing.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({
    required this.onSubmit,
    this.isSubmitting = false,
    super.key,
  });

  final ValueChanged<AddressFormData> onSubmit;
  final bool isSubmitting;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  final _recipientNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  String _selectedLabel = 'Home';

  @override
  void dispose() {
    _recipientNameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onSubmit(
      AddressFormData(
        label: _selectedLabel,
        recipientName: _recipientNameController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine1: _addressLine1Controller.text.trim(),
        addressLine2: _addressLine2Controller.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              const Text('Address Type', style: AppTextStyles.bodyLarge),

              const SizedBox(height: AppSpacing.sm),

              _buildAddressTypeSelector(),

              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                controller: _recipientNameController,
                label: 'Recipient Name',
                hint: 'Enter recipient name',
                prefixIcon: const Icon(Icons.person_outline),
                textInputAction: TextInputAction.next,
                enabled: !widget.isSubmitting,
                validator: (value) {
                  return _requiredValidator(value, 'Recipient name');
                },
              ),

              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'Enter 10-digit phone number',
                prefixIcon: const Icon(Icons.phone_outlined),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                enabled: !widget.isSubmitting,
                validator: _phoneValidator,
              ),

              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _addressLine1Controller,
                label: 'Address Line 1',
                hint: 'House / Flat / Building / Street',
                prefixIcon: const Icon(Icons.home_outlined),
                textInputAction: TextInputAction.next,
                enabled: !widget.isSubmitting,
                validator: (value) {
                  return _requiredValidator(value, 'Address');
                },
              ),

              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _addressLine2Controller,
                label: 'Address Line 2',
                hint: 'Area / Landmark (optional)',
                prefixIcon: const Icon(Icons.location_on_outlined),
                textInputAction: TextInputAction.next,
                enabled: !widget.isSubmitting,
              ),

              const SizedBox(height: AppSpacing.md),

              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildCityField()),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: _buildStateField()),
                  ],
                )
              else ...[
                _buildCityField(),
                const SizedBox(height: AppSpacing.md),
                _buildStateField(),
              ],

              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _postalCodeController,
                label: 'Postal Code',
                hint: 'Enter 6-digit postal code',
                prefixIcon: const Icon(Icons.local_post_office_outlined),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                enabled: !widget.isSubmitting,
                validator: _postalCodeValidator,
                onSubmitted: (_) {
                  if (!widget.isSubmitting) {
                    _submit();
                  }
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: widget.isSubmitting ? null : _submit,
                  icon: widget.isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    widget.isSubmitting ? 'Saving Address...' : 'Save Address',
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddressTypeSelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment<String>(
          value: 'Home',
          label: Text('Home'),
          icon: Icon(Icons.home_outlined),
        ),
        ButtonSegment<String>(
          value: 'Office',
          label: Text('Office'),
          icon: Icon(Icons.business_outlined),
        ),
        ButtonSegment<String>(
          value: 'Other',
          label: Text('Other'),
          icon: Icon(Icons.location_on_outlined),
        ),
      ],
      selected: {_selectedLabel},
      onSelectionChanged: widget.isSubmitting
          ? null
          : (selection) {
              setState(() {
                _selectedLabel = selection.first;
              });
            },
    );
  }

  Widget _buildCityField() {
    return AppTextField(
      controller: _cityController,
      label: 'City',
      hint: 'Enter city',
      prefixIcon: const Icon(Icons.location_city_outlined),
      textInputAction: TextInputAction.next,
      enabled: !widget.isSubmitting,
      validator: (value) {
        return _requiredValidator(value, 'City');
      },
    );
  }

  Widget _buildStateField() {
    return AppTextField(
      controller: _stateController,
      label: 'State',
      hint: 'Enter state',
      prefixIcon: const Icon(Icons.map_outlined),
      textInputAction: TextInputAction.next,
      enabled: !widget.isSubmitting,
      validator: (value) {
        return _requiredValidator(value, 'State');
      },
    );
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 10) {
      return 'Enter a valid 10-digit phone number';
    }

    return null;
  }

  String? _postalCodeValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'Enter a valid 6-digit postal code';
    }

    return null;
  }
}

class AddressFormData {
  const AddressFormData({
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  final String label;
  final String recipientName;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
}
