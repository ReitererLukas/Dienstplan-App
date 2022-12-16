import express, { Express } from 'express';
import router from "@/api/routes";
import { authenticate, errorHandler } from "@/api/middleware";
import mongoose, { connect } from 'mongoose';
import bodyParser from 'body-parser';
import cors from 'cors';
import { startNotificationWorker } from '@/notifier/job';
import { vault } from "@/helpers/secretVault";


const app: Express = express();

app.get('/', (req, res) => {
  res.send('Well done!');
});

app.use(cors());
app.use(bodyParser.json());

app.use(authenticate);
app.use("/token", router);

app.use(errorHandler);


initDb().then(() => {
  startNotificationWorker();
  app.listen(8000, () => {
    console.log('Server listening on port 8000');
  });
});

async function initDb() {
  mongoose.set('strictQuery', false);
  let dbUrl = 'localhost';
  if(vault.stage == 'PROD') {
    dbUrl = vault.dbUrl;
  }

  await connect('mongodb://' + vault.mongoUsername + ':' + vault.mongoPassword + '@'+dbUrl+':27017/dienstplanapp?authSource=admin');
} 