const { setGlobalOptions } = require("firebase-functions/v2");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

admin.initializeApp();

setGlobalOptions({ maxInstances: 10 });

/**
 * 1. Automatically generate a referral code when a new user document is created.
 */
exports.onCreateUserDoc = onDocumentCreated("users/{uid}", async (event) => {
    const snapshot = event.data;
    if (!snapshot) return null;

    const data = snapshot.data();
    // Only generate if the user doesn't already have a code
    if (data.referralCode) return null;

    const uid = event.params.uid;
    const referralCode = Math.random().toString(36).substring(2, 8).toUpperCase();

    const batch = admin.firestore().batch();

    // Update user doc with their new code
    const userRef = admin.firestore().collection('users').doc(uid);
    batch.update(userRef, { referralCode: referralCode });

    // Create lookup doc in 'referrals' collection
    const referralRef = admin.firestore().collection('referrals').doc(referralCode);
    batch.set(referralRef, {
        ownerUid: uid,
        usageCount: 0,
        redeemedUids: []
    });

    try {
        await batch.commit();
        logger.info(`Generated code ${referralCode} for user ${uid}`);
    } catch (error) {
        logger.error("Error creating referral code:", error);
    }
});

/**
 * 2. Callable function for the Flutter app to redeem a code.
 */
exports.useReferralCode = onCall(async (request) => {
    // Check authentication
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "User must be logged in.");
    }

    const code = (request.data.code) ? request.data.code.toUpperCase() : null;
    const newUserUid = request.auth.uid;

    if (!code) {
        throw new HttpsError("invalid-argument", "Referral code is required.");
    }

    const referralRef = admin.firestore().collection('referrals').doc(code);
    const referralDoc = await referralRef.get();

    if (!referralDoc.exists) {
        throw new HttpsError("not-found", "This referral code does not exist.");
    }

    const referralData = referralDoc.data();

    if (referralData.ownerUid === newUserUid) {
        throw new HttpsError("failed-precondition", "You cannot use your own code.");
    }

    if (referralData.redeemedUids.includes(newUserUid)) {
        throw new HttpsError("already-exists", "You have already used this code.");
    }

    const batch = admin.firestore().batch();

    // Reward the owner and track the new user
    batch.update(referralRef, {
        usageCount: admin.firestore.FieldValue.increment(1),
        redeemedUids: admin.firestore.FieldValue.arrayUnion(newUserUid)
    });

    // Mark the new user as referred
    const userRef = admin.firestore().collection('users').doc(newUserUid);
    batch.update(userRef, { 
        referredBy: code, 
        referralStatus: 'completed' 
    });

    await batch.commit();
    return { status: "success", message: "Referral applied successfully!" };
});