import { IDienstplan } from "@/db/models";
import admin from "firebase-admin";
import { getMessaging } from "firebase-admin/messaging";
import { HydratedDocument } from "mongoose";

import { vault } from "@/helpers/vault";

const app = admin.initializeApp({
  credential: admin.credential.cert(vault.serviceAccount as admin.ServiceAccount)
});

export function sendNotification(dienst: HydratedDocument<IDienstplan>) {
  const message = {
    notification: {
      title: 'Dienstplanänderung ' + dienst.name,
      body: 'Achtung dein Dienstplan hat sich verändert'
    },
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
      notificationId: "" + dienst.id
    },
    token: dienst.notificationToken
  };

  getMessaging().send(message)
    .then((response) => {
      console.log('Successfully sent message:', response);
    })
    .catch((error) => {
      console.log('Error sending message:', error);
    });
}