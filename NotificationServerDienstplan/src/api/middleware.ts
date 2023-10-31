import { decode } from 'base-64'

import { vault } from "@/helpers/vault";
import { NextFunction, Request, Response } from "express";

export function authenticate(req: Request, resp: Response, next: NextFunction) {
  if (req.headers.authorization != null && req.headers.authorization.startsWith("Basic ")) {
    const token: string = req.headers.authorization.substring(6);
    const decodedToken: string[] = decode(token).split(":");
    
    if(decodedToken[0] == vault.apiUsername && decodedToken[1] == vault.apiPassword) {
      next();
    } else {
      resp.status(401).end();
    }
  } else {
    resp.status(401).end();
  }
}

export function errorHandler(err: Error, req: Request, resp: Response, next: NextFunction) {
  console.error(err.stack);
  resp.status(400).end();
}