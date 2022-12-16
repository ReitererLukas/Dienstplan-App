import { vault } from "@/helpers/secretVault";
import { NextFunction, Request, Response } from "express";

export function authenticate(req: Request, resp: Response, next: NextFunction) {
  if (req.headers.authorization == vault.apiPassword) {
    next();
  } else {
    resp.status(401).end();
  }
}

export function errorHandler(err: Error, req: Request, resp: Response, next: NextFunction) {
  console.error(err.stack);
  resp.status(400).end();
}