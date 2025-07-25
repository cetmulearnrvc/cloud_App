import express from "express";
const land_router=express.Router();
<<<<<<< HEAD
import uploadMiddleware from "../multer/upload.js";
import { getNearbySIB, savelandData, searchByDate } from "../controller/sib_land_controller.js";
import uploadMiddleware from "../multer/upload.js";
=======
import upload from "../multer/upload.js";
import {  savelandData, searchByDate } from "../controller/sib_land_controller.js";
>>>>>>> 56962f93bb65c1eed0ca5ef5896f286f7b40f297

// import { searchByDate, searchByFileNo } from "../controller/search.controller.js";

land_router.post("/land/save", uploadMiddleware ,savelandData);

land_router.post("/land/getByDate",searchByDate);

//  land_router.post("/land/getnearby",getNearbySIB);


// pvr1_router.post("/pvr1/getByFile",searchByFileNo);

export default land_router;