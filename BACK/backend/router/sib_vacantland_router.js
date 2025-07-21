import express from 'express';
import {
  createValuation,
  getAllValuations,
  getValuationById,
  updateValuation,
  deleteValuation,
  searchByRefNo,
  findNearbyValuations,
  getValuationsByDate,
  getValuationsByPropertyType
} from '../controllers/sib_vacantland_controller.js';
import multer from 'multer';

const router = express.Router();

// Multer configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/land-valuations/'); // Specific directory for land valuations
  },
  filename: (req, file, cb) => {
    cb(null, `land-${Date.now()}-${file.originalname}`);
  }
});

const upload = multer({ storage });

// CRUD Routes
router.route('/')
  .post(upload.array('images'), createValuation)
  .get(getAllValuations);

router.route('/:id')
  .get(getValuationById)
  .put(upload.array('images'), updateValuation)
  .delete(deleteValuation);

// Specialized Routes
router.get('/search/refNo', searchByRefNo);
router.get('/nearby', findNearbyValuations);
router.get('/filter/date', getValuationsByDate);
router.get('/filter/property-type', getValuationsByPropertyType);

export default router;