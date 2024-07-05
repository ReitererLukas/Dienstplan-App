declare global {
    namespace NodeJS {
        interface ProcessEnv {
            NODE_ENV_STAGE: string;
            SERVICE_ACCOUNT: string;
            API_USERNAME: string;
            API_PASSWORD: string;
            MONGO_USERNAME: string;
            MONGO_PASSWORD: string;
            DB_HOST: string;
        }
    }
}

export {}
