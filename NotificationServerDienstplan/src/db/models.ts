import { isObjectIdOrHexString, model, Schema } from "mongoose";

export interface IDienstplan {
  dienstplanLink: string;
  notificationToken: string;
  hashOfLastDP: string;
  name: string;
}

const dienstplanSchema = new Schema<IDienstplan>({
  dienstplanLink: { type: String, required: true },
  notificationToken: { type: String, required: true },
  hashOfLastDP: { type: String, required: true },
  name: { type: String, required: true },
});

const Dienstplan = model<IDienstplan>('dienstplaene', dienstplanSchema);

export const models = { Dienstplan };