
var admin = require("firebase-admin");

var serviceAccount = require("E:/Flutter project/cablecollection_app/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://cable-app-f9308-default-rtdb.firebaseio.com"
});


var registrationToken = 'd_4I86rNRm-Kupgn5Gav_4:APA91bGKx7FONvkIS_yl-bQfZY9UIYdZDHP68gF7Vlxnif2S4TkilTm2kYoXeQsumK2_aJ6c66WOcjsg09YQE9oZ5jafY8IMhGv-AwrpYl0AMgDvTm71gH2QEYfuY-qrw-AFtFLd4dS_';
var message = {
    data: {
        title: '850',
        body: '2:45',

    },
    token: registrationToken
};

admin.messaging().send(message).then((response) => {
    console.log('successfully sent message', response);

})
    .catch((error) => {
        console.log('Error sending message:', error);
    });