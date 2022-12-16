
import { Router, Request, Response, NextFunction } from "express";

async function catchBlock(controller: Function, req: Request, resp: Response, next: NextFunction) {
  try {
    await controller(req, resp, next);
  } catch (error) {
    next(error);
  }
}

export function getWrapper(router: Router, path: string, controller: Function, middleware: any = null) {
  const fn = (req: Request, resp: Response, next: NextFunction) => catchBlock(controller, req, resp, next);
  if (middleware != null) {
    router.get(path, middleware, fn);
  } else {
    router.get(path, fn);
  }
}

export function patchWrapper(router: Router, path: string, controller: Function, middleware: any = null) {
  const fn = (req: Request, resp: Response, next: NextFunction) => catchBlock(controller, req, resp, next);
  if (middleware != null) {
    router.patch(path, middleware, fn);
  } else {
    router.patch(path, fn);
  }
}


export function deleteWrapper(router: Router, path: string, controller: Function, middleware: any = null) {
  const fn = (req: Request, resp: Response, next: NextFunction) => catchBlock(controller, req, resp, next);
  if (middleware != null) {
    router.delete(path, middleware, fn);
  } else {
    router.delete(path, fn);
  }
}

export function postWrapper(router: Router, path: string, controller: Function, middleware: any = null) {
  const fn = (req: Request, resp: Response, next: NextFunction) => catchBlock(controller, req, resp, next);
  if (middleware != null) {
    router.post(path, middleware, fn);
  } else {
    router.post(path, fn);
  }
}