import express from "express";

const router=express.Router();

<<<<<<< HEAD
import uploadMiddleware from "../multer/upload.js";
import { getNearbyPVR3, savePVR3Data, searchByDate } from "../controller/pvr3_controller.js";
import uploadMiddleware from "../multer/upload.js";
=======
import upload from "../multer/upload.js";
import { savePVR3Data, searchByDate } from "../controller/pvr3_controller.js";
>>>>>>> 56962f93bb65c1eed0ca5ef5896f286f7b40f297

router.post("/pvr3/save",uploadMiddleware,savePVR3Data)

router.post("/pvr3/getByDate",searchByDate)

// router.post("/pvr3/getnearby",getNearbyPVR3)

export default router;