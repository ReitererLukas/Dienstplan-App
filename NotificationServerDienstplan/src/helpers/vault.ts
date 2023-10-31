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
    this.stage = process.env.NODE_ENV_STAGE || "DEV";
    this.serviceAccount = JSON.parse(this.readSecretFile("SERVICE_ACCOUNT"));
    this.apiUsername = this.readSecretFile("API_USERNAME");
    this.apiPassword = this.readSecretFile("API_PASSWORD");
    this.mongoUsername = "dienstplaner";
    this.mongoPassword = this.readSecretFile("MONGO_PASSWORD");
    this.dbHost = '' + process.env.DB_HOST;

    console.log(this.stage)
    console.log(this.serviceAccount)
    console.log(this.apiUsername)
    console.log(this.apiPassword)
    console.log(this.mongoUsername)
    console.log(this.mongoPassword)
    console.log(this.dbHost)
  }

  readSecretFile(name: string): string {
    if (this.stage == "DEV") {
      return "" + process.env[name];
    }
    console.log(process.env[name + "_FILE"])
    return readFileSync(""+process.env[name + "_FILE"], "utf-8")
  }

}

export const vault = new Vault();
