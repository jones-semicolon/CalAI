const admin = require("firebase-admin");

// Initialization (Keep your existing setup)
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const auth = admin.auth();

async function cleanupOrphanedData() {
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 15);

  console.log(
    `Cleaning up Firestore data older than: ${thirtyDaysAgo.toISOString()}`,
  );

  // Ensure 'timestamp' matches the field name in your Firestore documents
  const collectionRef = db.collection("users");
  const snapshot = await collectionRef
    .where("updatedAt", "<", thirtyDaysAgo)
    .get();

  if (snapshot.empty) {
    console.log("No old Firestore data found.");
    return;
  }

  console.log(`Found ${snapshot.size} old documents. Deleting...`);

  const batch = db.batch();
  snapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });

  await batch.commit();
  console.log("Firestore cleanup complete.");
}

async function cleanupAnonymousUsers() {
  const thirtyDaysAgo = Date.now() - 15 * 24 * 60 * 60 * 1000;
  let usersToDelete = [];

  // 1. Fetch all users and filter for inactive anonymous accounts
  async function listUsers(nextPageToken) {
    const result = await auth.listUsers(1000, nextPageToken);
    result.users.forEach((user) => {
      const isAnonymous = user.providerData.length === 0;
      const lastLogin = Date.parse(user.metadata.lastSignInTime);

      if (isAnonymous && lastLogin < thirtyDaysAgo) {
        usersToDelete.push(user.uid);
      }
    });
    if (result.pageToken) await listUsers(result.pageToken);
  }

  await listUsers();
  console.log(`Found ${usersToDelete.length} inactive anonymous users.`);

  for (const uid of usersToDelete) {
    try {
      // 2. Delete User's Firestore Data (e.g., daily logs for Cal AI)
      // This prevents "orphaned" data in your DB
      const logsRef = db.collection("daily_logs").where("uid", "==", uid);
      const snapshot = await logsRef.get();

      const batch = db.batch();
      snapshot.docs.forEach((doc) => batch.delete(doc.ref));
      await batch.commit();

      // 3. Delete the User from Auth
      await auth.deleteUser(uid);
      console.log(`Successfully purged user: ${uid}`);
    } catch (err) {
      console.error(`Failed to cleanup user ${uid}:`, err);
    }
  }
}

cleanupOrphanedData();
cleanupAnonymousUsers();
