import express from "express";
const nearby_router=express.Router();
import { getNearby,saveToNearby } from "../controller/neabyLandValue_controller.js";
import uploadMiddleware from "../multer/upload.js";

nearby_router.post('/saveNearby/',saveToNearby);
nearby_router.post('/getNearby/',getNearby);

export default nearby_router;