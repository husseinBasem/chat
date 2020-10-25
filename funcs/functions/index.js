var functions = require('firebase-functions');
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
 //   .document('messages/{groupId1}/{groupId2}/{message}')
    .document('ChatRoom/{groupId1}/chats/{message}')
    .onCreate((snap, context) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log(doc)

         const idFromToken = doc.messageFromToken
         const idToToken = doc.chattingWith
         const contentMessage = doc.message

        // Get push token user to (receive)
        admin
            .firestore().collection('users')
           .where('mobileToken', '==', idToToken)
            .get()
            .then(querySnapshot => {
                querySnapshot.forEach(userTo => {
                    console.log(`Found user to: ${userTo.data().Name}`)
                    if ( userTo.data().chattingWith !== idFromToken) {
                        // Get info user from (sent)
                        admin
                            .firestore()
                            .collection('users')
                            .where('mobileToken', '==', idFromToken)
                            .get()
                            .then(querySnapshot2 => {
                                querySnapshot2.forEach(userFrom => {
                                    console.log(`Found user from: ${userFrom.data().Name}`)
                                    const payload = {
                                        notification: {
                                            title: `You have a message from "${userFrom.data().Name}"`,
                                            body: contentMessage,
                                            badge: '1',
                                            sound: 'default'
                                        }
                                    }
                                    // Let push to the target device
                                    admin
                                        .messaging()
                                        .sendToDevice(userTo.data().mobileToken, payload)
                                        .then(response => {
                                            console.log('Successfully sent message:', response)
                                        })
                                        .catch(error => {
                                            console.log('Error sending message:', error)
                                        })
                                })
                            })
                    } else {
                        console.log('Can not find pushToken target user')
                    }
                })
            })
        return null
    })
