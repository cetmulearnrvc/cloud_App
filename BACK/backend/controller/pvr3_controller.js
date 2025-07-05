import pvr3 from "../models/pvr3_model.js";

export const savePVR3Data = async(req,res)=>{

    console.log("A post req received in pvr3");
    console.log(req.body); 
    

    
    
    const pvr3Data=req.body;
    pvr3Data.typo="pvr3"
    if(!pvr3Data.valuerName || !pvr3Data.valuerCode || !pvr3Data.fileNo || !pvr3Data.appointingAuthority || !pvr3Data.applicantName || !pvr3Data.address )
    {
        
        return res.status(400).json({success:false,message:"please enter all required fields"})
    }

    let imagesMeta = [];
        try {
            imagesMeta = JSON.parse(pvr3Data.images);
        } catch (err) {
            return res.status(400).json({
                success: false,
                message: "Invalid images metadata format"
            });
        }


     pvr3Data.images = [];
    if (req.files && req.files.length > 0) {
      for (let i = 0; i < req.files.length; i++) {
        const file = req.files[i];
        const meta = imagesMeta[i] || {};
        

        const imageData = {
          fileName: file.filename,
          filePath: file.path,
          latitude: meta.latitude ? parseFloat(meta.latitude) : null,
          longitude: meta.longitude ? parseFloat(meta.longitude) : null
        };

        console.log(imageData.latitude)
        pvr3Data.images.push(imageData);
      }
    } else {
      return res.status(400).json({ 
        success: false, 
        message: "Please add at least one image" 
      });
    }

    /* const newPVR3Data=new pvr3(pvr3Data); */

    

    try{
        const newPVR3Data=await pvr3.findOneAndUpdate({fileNo:pvr3Data.fileNo},
          { $set: pvr3Data }, 
          {
            upsert:true,
            new:true
          }
        )
        res.status(201).json({status:true,data:newPVR3Data})
    }
    catch(err)
    {
        res.status(500).json({status:false,message:"Server err in creating"})
    }
}