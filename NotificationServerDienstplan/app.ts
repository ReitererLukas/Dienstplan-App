import express, { Express } from 'express';
import router from "@/api/routes";
import { authenticate, errorHandler } from "@/api/middleware";
import mongoose, { connect } from 'mongoose';
import bodyParser from 'body-parser';
import cors from 'cors';
import { startDienstplanChangeJob, startDienstplanRemoverJob } from '@/jobs';
import { vault } from "@/helpers/vault";


const app: Express = express();

app.get('/', (req, res) => {
  res.send('Well done!');
});

app.use(cors());
app.use(bodyParser.json());

app.use(authenticate);
app.use("/dienstplan", router);

app.use(errorHandler);


initDb().then(() => {
  startDienstplanChangeJob();
  startDienstplanRemoverJob();
  app.listen(8000, () => {
    console.log('Server listening on port 8000');
  });
});

async function initDb() {
  mongoose.set('strictQuery', false);
  let dbHost = 'localhost';
  if(vault.stage == 'PROD') {
    dbHost = vault.dbHost;
  }
  console.log('mongodb://' + vault.mongoUsername + ':' + vault.mongoPassword + '@'+dbHost+':27017/dienstplanapp?authSource=admin');
  await connect('mongodb://' + vault.mongoUsername + ':' + vault.mongoPassword + '@'+dbHost+':27017/dienstplanapp?authSource=admin');
} 