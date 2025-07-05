import express from "express";

const router=express.Router();

import upload from "../multer/upload.js";
import { savePVR3Data } from "../controller/pvr3_controller.js";

router.post("/pvr3/save",upload.array("images"),savePVR3Data)

export default router;