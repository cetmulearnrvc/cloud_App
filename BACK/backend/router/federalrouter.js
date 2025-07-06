import express from "express";
const federal_router=express.Router();
import upload from "../multer/upload.js";
import { saveFederalData } from "../controller/federal_controller.js";

federal_router.post("/federal/save", upload.array("images") ,saveFederalData)

export default federal_router;