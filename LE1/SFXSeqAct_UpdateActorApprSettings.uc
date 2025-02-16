Class SFXSeqAct_UpdateActorApprSettings extends SequenceAction;

enum EActorTypeSettings
{
    Settings_Body,
    Settings_Headgear,
    Settings_Visor,
    Settings_FacePlate,
};

var(SFXSeqAct_UpdateActorApprSettings) EActorTypeSettings m_eSetting;
var(SFXSeqAct_UpdateActorApprSettings) EBioArmorType m_eArmorType;
var(SFXSeqAct_UpdateActorApprSettings) int m_nModel;
var(SFXSeqAct_UpdateActorApprSettings) int m_nMaterial;
var(SFXSeqAct_UpdateActorApprSettings) bool m_bLoaded;
var(SFXSeqAct_UpdateActorApprSettings) bool m_bHidden;

public function Activated()
{
    local Object ChkObject;
    local BioPawnChallengeScaledType ActorType;
    local Bio_Appr_Character_Settings Settings;
    
    foreach Targets(ChkObject, )
    {
        ActorType = BioPawnChallengeScaledType(ChkObject);
        if (ActorType == None)
        {
            ActorType = BioPawnChallengeScaledType(BioPawn(ChkObject).m_oBehavior.m_oActorType);
        }
        if (ActorType != None)
        {
            Settings = ActorType.m_oAppearanceSettings;
        }
        if (Settings == None)
        {
            Settings = Bio_Appr_Character_Settings(ChkObject);
        }
        UpdateSettings(Settings);
    }
}
public function UpdateSettings(Bio_Appr_Character_Settings Target)
{
    if (Target == None)
    {
        return;
    }
    switch (m_eSetting)
    {
        case EActorTypeSettings.Settings_Body:
            if (Target.m_oBodySettings != None)
            {
                Target.m_oBodySettings.m_eArmorType = m_eArmorType;
                Target.m_oBodySettings.m_nModelVariant = m_nModel;
                Target.m_oBodySettings.m_nMaterialConfig = m_nMaterial;
            }
            break;
        case EActorTypeSettings.Settings_Headgear:
            if (Target.m_oBodySettings.m_oHeadGearSettings != None)
            {
                Target.m_oBodySettings.m_oHeadGearSettings.m_eVisualOverride = m_eArmorType;
                Target.m_oBodySettings.m_oHeadGearSettings.m_nModelSpec = m_nModel;
                Target.m_oBodySettings.m_oHeadGearSettings.m_nMaterialConfig = m_nMaterial;
                Target.m_oBodySettings.m_bIsHeadGearLoaded = m_bLoaded;
                Target.m_oBodySettings.m_bIsHeadGearHidden = m_bHidden;
            }
            break;
        case EActorTypeSettings.Settings_Visor:
            if (Target.m_oBodySettings.m_oHeadGearSettings != None)
            {
                Target.m_oBodySettings.m_oHeadGearSettings.m_visor.m_nMeshIndex = m_nModel;
                Target.m_oBodySettings.m_oHeadGearSettings.m_visor.m_nMaterialIndex = m_nMaterial;
                Target.m_oBodySettings.m_oHeadGearSettings.m_visor.m_bIsLoaded = m_bLoaded;
                Target.m_oBodySettings.m_oHeadGearSettings.m_visor.m_bIsHidden = m_bHidden;
            }
            break;
        case EActorTypeSettings.Settings_FacePlate:
            if (Target.m_oBodySettings.m_oHeadGearSettings != None)
            {
                Target.m_oBodySettings.m_oHeadGearSettings.m_facePlate.m_nMeshIndex = m_nModel;
                Target.m_oBodySettings.m_oHeadGearSettings.m_facePlate.m_nMaterialIndex = m_nMaterial;
                Target.m_oBodySettings.m_oHeadGearSettings.m_facePlate.m_bIsLoaded = m_bLoaded;
                Target.m_oBodySettings.m_oHeadGearSettings.m_facePlate.m_bIsHidden = m_bHidden;
            }
            break;
        default:
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 255, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Model", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nModel', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Material", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nMaterial', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "ArmorType", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_eArmorType', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}