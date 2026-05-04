const admin = require('firebase-admin');

// Initialize Firebase Admin with Application Default Credentials
admin.initializeApp({
  credential: admin.credential.applicationDefault()
});

const db = admin.firestore();

const mockProperties = [
  { id: 'p1', address: '123 Fake St, Springfield', lat: 39.7817, lng: -89.6501, averageRating: 1.5 },
  { id: 'p2', address: '456 Elm Ave, Springfield', lat: 39.7900, lng: -89.6600, averageRating: 4.0 },
  { id: 'p3', address: '789 Oak Ln, Springfield', lat: 39.7700, lng: -89.6400, averageRating: 2.0 }
];

const mockReviews = [
  {
    id: 'r1',
    propertyId: 'p1',
    propertyAddress: '123 Fake St, Springfield',
    authorName: 'Sparky Dan',
    authorTrade: 'Electrician',
    text: 'Terrible experience. The client refused to pay for the drywall patching after I fixed the stud they broke. Required 3 trips and constant haggling. Avoid if possible.',
    rating: 1,
    imageUrls: [],
    upvotes: 24,
    commentsCount: 5,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'r2',
    propertyId: 'p2',
    propertyAddress: '456 Elm Ave, Springfield',
    authorName: 'Mike Builder',
    authorTrade: 'General Contractor',
    text: 'Great client. Paid on time, had clear instructions, and even bought the crew lunch on Friday. Would definitely work with them again.',
    rating: 5,
    imageUrls: [],
    upvotes: 12,
    commentsCount: 1,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    id: 'r3',
    propertyId: 'p3',
    propertyAddress: '789 Oak Ln, Springfield',
    authorName: 'Joe Plumber',
    authorTrade: 'Plumbing',
    text: 'Basement was flooded and they blamed me even though it was a city main issue. Nightmare to deal with insurance. Property itself is poorly maintained.',
    rating: 2,
    imageUrls: [],
    upvotes: 89,
    commentsCount: 12,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  }
];

async function seed() {
  console.log('Seeding properties...');
  for (const p of mockProperties) {
    await db.collection('properties').doc(p.id).set(p);
  }

  console.log('Seeding reviews...');
  for (const r of mockReviews) {
    await db.collection('reviews').doc(r.id).set(r);
  }

  console.log('Database seeded successfully!');
}

seed().catch(console.error);
