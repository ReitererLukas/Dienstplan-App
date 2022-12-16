import { HydratedDocument } from "mongoose";
import { IDienstplan, models } from "./models";
import { fetcher } from "@/helpers"

async function insertDienstplan(data: any): Promise<number> {
  const hash = await fetcher(data.dienstplanLink);
  if (hash) {
    data.hashOfLastDP = hash;
    const dienstplan: HydratedDocument<IDienstplan> = new models.Dienstplan(data);
    await dienstplan.save();
    return dienstplan.id;
  }
  // throw error
  return 0;
}

async function updateDienstplan(id: any, data: Object): Promise<any> {
  const dienstplan = await models.Dienstplan.findOneAndUpdate({ _id: id }, data, { new: true, fields: { __v: 0 } });
  return dienstplan;
}

async function removeDienstplan(id: any) {
  await models.Dienstplan.deleteOne({ _id: id });
}


export const crud = { insertDienstplan, updateDienstplan, removeDienstplan };