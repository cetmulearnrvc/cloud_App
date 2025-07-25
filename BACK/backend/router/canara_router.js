import express from "express";
const canara_router=express.Router();
import upload from "../multer/upload.js";
import { saveCanaraData, searchByDate } from "../controller/canara_controller.js";


canara_router.post("/canara/save", upload.array("images") ,saveCanaraData)

canara_router.post("/canara/getByDate",searchByDate)



export default canara_router;
