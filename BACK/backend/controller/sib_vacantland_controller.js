import VacantLandValuation from "../models/vacantland_sib_model.js";
import mongoose from "mongoose";

// Create a new vacant land valuation
export const createValuation = async (req, res) => {
  try {
    const valuationData = req.body;
    
    // Process images if uploaded
    if (req.files && req.files.length > 0) {
      valuationData.images = req.files.map(file => ({
        fileName: file.filename,
        filePath: file.path,
        latitude: req.body.imageLatitude || null,
        longitude: req.body.imageLongitude || null
      }));
    }

    // Parse array fields if they come as strings
    if (typeof valuationData.boundaries === 'string') {
      valuationData.boundaries = JSON.parse(valuationData.boundaries);
    }
    if (typeof valuationData.dimensions === 'string') {
      valuationData.dimensions = JSON.parse(valuationData.dimensions);
    }
    if (typeof valuationData.landValuationDetails === 'string') {
      valuationData.landValuationDetails = JSON.parse(valuationData.landValuationDetails);
    }
    if (typeof valuationData.valuerComments === 'string') {
      valuationData.valuerComments = JSON.parse(valuationData.valuerComments);
    }

    const newValuation = new VacantLandValuation(valuationData);
    const savedValuation = await newValuation.save();

    res.status(201).json({
      success: true,
      message: "Valuation created successfully",
      data: savedValuation
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Failed to create valuation",
      error: error.message
    });
  }
};

// Get all vacant land valuations
export const getAllValuations = async (req, res) => {
  try {
    const valuations = await VacantLandValuation.find().sort({ createdAt: -1 });
    res.status(200).json({
      success: true,
      count: valuations.length,
      data: valuations
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Failed to fetch valuations",
      error: error.message
    });
  }
};

// Get a single valuation by ID
export const getValuationById = async (req, res) => {
  try {
    const { id } = req.params;
    
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid valuation ID"
      });
    }

    const valuation = await VacantLandValuation.findById(id);
    
    if (!valuation) {
      return res.status(404).json({
        success: false,
        message: "Valuation not found"
      });
    }

    res.status(200).json({
      success: true,
      data: valuation
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Failed to fetch valuation",
      error: error.message
    });
  }
};

// Update a valuation
export const updateValuation = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid valuation ID"
      });
    }

    // Process new images if uploaded
    if (req.files && req.files.length > 0) {
      const newImages = req.files.map(file => ({
        fileName: file.filename,
        filePath: file.path,
        latitude: req.body.imageLatitude || null,
        longitude: req.body.imageLongitude || null
      }));
      
      // Combine with existing images if needed
      updateData.images = updateData.images 
        ? [...JSON.parse(updateData.images), ...newImages] 
        : newImages;
    }

    // Parse array fields if they come as strings
    if (typeof updateData.boundaries === 'string') {
      updateData.boundaries = JSON.parse(updateData.boundaries);
    }
    if (typeof updateData.dimensions === 'string') {
      updateData.dimensions = JSON.parse(updateData.dimensions);
    }
    if (typeof updateData.landValuationDetails === 'string') {
      updateData.landValuationDetails = JSON.parse(updateData.landValuationDetails);
    }
    if (typeof updateData.valuerComments === 'string') {
      updateData.valuerComments = JSON.parse(updateData.valuerComments);
    }

    const updatedValuation = await VacantLandValuation.findByIdAndUpdate(
      id,
      updateData,
      { new: true, runValidators: true }
    );

    if (!updatedValuation) {
      return res.status(404).json({
        success: false,
        message: "Valuation not found"
      });
    }

    res.status(200).json({
      success: true,
      message: "Valuation updated successfully",
      data: updatedValuation
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Failed to update valuation",
      error: error.message
    });
  }
};

// Delete a valuation
export const deleteValuation = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        message: "Invalid valuation ID"
      });
    }

    const deletedValuation = await VacantLandValuation.findByIdAndDelete(id);

    if (!deletedValuation) {
      return res.status(404).json({
        success: false,
        message: "Valuation not found"
      });
    }

    res.status(200).json({
      success: true,
      message: "Valuation deleted successfully"
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Failed to delete valuation",
      error: error.message
    });
  }
};

