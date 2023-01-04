import { crud } from "@/db/crud";


export function startDienstplanRemoverJob() {
  // every 86400000 milliseconds
  setInterval(worker, 86400000);
}

async function worker() {
  let now = Date.now()
  for (let dp of await crud.findManyDienstplan({})) {
    let diff = (now - dp.updatedAt.valueOf())/86400000;
    if (diff > 60) {
      crud.removeDienstplan(dp.id);
    }
  }
}

