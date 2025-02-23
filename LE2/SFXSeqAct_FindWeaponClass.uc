Class SFXSeqAct_FindWeaponClass extends SequenceAction;

var(SFXSeqAct_FindWeaponClass) string m_sWeaponPath;
var(SFXSeqAct_FindWeaponClass) Class<SFXWeapon> m_oWeaponClass;

public function Activated()
{
    m_oWeaponClass = FindWeapon(m_sWeaponPath);
}
public function Class<SFXWeapon> FindWeapon(string Path)
{
    local string FullPath;
    local bool bValid;
    
    FullPath = Path;
    bValid = Class'SFXEngine'.static.IsSeekFreeObjectSupported(FullPath);
    if (!bValid)
    {
        FullPath = "SFXGameContent_Inventory." $ Path;
        bValid = Class'SFXEngine'.static.IsSeekFreeObjectSupported(FullPath);
    }
    if (bValid)
    {
        return Class<SFXWeapon>(Class'SFXEngine'.static.LoadSeekFreeObject(FullPath, Class'Class'));
    }
    else
    {
        return None;
    }
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
                      PropertyName = 'm_sWeaponPath', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Weapon", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_oWeaponClass', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 255, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}
