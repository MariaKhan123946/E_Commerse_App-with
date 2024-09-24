class CartItem {
  String name;
  String description;
  double price;
  String image;
  int quantity;

  CartItem(this.name, this.description, this.price, this.image, {this.quantity = 1});
}
