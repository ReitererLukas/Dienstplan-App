import * as dotenv from 'dotenv'
import { readFileSync } from 'fs'
dotenv.config()

class Vault {
  serviceAccount: object;
  apiUsername: string;
  apiPassword: string;
  mongoPassword: string;
  mongoUsername: string;
  stage: string;
  dbHost: string;


  constructor() {
    console.log(process.env);

    this.stage = process.env.NODE_ENV_STAGE || "DEV";
    this.serviceAccount = JSON.parse(process.env.SERVICE_ACCOUNT!);
    this.apiUsername = process.env.API_USERNAME!;
    this.apiPassword = process.env.API_PASSWORD!;
    this.mongoUsername = process.env.MONGO_USERNAME!;
    this.mongoPassword = process.env.MONGO_PASSWORD!;
    this.dbHost = process.env.DB_HOST;
  }

  readSecretFile(name: string): string {
    return readFileSync(""+process.env[name + "_FILE"], "utf-8")
  }

}

export const vault = new Vault();
