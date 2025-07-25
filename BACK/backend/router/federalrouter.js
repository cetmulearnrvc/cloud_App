import express from "express";
const federal_router=express.Router();
<<<<<<< HEAD
<<<<<<< HEAD
import uploadMiddleware from "../multer/upload.js";
=======
>>>>>>> ddf1111d69185a50a56bde3a891e828c23c4dc86
import { getNearbyfederal, saveFederalData, searchByDate } from "../controller/federal_controller.js";
import uploadMiddleware from "../multer/upload.js";
=======
import upload from "../multer/upload.js";
import {  saveFederalData, searchByDate } from "../controller/federal_controller.js";
>>>>>>> 56962f93bb65c1eed0ca5ef5896f286f7b40f297

federal_router.post("/federal/save", uploadMiddleware ,saveFederalData)

// federal_router.post("/federal/getnearby",getNearbyfederal)

federal_router.post("/federal/getByDate",searchByDate)

export default federal_router;