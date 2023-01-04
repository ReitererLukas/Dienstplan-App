import { model, Schema } from "mongoose";

export interface IDienstplan {
  dienstplanLink: string;
  notificationToken: string;
  currentHash: string;
  hashAfterNext: string;
  endOfNext: number;
  name: string;
  createdAt: number;
  updatedAt: number;
}

const dienstplanSchema = new Schema<IDienstplan>({
  dienstplanLink: { type: String, required: true },
  notificationToken: { type: String, required: true },
  currentHash: { type: String, required: true },
  endOfNext: { type: Number, required: true },
  hashAfterNext: { type: String, required: true },
  name: { type: String, required: true },
}, {timestamps: true});

const Dienstplan = model<IDienstplan>('dienstplaene', dienstplanSchema);

export const models = { Dienstplan };