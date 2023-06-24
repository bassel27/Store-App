1. Light and Dark Modes:

  - The app supports both light and dark modes for a personalized visual experience.
  - Your preference for light or dark mode is saved locally and loaded automatically when you start the app.
  - You can easily switch between light and dark mode by using the toggle button in the account settings screen.

2. Account Deletion with Data Integrity:

  - A secure account deletion feature to ensure the integrity of your data. When you delete your account, 
  we remove all associated data with that account from our databases, ensuring that no remnants of your 
  account or personal information remain.
  - To achieve this, we use a NoSQL database like Firebase, which allows us to efficiently delete your
  data from Firestore (our database) and your account from Firebase Authentication (our authentication system).
  - If you delete your account while offline (without an internet connection), the deletion request will be
  executed as soon as you regain internet access.

3. Enhanced User Experience:

  - We have implemented sound effects and haptic feedback to enhance your interaction with the app.
  - You will hear a clicking sound with a slight vibration when you tap on buttons or interact 
  with dialog boxes like the terms and conditions and delete account confirmation.  
  - Haptic feedback is slightly stronger for certain interactions, ensuring a more immersive experience.


4. About Page:

  - The app includes an About page that provides detailed information about the application. 
  - You can access the About page through the settings screen, where you'll find valuable
  insights and additional details about the app's purpose and features.


5. Terms and Conditions:

  - To ensure transparency and compliance, we have added the terms and conditions section to the login screen.

6. Notification Control:
  - You have control over the types of notifications you receive from the app.
  - We offer two toggle switches to manage your notification preferences:
    I. Marketing Notifications: Enable or disable notifications related to marketing campaigns and promotional offers.
    II. Personal Notifications: Enable or disable personal notification such as chat messages.