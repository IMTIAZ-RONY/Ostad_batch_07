
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ostad_batch_07/const.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<CartItem> items = [
    CartItem(
        name: 'Pullover', color: 'Black', size: 'L', price: 51, quantity: 1),
    CartItem(name: 'T-Shirt', color: 'Gray', size: 'L', price: 30, quantity: 1),
    CartItem(
        name: 'Sport Dress', color: 'Black', size: 'M', price: 43, quantity: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
          child: RichText(
            text: TextSpan(
              text: "My",
              style: GoogleFonts.russoOne().copyWith(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: " Bag",
                  style: GoogleFonts.russoOne().copyWith(
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2022/08/30/02/26/long-sleeved-polo-shirt-7420118_1280.png',
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ); // Display error icon if image fails
                                  },
                                ),
                              ), // Placeholder image
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      items[index].name,
                                      style:largeFont,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Color: ${items[index].color}  Size: ${items[index].size}',
                                      style: smallFont,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _removeButton(index);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: const CircleBorder(),
                                              backgroundColor: Colors.white,
                                              padding: const EdgeInsets.all(0),
                                              elevation: 0),
                                          child: const Icon(Icons.remove,
                                              color: Colors.red),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('${items[index].quantity}'),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            _addButton(index);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: const CircleBorder(),
                                              backgroundColor: Colors.white,
                                              padding: const EdgeInsets.all(0),
                                              elevation: 0),
                                          child: const Icon(Icons.add,
                                              color: Colors.green),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${items[index].price * items[index].quantity}\$',
                                          style: normalFont,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 2,
                          child: PopupMenuButton<String>(
                            onSelected: (String value) {
                              // Handle the selected menu action
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected: $value'),
                                ),
                              );
                            },
                            itemBuilder: (BuildContext context) {
                              return ['Option 1', 'Option 2', 'Remove']
                                  .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                            icon: const Icon(Icons.more_vert),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total amount:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${calculateTotal()}\$',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Congratulations! You have successfully checked out.'),
                      ),
                    );
                  },
                  child: const Text('CHECK OUT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int calculateTotal() {
    int total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void _removeButton(int index) {
    setState(() {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      }
    });
  }

  void _addButton(int index) {
    setState(() {
      items[index].quantity++;
    });
  }
}

class CartItem {
  String name;
  String color;
  String size;
  int price;
  int quantity;

  CartItem({
    required this.name,
    required this.color,
    required this.size,
    required this.price,
    this.quantity = 1,
  });
}
