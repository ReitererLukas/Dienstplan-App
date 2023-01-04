import { crud } from "@/db/crud";
import express, { Router, Request, Response, NextFunction } from "express";
import { deleteWrapper, patchWrapper, postWrapper } from "./wrapper";
import { HydratedDocument } from "mongoose";
import { IDienstplan } from "@/db/models";
import { dpHasher } from "@/helpers";

const router: Router = express.Router();

postWrapper(router, "/register", async (req: Request, resp: Response, next: NextFunction) => {
  const id: any = await crud.insertDienstplan(req.body.dienstplan);
  resp.status(201).json({ id: id });
  next();
});

patchWrapper(router, "/update/:id", async (req: Request, resp: Response, next: NextFunction) => {
  let data = req.body.dienstplan;
  if (req.body.dienstplan == null) {
    const dienstplan: HydratedDocument<IDienstplan> = await crud.findOneDienstplanNullSafe({ _id: req.params.id });
    const hash = await dpHasher(dienstplan.dienstplanLink);
    if(hash) {
      data = hash
    }
  }
  const id: number = await crud.updateDienstplan(req.body.id, data);
  resp.status(200).json({ dienstplan: id });
  next();
});

deleteWrapper(router, '/remove/:id', async (req: Request, resp: Response, next: NextFunction) => {
  await crud.removeDienstplan(req.params.id);
  resp.status(200).end();
  next();
});

patchWrapper(router, "/refreshTimer/:id", async (req: Request, resp: Response, next: NextFunction) => {
  let res = await crud.updateTimerOfDienstplan(req.params.id);
  if(res) {
    resp.status(200).end();
  } else {
    resp.status(404).end();
  }
  next()
});


export default router;