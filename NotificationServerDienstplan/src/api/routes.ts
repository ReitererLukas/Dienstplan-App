import { crud } from "@/db/crud";
import express, { Router, Request, Response, NextFunction } from "express";
import { deleteWrapper, patchWrapper, postWrapper } from "./wrapper";

const router: Router = express.Router();

postWrapper(router, "/register", async (req: Request, resp: Response, next: NextFunction) => {
  const id: any = await crud.insertDienstplan(req.body.dienstplan);
  resp.status(201).json({ id: id });
  next();
});

patchWrapper(router, "/update", async (req: Request, resp: Response, next: NextFunction) => {
  const id: any = await crud.updateDienstplan(req.body.id, req.body.dienstplan);
  resp.status(200).json({ id: id });
  next();
});

deleteWrapper(router, '/remove', async (req: Request, resp: Response, next: NextFunction) => {
  await crud.removeDienstplan(req.body.id);
  resp.status(200).end();
  next();
})


export default router;