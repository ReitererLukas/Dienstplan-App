import { IDienstplan, models } from "@/db/models";
import { dpHasher } from "@/helpers";
import { HydratedDocument } from "mongoose";
import { sendNotification } from "../notifier/notificationSender";
import { crud } from "@/db/crud";


export function startDienstplanChangeJob() {
  // every 1800000 milliseconds
  setInterval(worker, 1800000);
}

async function worker() {
  for (let link of await models.Dienstplan.distinct('dienstplanLink')) {
    const hash = await dpHasher(link);
    if (hash) {
      compareDienst(hash, link);
    }
  }
}

function leadingZero(num: number) {
  if(num < 10) {
    return "0"+num;
  }
  return num+"";
}

function formatDate(date: Date, format: string): string {
  format = format.replace('YYYY', date.getFullYear()+'');
  format = format.replace('MM', leadingZero(date.getMonth()+1));
  format = format = format.replace('DD', leadingZero(date.getDate()));
  format = format.replace('HH', leadingZero(date.getHours()));
  format = format.replace('mm', leadingZero(date.getMinutes()));
  format = format.replace('ss', leadingZero(date.getSeconds()));

  return format;
}

async function compareDienst(hash: any, link: string) {
  const dienste: HydratedDocument<IDienstplan>[] = await crud.findManyDienstplan({ dienstplanLink: link, currentHash: { $ne: hash.currentHash } });
  for (let dienst of dienste) {
    if(!(hash.currentHash == dienst.hashAfterNext && dienst.endOfNext < parseInt(formatDate(new Date(), 'YYYYMMDDHHmmss')))) {
      sendNotification(dienst);
    }

    dienst.currentHash = hash.currentHash;
    dienst.hashAfterNext = hash.hashAfterNext;
    dienst.endOfNext = hash.endOfNext;
    dienst.save();
  }
}

