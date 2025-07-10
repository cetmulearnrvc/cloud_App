import mongoose from "mongoose";

const NearbyLandSchema =new mongoose.Schema(
    {
         refNo: {
            type: String,
            required: true, 
            unique: true    // This creates a database index and ensures no two docs can have the same refNo
        },
        latitude: String,
        longitude: String,
        landValue : String,
        nameOfOwner: String,
        bankName: String,
    }
);

const NearbyLandValue = mongoose.model('NearbyLandValue',NearbyLandSchema);

export default NearbyLandValue;