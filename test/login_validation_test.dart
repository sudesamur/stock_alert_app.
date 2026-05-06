import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Invalid email formats should be rejected', () {
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

    final invalidEmails = [
      'test',
      'test@',
      'test@gmail',
      'testgmail.com',
    ];

    for (var email in invalidEmails) {
      expect(regex.hasMatch(email), false);
    }
  });

  test('Signup should fail when email or password is invalid', () {
  bool canSignup(String email, String password) {
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(email) && password.length >= 6;
  }

  // Geçersiz email
  expect(canSignup('invalid', '123456'), false);

  // Kısa şifre
  expect(canSignup('user@test.com', '123'), false);

  // Her şey doğru
  expect(canSignup('user@test.com', '123456'), true);
});

test('Login should fail when email or password is empty', () {
  bool canLogin(String email, String password) {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(email) && password.length >= 6;
  }

  // Email boş
  expect(canLogin('', '123456'), false);

  // Şifre boş
  expect(canLogin('user@test.com', ''), false);

  // İkisi de boş
  expect(canLogin('', ''), false);

  // İkisi de dolu ve geçerli
  expect(canLogin('user@test.com', '123456'), true);
});

test('Product should be added to cart successfully', () {
  // Sepet başlangıçta boş
  final List<String> cart = [];

  void addToCart(String product) {
    cart.add(product);
  }

  // Ürün ekle
  addToCart('Product A');

  // Testler
  expect(cart.isNotEmpty, true);
  expect(cart.length, 1);
  expect(cart.contains('Product A'), true);
});

test('Product should be removed from cart successfully', () {
  final List<String> cart = ['Product A', 'Product B'];

  void removeFromCart(String product) {
    cart.remove(product);
  }

  removeFromCart('Product A');

  expect(cart.contains('Product A'), false);
  expect(cart.length, 1);
  expect(cart.contains('Product B'), true);
});

}
