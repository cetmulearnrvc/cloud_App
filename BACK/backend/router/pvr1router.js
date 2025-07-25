import express from "express";
const pvr1_router=express.Router();
<<<<<<< HEAD
import { savePVR1Data , getNearbyPVR1 } from "../controller/pvr1_controller.js";
import uploadMiddleware from "../multer/upload.js";
=======
import { savePVR1Data } from "../controller/pvr1_controller.js";
import upload from "../multer/upload.js";
>>>>>>> 56962f93bb65c1eed0ca5ef5896f286f7b40f297
import { searchByDate, searchByFileNo } from "../controller/search.controller.js";
import uploadMiddleware from "../multer/upload.js";

pvr1_router.post("/pvr1/generatepdf", uploadMiddleware ,savePVR1Data)

// pvr1_router.post("/pvr1/getnearby",getNearbyPVR1)

pvr1_router.post("/pvr1/getByDate",searchByDate)

pvr1_router.post("/pvr1/getByFile",searchByFileNo);

export default pvr1_router;