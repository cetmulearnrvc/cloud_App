import mongoose from "mongoose";

export const connectDB=async()=>{
    try{
        const conn=await mongoose.connect(process.env.MONGO_URL);
        console.log("Connected to DB");
    }
    catch(err)
    {
        console.log(err.message)
        process.exit(1)
    }
}