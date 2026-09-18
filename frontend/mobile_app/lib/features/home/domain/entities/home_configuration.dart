import 'package:equatable/equatable.dart';

import 'home_section.dart';

class HomeConfiguration extends Equatable {
  const HomeConfiguration({required this.sections});

  final List<HomeSection> sections;

  @override
  List<Object?> get props => [sections];
}
