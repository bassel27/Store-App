import 'package:flutter/material.dart';

import '../widgets/brandatak_stack.dart';

class AboutScreen extends StatelessWidget {
  static const route = "/bottom_nav_bar/about";

  @override
  Widget build(BuildContext context) {
    return BrandatakStack(
        addBackButton: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 13, left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'The Store App is a user-friendly mobile application designed for an online clothes store. Developed by Bassel Attia, the app allows customers to conveniently browse and purchase a wide range of clothing items directly from their mobile devices. With a sleek and intuitive interface, users can explore the store\'s extensive collection, view detailed product information, and easily add items to their cart. The app utilizes secure user authentication powered by Firebase Authentication, ensuring a safe and personalized shopping experience.\n\n'
                'The Store App leverages the power of Firebase services to enhance its functionality. The Firestore service enables seamless storage and retrieval of chats, products, orders, and cart items, providing a seamless and efficient shopping process. Push notifications are implemented using Firebase Cloud Messaging, allowing users to stay updated with the latest offers, promotions, and order updates. Additionally, the app utilizes Firebase Cloud Storage to securely store and retrieve product images, ensuring high-quality visuals.\n\n'
                'Key features of the app include user authentication functionalities such as login, sign up, and password recovery. Users can easily manage their cart, adjust quantities, and proceed to checkout. The app also offers a dynamic inventory management system, where the availability of products is automatically updated based on user orders and selected sizes. Users can mark favorite products for quick access and explore past orders for reference. A chat feature allows seamless communication with customer service for any queries or assistance.\n\n'
                'The Store App incorporates smooth animations and utilizes the Provider package for efficient state management. Error handling is implemented to provide a seamless and error-free experience. For administrators, an exclusive admin dashboard is available for managing products, including the ability to add, delete, or edit product details.\n\n'
                'The app\'s UI/UX design is inspired by a free Figma community file available under the Creative Commons Attribution 4.0 International License, with the development and implementation executed solely by Bassel Attia.',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }
}