// Search valuations by reference number
export const searchByRefNo = async (req, res) => {
  try {
    const { refNo } = req.query;

    if (!refNo) {
      return res.status(400).json({
        success: false,
        message: "Reference number is required"
      });
    }

    const valuations = await VacantLandValuation.find({ 
      refNo: { $regex: refNo, $options: 'i' } 
    });

    res.status(200).json({
      success: true,
      count: valuations.length,
      data: valuations
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Failed to search valuations",
      error: error.message
    });
  }
};

// Find nearby vacant land valuations
export const findNearbyValuations = async (req, res) => {
  try {
    const { latitude, longitude, maxDistance = 10 } = req.query; // maxDistance in km
    
    if (!latitude || !longitude) {
      return res.status(400).json({
        success: false,
        message: "Latitude and longitude are required"
      });
    }

    const lat = parseFloat(latitude);
    const lng = parseFloat(longitude);
    const distance = parseFloat(maxDistance);

    // Find valuations where at least one image has coordinates within the distance
    const valuations = await VacantLandValuation.find({
      images: {
        $elemMatch: {
          latitude: { $exists: true, $ne: null },
          longitude: { $exists: true, $ne: null }
        }
      }
    });

    // Filter and calculate distances
    const nearbyValuations = valuations.filter(valuation => {
      return valuation.images.some(image => {
        if (!image.latitude || !image.longitude) return false;
        
        const imgLat = parseFloat(image.latitude);
        const imgLng = parseFloat(image.longitude);
        const dist = calculateDistance(lat, lng, imgLat, imgLng);
        
        return dist <= distance;
      });
    }).map(valuation => {
      // Find the closest image coordinates
      const closestImage = valuation.images.reduce((closest, image) => {
        if (!image.latitude || !image.longitude) return closest;
        
        const imgLat = parseFloat(image.latitude);
        const imgLng = parseFloat(image.longitude);
        const dist = calculateDistance(lat, lng, imgLat, imgLng);
        
        return (!closest || dist < closest.distance) ? 
          { distance: dist, coordinates: { latitude: imgLat, longitude: imgLng } } : 
          closest;
      }, null);

      return {
        id: valuation._id,
        refNo: valuation.refNo,
        presentMarketValue: valuation.presentMarketValue,
        distance: closestImage.distance,
        coordinates: closestImage.coordinates,
        address: valuation.addressAsPerActual,
        valuationDate: valuation.dateOfValuation
      };
    }).sort((a, b) => a.distance - b.distance);

    res.status(200).json({
      success: true,
      count: nearbyValuations.length,
      data: nearbyValuations
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Failed to find nearby valuations",
      error: error.message
    });
  }
};

// Helper function to calculate distance between two coordinates (Haversine formula)
function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Earth's radius in km
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const a = 
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * 
    Math.sin(dLon/2) * Math.sin(dLon/2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return R * c;
}

function toRad(degrees) {
  return degrees * Math.PI / 180;
}

// Get valuations by date range
export const getValuationsByDate = async (req, res) => {
  try {
    const { startDate, endDate } = req.query;
    
    if (!startDate || !endDate) {
      return res.status(400).json({
        success: false,
        message: "Both startDate and endDate are required"
      });
    }

    const start = new Date(startDate);
    const end = new Date(endDate);
    end.setHours(23, 59, 59, 999); // Include entire end day

    const valuations = await VacantLandValuation.find({
      dateOfValuation: {
        $gte: start,
        $lte: end
      }
    }).sort({ dateOfValuation: -1 });

    res.status(200).json({
      success: true,
      count: valuations.length,
      data: valuations
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Failed to fetch valuations by date",
      error: error.message
    });
  }
};

// Get valuations by property type
export const getValuationsByPropertyType = async (req, res) => {
  try {
    const { propertyType } = req.query;
    
    if (!propertyType) {
      return res.status(400).json({
        success: false,
        message: "Property type is required"
      });
    }

    const valuations = await VacantLandValuation.find({
      propertyType: { $regex: propertyType, $options: 'i' }
    });

    res.status(200).json({
      success: true,
      count: valuations.length,
      data: valuations
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Failed to fetch valuations by property type",
      error: error.message
    });
  }
};