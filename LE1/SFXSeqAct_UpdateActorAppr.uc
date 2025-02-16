Class SFXSeqAct_UpdateActorAppr extends SequenceAction;

struct VisorAppr 
{
    var SkeletalMesh m_oMesh;
    var array<MaterialInterface> m_aoMaterial;
};
struct FacePlateAppr 
{
    var SkeletalMesh m_oMesh;
    var array<MaterialInterface> m_aoMaterial;
    var bool m_bHideVisor;
};
enum EActorTypeAppearance
{
    Appearance_Body,
    Appearance_Headgear,
    Appearance_Visor,
    Appearance_FacePlate,
};

var(SFXSeqAct_UpdateActorAppr) EActorTypeAppearance m_eAppearance;
var(SFXSeqAct_UpdateActorAppr) EBioArmorType m_eArmorType;
var(SFXSeqAct_UpdateActorAppr) string m_sMeshPackage;
var(SFXSeqAct_UpdateActorAppr) string m_sMaterialPackage;
var(SFXSeqAct_UpdateActorAppr) array<ModelVariation> m_aVariations;
var(SFXSeqAct_UpdateActorAppr) array<BioHeadGearAppearanceModelSpec> m_aHeadgear;
var(SFXSeqAct_UpdateActorAppr) VisorAppr m_visor;
var(SFXSeqAct_UpdateActorAppr) FacePlateAppr m_facePlate;
var(SFXSeqAct_UpdateActorAppr) bool m_bVerifyPackage;

public function Activated()
{
    local Object ChkObject;
    local BioPawnChallengeScaledType ActorType;
    local Bio_Appr_Character Appearance;
    
    foreach Targets(ChkObject, )
    {
        ActorType = BioPawnChallengeScaledType(ChkObject);
        if (ActorType == None)
        {
            ActorType = BioPawnChallengeScaledType(BioPawn(ChkObject).m_oBehavior.m_oActorType);
        }
        if (ActorType != None)
        {
            Appearance = ActorType.m_oAppearance;
        }
        if (Appearance == None)
        {
            Appearance = Bio_Appr_Character(ChkObject);
        }
        UpdateAppr(Appearance);
    }
}
public function UpdateAppr(Bio_Appr_Character Target)
{
    local Bio_Appr_Character_Body Body;
    local Bio_Appr_Character_HeadGear Headgear;
    local int I;
    
    if (Target == None)
    {
        return;
    }
    Body = Target.Body;
    Headgear = Body.m_oHeadGearAppearance;
    switch (m_eAppearance)
    {
        case EActorTypeAppearance.Appearance_Body:
            if (Body != None)
            {
                for (I = 0; I < Body.Armor.Length; ++I)
                {
                    if (int(Body.Armor[I].ArmorType) == int(m_eArmorType))
                    {
                        if (ValidPackage(m_eArmorType, m_sMeshPackage, Body.AppearancePrefix, "MDL"))
                        {
                            if (m_sMeshPackage ~= m_sMaterialPackage || ValidPackage(m_eArmorType, m_sMaterialPackage, Body.AppearancePrefix, "MAT_1a"))
                            {
                                Body.Armor[I].m_meshPackageName = Name(m_sMeshPackage);
                                Body.Armor[I].m_materialPackageName = Name(m_sMaterialPackage);
                                Body.Armor[I].Variations = m_aVariations;
                            }
                        }
                        break;
                    }
                }
            }
            break;
        case EActorTypeAppearance.Appearance_Headgear:
            if (Headgear != None)
            {
                if (ValidPackage(m_eArmorType, m_sMeshPackage, string(Headgear.m_nmPrefix), "MDL"))
                {
                    Headgear.m_aArmorSpec[int(m_eArmorType)].m_nmPackage = Name(m_sMeshPackage);
                    Headgear.m_aArmorSpec[int(m_eArmorType)].m_aModelSpec = m_aHeadgear;
                }
            }
            break;
        case EActorTypeAppearance.Appearance_Visor:
            if (Headgear != None)
            {
                Headgear.m_apVisorMesh[0] = m_visor.m_oMesh;
                if (m_visor.m_oMesh != None && m_visor.m_aoMaterial.Length == 0)
                {
                    m_visor.m_aoMaterial = m_visor.m_oMesh.Materials;
                }
                Headgear.m_apVisorMaterial = m_visor.m_aoMaterial;
            }
            break;
        case EActorTypeAppearance.Appearance_FacePlate:
            if (Headgear != None)
            {
                Headgear.m_aFacePlateMeshSpec[0].m_pMesh = m_facePlate.m_oMesh;
                Headgear.m_aFacePlateMeshSpec[0].m_bHidesVisor = m_facePlate.m_bHideVisor;
                if (m_facePlate.m_oMesh != None && m_facePlate.m_aoMaterial.Length == 0)
                {
                    m_facePlate.m_aoMaterial = m_facePlate.m_oMesh.Materials;
                }
                Headgear.m_apFacePlateMaterial = m_facePlate.m_aoMaterial;
            }
            break;
        default:
    }
}
public function bool ValidPackage(EBioArmorType Type, string Package, string Prefix, string Target)
{
    local string FullPath;
    local string Variation;
    local Object Obj;
    local int I;
    
    if (!m_bVerifyPackage)
    {
        return TRUE;
    }
    for (I = 1; I <= 3; ++I)
    {
        Variation = ArmorType(Type) $ Letter(I);
        FullPath = Package $ "." $ Variation $ "." $ Prefix $ "_" $ Variation $ "_" $ Target;
        Obj = DynamicLoadObject(FullPath, Class'Object');
        if (Obj != None)
        {
            break;
        }
        if (I == 3)
        {
            LogInternal("Could not load from " $ Package, );
        }
    }
    return Obj != None;
}
public function string ArmorType(EBioArmorType Type)
{
    switch (Type)
    {
        case EBioArmorType.ARMOR_TYPE_NONE:
            return "NKD";
            break;
        case EBioArmorType.ARMOR_TYPE_CLOTHING:
            return "CTH";
            break;
        case EBioArmorType.ARMOR_TYPE_LIGHT:
            return "LGT";
            break;
        case EBioArmorType.ARMOR_TYPE_MEDIUM:
            return "MED";
            break;
        case EBioArmorType.ARMOR_TYPE_HEAVY:
            return "HVY";
            break;
        default:
    }
    return "";
}
public function string Letter(int Number)
{
    switch (Number)
    {
        case 1:
            return "a";
        case 2:
            return "b";
        case 3:
            return "c";
        case 4:
            return "d";
        case 5:
            return "e";
        case 6:
            return "f";
        default:
    }
    return "a";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bVerifyPackage = TRUE
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
                      LinkDesc = "Mesh", 
                      ExpectedType = Class'SeqVar_String', 
                      LinkVar = 'None', 
                      PropertyName = 'm_sMeshPackage', 
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
                      ExpectedType = Class'SeqVar_String', 
                      LinkVar = 'None', 
                      PropertyName = 'm_sMaterialPackage', 
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