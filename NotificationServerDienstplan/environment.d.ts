declare global {
    namespace NodeJS {
        interface ProcessEnv {
            API_PASSWORD: string;
            MONGO_PASSWORD: string;
            MONGO_USERNAME: string;
            SERVICE_ACCOUNT: string;
            NODE_ENV_STAGE: string;
            DB_URL: string;
        }
    }
}

export {}
