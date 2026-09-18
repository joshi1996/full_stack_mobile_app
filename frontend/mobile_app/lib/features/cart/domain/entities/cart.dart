import 'package:equatable/equatable.dart';

import 'cart_item.dart';

class Cart extends Equatable {
  const Cart({this.items = const []});

  final List<CartItem> items;

  double get subtotal {
    return items.fold(0, (total, item) => total + item.totalPrice);
  }

  int get totalItems {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  bool get isEmpty => items.isEmpty;

  Cart copyWith({List<CartItem>? items}) {
    return Cart(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
