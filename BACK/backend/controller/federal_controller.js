import federal from "../models/federal_model.js";

export const saveFederalData = async(req,res)=>{

    console.log("A post req received");
    console.log(req.body); 
    

    
    
    const federalData=req.body;
    if(!federalData.applicantNameAndBranchDetails || !federalData.ownerOfTheProperty)
    {
        return res.status(400).json({success:false,message:"please enter all required fields"})
    }

    


     federalData.images = [];
    if (req.files && req.files.length > 0) {
      for (let i = 0; i < req.files.length; i++) {
        const file = req.files[i];
        

        const imageData = {
          fileName: file.filename,
          filePath: file.path
        };

        federalData.images.push(imageData);
      }
    }

    /* const newfederalData=new federal(federalData); */

    

    try{
        const newfederalData = await federal.findOneAndUpdate(
          { ownerOfTheProperty: federalData.ownerOfTheProperty },
          { 
              $set: { ...federalData, images: undefined }, // Set all other fields except images
              $push: { images: { $each: federalData.images } } // Append new images to array
          },
          {
              upsert: true,
              new: true
          }
      );
      res.status(201).json({status:true, data:newfederalData});
    }
    catch(err)
    {
        res.status(500).json({status:false,message:"Server err in creating"})
    }
}
