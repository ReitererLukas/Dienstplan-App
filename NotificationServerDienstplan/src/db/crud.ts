import { HydratedDocument, model } from "mongoose";
import { IDienstplan, models } from "./models";

import { dpHasher } from "@/helpers"

async function findOneDienstplanNullSafe(filter: object): Promise<HydratedDocument<IDienstplan>> {
  const d: HydratedDocument<IDienstplan>|null = await models.Dienstplan.findOne(filter).exec()
  if(!d) {
    // throw execption
  }
  return d!;
}

async function findOneDienstplan(filter: object): Promise<HydratedDocument<IDienstplan>|null> {
  return await models.Dienstplan.findOne(filter).exec()
}

async function findManyDienstplan(filter: object): Promise<HydratedDocument<IDienstplan>[]> {
  const d: HydratedDocument<IDienstplan>[]|null = await models.Dienstplan.find(filter).exec()
  if(d == null) {
    // TODO: throw Exception
    return [];
  }
  return d!;
}

async function insertDienstplan(data: any): Promise<number> {
  const hash = await dpHasher(data.dienstplanLink);
  if (hash) {
    data = {...data, ...hash}
    const dienstplan: HydratedDocument<IDienstplan> = new models.Dienstplan(data);
    await dienstplan.save();
    return dienstplan.id;
  }
  // TODO: throw error
  return 0;
}

async function updateDienstplan(id: any, data: Object): Promise<any> {
  const dienstplan = await models.Dienstplan.findOneAndUpdate({ _id: id }, data, { new: true, fields: { __v: 0 } });
  return dienstplan;
}

async function removeDienstplan(id: any) {
  console.log(id);
  await models.Dienstplan.deleteOne({ _id: id });
}

async function updateTimerOfDienstplan(id: string): Promise<boolean> {
  const dp = await findOneDienstplan({_id: id});
  if(dp) {
    dp.updatedAt = Date.now();
    dp.save()
    return true;
  }
  return false;
}


export const crud = { insertDienstplan, updateDienstplan, removeDienstplan, findOneDienstplan, findManyDienstplan, updateTimerOfDienstplan, findOneDienstplanNullSafe};