- Light and dark modes:
    - Preference saved locally and loaded on app start
    - Used toggle button on account settings screen
- Deleting account while ensuring the integrity of this feature in the database. 
  It is preferred if this is done in NoSQL database like firebase.
    - Integrity as far as I understood is deleting that account's past data to avoid having data for a non-existent account 
    (delete data in Firestore and the account in Firebase Authentication.)
    - When no internet, the delete request is executed when internet is available again.
- Sounds for clicking on buttons (diaog boxes like t&c and delete account)
- Included haptic feecdback in delete account confirmation dialog and on button click (diaog boxes like t&c and delete account). Light feedback is heavier than heavy feedback.
- About page that includes details about the app in the settings screen.