declare global {
    namespace NodeJS {
        interface ProcessEnv {
            API_USERNAME: string;
            API_PASSWORD: string;
            MONGO_PASSWORD: string;
            SERVICE_ACCOUNT: string;
            NODE_ENV_STAGE: string;
            DB_HOST: string;
        }
    }
}

export {}
