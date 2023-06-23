# Store App
This app is designed for an online clothes store. The app allows customers to easily browse and purchase items from the store using their mobile devices.

<div style="overflow-x:auto;">
  <table style="height: 400px;">
    <tr>
      <td><img src="https://user-images.githubusercontent.com/40627412/236239935-1e4b1d33-9373-4096-81d7-7f4915081a5f.png" height="400"></td>
      <td><img src="https://user-images.githubusercontent.com/40627412/236240197-18ba04a2-c857-4e0d-989e-1b19b3545c6a.png" height="400"></td>
      <td><img src="https://user-images.githubusercontent.com/40627412/236240272-14db1dc1-a040-469a-ba13-a4326e4dd885.png" height="400"></td>
      <td><img src="https://user-images.githubusercontent.com/40627412/236240820-f589ab1f-0047-4d7e-9124-0dbe15e048c4.png" height="400"></td>
    </tr>
  </table>
</div>

## Technologies Used
The mobile application is developed using the Flutter framework and Firebase services. The **Firebase Authentication** service is utilized to provide secure user authentication. The **Firestore** service is used to persistently store chats, products, orders, and cart items. Push notifications are implemented using the **Firebase Cloud Messaging** service. Additionally, the **Firebase Cloud Storage** service is utilized to securely store and retrieve images used in the application.

## Features and Functionalities
1. User Authentication: log in, sign up, forgot Password and log out (Firebase Authentication)
2. Lazy loading of products and orders.
4. Add products to cart and specify quantity
5. Retrieve cart items of current user
6. Dynamic Inventory Management: user's orders impact the product inventory based on the selected size. This feature ensures that when a user places an order with a specific cart item size, the corresponding quantity of that size is decremented from the total product inventory. Additionally, if an order depletes all available sizes of a product, that particular product is automatically removed from the inventory.
7. Favorite products
8. Show all available products
9. View past orders
10. Chat with customer service
11. Push notifications
12. Manage products (add, delete, or edit) (only for admins)
13. Animations
14. Use of Provider for state management
15. Error handling
16. Admin Dashboard: accessible only to admin users.
17. Make orders

## Screens:

1. Login Screen 
  
      a. Verify Email Screen: Prompts users to verify their email address if it hasn't been verified yet.

      b. Forgot Password Screen

      c. Sign Up Screen
  
2. Home Screen: Displays a list of all available products in the store, allowing users to browse and search for items.
3. Product Details Screen: Provides detailed information about a specific product, including images, description, price, and options to add it to the cart or mark it as a favorite.
4. Cart Screen: Shows the items added to the user's cart, allowing them to adjust quantities, remove items, and proceed to checkout.
5. Orders Screen: Displays the user's past orders, including order details, status, and the ability to track shipments.
6. Favorites Screen: Lists the products marked as favorites by the user for easy access and quick purchase.
7. Products Manager Screen: Accessible only to admin users, this screen provides tools for managing products, such as adding, editing, or deleting products.

## Design:

The UI/UX design for this project was taken from a free Figma community file available under the Creative Commons Attribution 4.0 International License. The original design was created by Mohsin Jutt.
