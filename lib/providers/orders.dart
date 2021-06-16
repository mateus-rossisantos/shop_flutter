import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/cart.dart';
import 'package:shop/utils/constantes.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  final Uri _baseUrl = Uri.parse('${Constants.BASE_API_URL}/orders');
  List<Order> _items = [];
  String _token;
  String _userId;

  Orders([this._token, this._items, this._userId]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    await http.post(
      Uri.parse('$_baseUrl/$_userId.json?auth=$_token'),
      body: json.encode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.item.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList()
      }),
    );
    _items.insert(
      0,
      Order(
        id: Random().nextDouble().toString(),
        total: cart.totalAmount,
        date: DateTime.now(),
        products: cart.item.values.toList(),
      ),
    );
    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get(Uri.parse('$_baseUrl/$_userId.json?auth=$_token'));
    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach(
        (orderId, orderData) {
          loadedItems.add(
            Order(
              id: orderId,
              total: orderData['total'],
              date: DateTime.parse(orderData['date']),
              products: (orderData['products'] as List<dynamic>).map((e) {
                return CartItem(
                  productId: e['productId'],
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                );
              }).toList(),
            ),
          );
        },
      );
      notifyListeners();
    }
    _items = loadedItems.reversed.toList();
    return Future.value();
  }
}
