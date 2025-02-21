Class SFXSeqAct_FindImage extends SequenceAction;

var(SFXSeqAct_FindImage) string m_sImagePath;
var(SFXSeqAct_FindImage) Texture2D m_oImage;

public function Activated()
{
    m_oImage = Class'SFXPlotTreasure'.static.FindImage(m_sImagePath);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Path", 
                      ExpectedType = Class'SeqVar_String', 
                      LinkVar = 'None', 
                      PropertyName = 'm_sImagePath', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Image", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_oImage', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 255, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}
