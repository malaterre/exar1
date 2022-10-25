<XProtocol> 
{
  <ID> 10 
  <Userversion> 4.5 
  
  <ParamMap.""> 
  {
    <PipeService."EVA"> 
    {
      <Class> "PipeLinkService@MrParc" 
      
      <ParamLong."POOLTHREADS">  { 1  }
      <ParamString."GROUP">  { "Calculation"  }
      <ParamLong."DATATHREADS">  { }
      <ParamLong."WATERMARK">  { }
      <ParamString."tdefaultEVAProt">  { "%SiemensEvaDefProt%/Breast/Breast.evp"  }
      <ParamBool."LiverSegmentation">  { }
      <ParamMap."LiverRegistration"> 
      {
        
        <ParamBool."EXECUTE">  { }
        <ParamBool."save_orig">  { "true"  }
        <ParamBool."NOT_MR_Abdomen_Dot_REG">  { "true"  }
      }
      <ParamMap."RequiredEMMContent"> 
      {
        
        <ParamBool."MR_Abdomen_Dot_REG">  { }
        <ParamBool."MR_Abdomen_Start_New_LiverRegistration">  { }
      }
      <ParamFunctor."BasicLiverReg"> 
      {
        <Class> "LiverRegistration@IceLiverRegistration" 
        
        <ParamBool."EXECUTE">  { }
        <ParamBool."save_orig">  { "true"  }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
      <ParamFunctor."MultiStepLiverReg"> 
      {
        <Class> "MultiStepLiverReg@IceLiverRegistration" 
        
        <ParamBool."EXECUTE">  { }
        <ParamBool."save_orig">  { "true"  }
        <ParamBool."HasTrigger">  { }
        <ParamString."BolusAgent">  { }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
      <ParamFunctor."T1mapFunctor"> 
      {
        <Class> "T1mapFunctor@IceImagePostProcFunctors" 
        
        <ParamBool."EXECUTE">  { }
        <ParamArray."FlipAngles_deg"> 
        {
          <Default> <ParamDouble.""> 
          {
            <Unit> "[deg]" 
            <Precision> 16 
          }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          
        }
        <ParamLong."Noise">  { 15  }
        <ParamString."PatPosition">  { }
        <ParamLong."SBCSOriginPositionZ">  { }
        <ParamBool."SaveOriginal">  { "true"  }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
      <ParamFunctor."T2mapFunctor"> 
      {
        <Class> "T2mapFunctor@IceImagePostProcFunctors" 
        
        <ParamBool."EXECUTE">  { }
        <ParamBool."T2">  { }
        <ParamBool."T2Star">  { }
        <ParamBool."R2">  { }
        <ParamBool."R2Star">  { }
        <ParamArray."TE"> 
        {
          <Default> <ParamLong.""> 
          {
            <Unit> "[us]" 
          }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          { }
          
        }
        <ParamLong."Noise">  { 15  }
        <ParamBool."SaveOriginal">  { "true"  }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
      <ParamFunctor."MotionCorr"> 
      {
        <Class> "MotionCorrDecorator@IceImagePostProcFunctors" 
        
        <ParamBool."EXECUTE">  { }
        <ParamString."image_type">  { "M"  }
        <ParamBool."save">  { }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
      <ParamFunctor."BreastMoCoFunctor"> 
      {
        <Class> "BreastMoCoFunctor@IceBreastMoCo" 
        
        <ParamBool."EXECUTE">  { }
        <ParamChoice."mode">  { <Limit> { "Fast" "high Quality" } "high Quality"  }
        <ParamLong."ref">  { 1  }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
      <ParamFunctor."Subtraction"> 
      {
        <Class> "Subtraction@IceImagePostProcFunctors" 
        
        <ParamBool."EXECUTE">  { }
        <ParamString."image_type">  { "M"  }
        <ParamBool."save">  { "true"  }
        <ParamLong."subtrahend">  { 1  }
        <ParamString."string_indices">  { }
        <ParamBool."indices">  { "false" "true" "true" "true" "true" "true" "true" "true" "true" "true"  "true" "true" "true" "true" "true" "true" "true" "true" "true" "true"  "true" "true" "true" "true" "true" "true" "true" "true" "true" "true"  }
        <ParamLong."subtraction_group">  { 1  }
        <ParamBool."auto">  { }
        <ParamLong."fact">  { 1  }
        <ParamLong."offs">  { }
        <ParamString."BolusAgent">  { }
        <ParamBool."save_orig">  { "true"  }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
      <ParamFunctor."StdDevFactory"> 
      {
        <Class> "StdDevFactory@IceImagePostProcFunctors" 
        
        <ParamBool."EXECUTE">  { }
        <ParamString."image_type">  { "M"  }
        <ParamBool."sag">  { }
        <ParamBool."cor">  { }
        <ParamBool."tra">  { }
        <ParamBool."time">  { }
        <ParamBool."save_orig">  { "true"  }
        <ParamBool."stddev">  { }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
      <ParamFunctor."MIPFactory"> 
      {
        <Class> "MIPFactory@IceImagePostProcFunctors" 
        
        <ParamBool."EXECUTE">  { }
        <ParamString."image_type">  { "M"  }
        <ParamBool."sag">  { }
        <ParamBool."cor">  { }
        <ParamBool."tra">  { }
        <ParamBool."time">  { }
        <ParamBool."radial">  { }
        <ParamLong."no_radial_views">  { 1  }
        <ParamChoice."axis_radial_views">  { <Limit> { "L-R" "A-P" "H-F" } "L-R"  }
        <ParamBool."save_orig">  { "true"  }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
      <ParamFunctor."MPRFactory"> 
      {
        <Class> "MPRFactory" 
        
        <ParamBool."EXECUTE">  { }
        <ParamString."image_type">  { "M"  }
        <ParamBool."sag">  { }
        <ParamBool."cor">  { }
        <ParamBool."tra">  { }
        <ParamBool."save_orig">  { "true"  }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
      <ParamBool."save_orig">  { "true"  }
      <ParamFunctor."BreastFunctor"> 
      {
        <Class> "BreastFunctor@IceBreastEvaluation" 
        
        <ParamBool."EXECUTE">  { }
        <ParamBool."CreateWashinMap">  { }
        <ParamBool."CreateWashinPeak">  { }
        <ParamChoice."WashinLUT">  { <Limit> { "GreenRed.pal" "Blue_Red_White.pal" "Greyscale.pal" "BrightGreyscale.pal" "Perfusion.pal" "HotMetal.pal" "ColdMetal.pal" } "GreenRed.pal"  }
        <ParamLong."WashinStart">  { 1  }
        <ParamLong."WashinEnd">  { 2  }
        <ParamBool."CreateWashoutMap">  { }
        <ParamChoice."WashoutLUT">  { <Limit> { "RedGreen.pal" "InvGrey.pal" "InvPerfusion.pal" "InvHotMetal.pal" "InvColdMetal.pal" "WhiteRedBlue.pal" } "RedGreen.pal"  }
        <ParamLong."WashoutStart">  { 1  }
        <ParamLong."WashoutEnd">  { 2  }
        <ParamBool."CreateTTPMap">  { }
        <ParamChoice."TTPLUT">  { <Limit> { "RedGreen.pal" "InvGrey.pal" "InvPerfusion.pal" "InvHotMetal.pal" "InvColdMetal.pal" "WhiteRedBlue.pal" } "RedGreen.pal"  }
        <ParamBool."CreatePEIMap">  { }
        <ParamChoice."PEILUT">  { <Limit> { "GreenRed.pal" "Blue_Red_White.pal" "Greyscale.pal" "BrightGreyscale.pal" "Perfusion.pal" "HotMetal.pal" "ColdMetal.pal" } "GreenRed.pal"  }
        <ParamBool."CreateMIPMap">  { }
        <ParamChoice."MIPLUT">  { <Limit> { "GreenRed.pal" "Greyscale.pal" "Perfusion.pal" "BrightGreyscale.pal" "HotMetal.pal" "ColdMetal.pal" "Blue_Red_White.pal" } "GreenRed.pal"  }
        <ParamBool."CreateCombinationMap">  { }
        <ParamChoice."CombineLUT">  { <Limit> { "GreenRed.pal" "Blue_Red_White.pal" "Greyscale.pal" "BrightGreyscale.pal" "Perfusion.pal" "HotMetal.pal" "ColdMetal.pal" } "GreenRed.pal"  }
        <ParamBool."AddWashinMap">  { }
        <ParamLong."WashinCenter">  { 850  }
        <ParamLong."WashinWindow">  { 800  }
        <ParamDouble."WashinWeight">  { <Precision> 1  1.0  }
        <ParamBool."AddWashoutMap">  { }
        <ParamLong."WashoutCenter">  { }
        <ParamLong."WashoutWindow">  { 400  }
        <ParamDouble."WashoutWeight">  { <Precision> 1  -1.0  }
        <ParamBool."AddTTPMap">  { }
        <ParamLong."TTPCenter">  { 150  }
        <ParamLong."TTPWindow">  { 50  }
        <ParamDouble."TTPWeight">  { <Precision> 1  -1.0  }
        <ParamBool."AddPEIMap">  { }
        <ParamLong."PEICenter">  { 3000  }
        <ParamLong."PEIWindow">  { 500  }
        <ParamDouble."PEIWeight">  { <Precision> 1  1.0  }
        <ParamBool."AddMIPMap">  { }
        <ParamLong."MIPCenter">  { 1500  }
        <ParamLong."MIPWindow">  { 500  }
        <ParamDouble."MIPWeight">  { <Precision> 1  1.0  }
        <ParamBool."AllTest">  { }
        <Method."ComputeImage">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Event."ImageReady">  { "uint64_t" "class IceAs &" "class MrPtr<class MiniHeader> &" "class ImageControl &"  }
        <Connection."c1">  { "ImageReady" "" "ComputeImage"  }
      }
    }
  }
}
