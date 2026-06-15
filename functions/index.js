const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

exports.flutterwaveWebhook = functions.https.onRequest(async (req, res) => {
  try {
    const event = req.body;

    // Flutterwave sends 'successful' when a payment clears
    if (event.event === 'charge.completed' && event.data.status === 'successful') {
      
      // We encoded the moduleId in the txRef (e.g., "A1.1_uuid1234")
      const txRef = event.data.tx_ref;
      const moduleId = txRef.split('_')[0]; 
      
      // In production, ensure you pass the actual user_id in the payment metadata
      // For this boilerplate, we use the hardcoded test user
      const userId = "test_user_123"; 

      // Unlock the module securely in the database
      await db.collection('Users').doc(userId).set({
        unlocked_modules: admin.firestore.FieldValue.arrayUnion(moduleId)
      }, { merge: true });

      console.log(`Unlocked ${moduleId} for user ${userId}`);
    }

    res.status(200).send('Webhook received');
  } catch (error) {
    console.error("Webhook Error:", error);
    res.status(500).send('Server Error');
  }
});
