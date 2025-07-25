import express from "express";

const router=express.Router();

import uploadMiddleware from "../multer/upload.js";
import { getNearbyPVR3, savePVR3Data, searchByDate } from "../controller/pvr3_controller.js";
import uploadMiddleware from "../multer/upload.js";

router.post("/pvr3/save",uploadMiddleware,savePVR3Data)

router.post("/pvr3/getByDate",searchByDate)

router.post("/pvr3/getnearby",getNearbyPVR3)

export default router;