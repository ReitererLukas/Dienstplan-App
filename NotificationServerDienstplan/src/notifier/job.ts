import { IDienstplan, models } from "@/db/models";
import { fetcher } from "@/helpers";
import { HydratedDocument } from "mongoose";
import { sendNotification } from "./notificationSender";


export function startNotificationWorker() {
  setInterval(notificationWoker, 2000);
}

async function notificationWoker() {
  for (let link of await models.Dienstplan.distinct('dienstplanLink')) {
    const hash = await fetcher(link);
    if (hash) {
      compareDienst(hash, link);
    }
  }
}

async function compareDienst(hash: string, link: string) {
  models.Dienstplan.find({ dienstplanLink: link, hashOfLastDP: { $ne: hash } }, (err: any, dienste: HydratedDocument<IDienstplan>[]) => {
    if (err) return null;

    for (let dienst of dienste) {
      sendNotification(dienst);
      dienst.hashOfLastDP = hash;
      dienst.save();
    }
  });
}

