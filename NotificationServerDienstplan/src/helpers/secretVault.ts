import * as dotenv from 'dotenv'
dotenv.config()

class Vault {
  serviceAccount: object = JSON.parse('' + process.env.SERVICE_ACCOUNT);
  apiPassword: string = '' + process.env.API_PASSWORD;
  mongoPassword: string = '' + process.env.MONGO_PASSWORD;
  mongoUsername: string = '' + process.env.MONGO_USERNAME;
  stage: string = process.env.NODE_ENV_STAGE || "";
  dbUrl: string = ''+process.env.DB_URL;
}

export const vault = new Vault();
