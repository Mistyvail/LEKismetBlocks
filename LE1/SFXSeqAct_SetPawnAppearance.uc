Class SFXSeqAct_SetPawnAppearance extends SequenceAction;

struct Head 
{
    var SkeletalMesh Mesh;
    var array<MaterialInterface> Materials;
    var BioMorphFace MorphHead;
};
struct Accessory 
{
    var SkeletalMesh Mesh;
    var array<MaterialInterface> Materials;
};
struct MaterialParameters 
{
    var array<VectorParameterValue> VectorParameterValues;
    var array<ScalarParameterValue> ScalarParameterValues;
    var array<TextureParameterValue> TextureParameterValues;
};

var(SFXSeqAct_SetPawnAppearance) Head m_HeadMesh;
var(SFXSeqAct_SetPawnAppearance) array<Accessory> m_aoAccessoryMeshes;
var(SFXSeqAct_SetPawnAppearance) SkeletalMesh m_oMesh;
var(SFXSeqAct_SetPawnAppearance) SkeletalMesh m_oHairMesh;
var(SFXSeqAct_SetPawnAppearance) SkeletalMesh m_oHeadGearMesh;
var(SFXSeqAct_SetPawnAppearance) SkeletalMesh m_oVisorMesh;
var(SFXSeqAct_SetPawnAppearance) SkeletalMesh m_oFacePlateMesh;
var(SFXSeqAct_SetPawnAppearance) array<MaterialInterface> m_aoMeshMaterials;
var(SFXSeqAct_SetPawnAppearance) array<MaterialInterface> m_aoHairMaterials;
var(SFXSeqAct_SetPawnAppearance) array<MaterialInterface> m_aoHeadgearMaterials;
var(SFXSeqAct_SetPawnAppearance) array<MaterialInterface> m_aoVisorMaterials;
var(SFXSeqAct_SetPawnAppearance) array<MaterialInterface> m_aoFacePlateMaterials;
var(SFXSeqAct_SetPawnAppearance) MaterialParameters m_MaterialParameters;
var(SFXSeqAct_SetPawnAppearance) bool m_bHideHead;
var(SFXSeqAct_SetPawnAppearance) bool m_bHideHair;
var(SFXSeqAct_SetPawnAppearance) bool m_bHideHeadgear;
var(SFXSeqAct_SetPawnAppearance) bool m_bHideVisor;
var(SFXSeqAct_SetPawnAppearance) bool m_bHideFacePlate;
var(SFXSeqAct_SetPawnAppearance) bool m_bHideAccessories;

public function Activated()
{
    local Object ChkObject;
    local BioPawn Pawn;
    local SkeletalMeshComponent MeshCmpt;
    local int idx;
    
    foreach Targets(ChkObject, )
    {
        Pawn = BioPawn(ChkObject);
        if (Pawn != None)
        {
            if (m_oMesh != None)
            {
                ResetSkeletalComponent(Pawn, Pawn.Mesh, m_oMesh, m_aoMeshMaterials, 0);
                UpdateBoneMap(Pawn);
            }
            if (m_HeadMesh.Mesh != None)
            {
                ResetSkeletalComponent(Pawn, Pawn.m_oHeadMesh, m_HeadMesh.Mesh, m_HeadMesh.Materials, 1);
                Pawn.m_oBehavior.m_oAppearanceType.m_oMorphFace = m_HeadMesh.MorphHead;
            }
            if (m_oHairMesh != None)
            {
                ResetSkeletalComponent(Pawn, Pawn.m_oHairMesh, m_oHairMesh, m_aoHairMaterials, 2);
            }
            if (m_oHeadGearMesh != None)
            {
                ResetSkeletalComponent(Pawn, Pawn.m_oHeadGearMesh, m_oHeadGearMesh, m_aoHeadgearMaterials, 3);
            }
            if (m_oVisorMesh != None)
            {
                ResetSkeletalComponent(Pawn, Pawn.m_oVisorMesh, m_oVisorMesh, m_aoVisorMaterials, 4);
            }
            if (m_oFacePlateMesh != None)
            {
                ResetSkeletalComponent(Pawn, Pawn.m_oFacePlateMesh, m_oFacePlateMesh, m_aoFacePlateMaterials, 5);
            }
            for (idx = 0; idx < m_aoAccessoryMeshes.Length; ++idx)
            {
                if (m_aoAccessoryMeshes[idx].Mesh != None)
                {
                    ResetSkeletalComponent(Pawn, Pawn.m_aoAccessories[idx], m_aoAccessoryMeshes[idx].Mesh, m_aoAccessoryMeshes[idx].Materials, 6);
                }
            }
            HideSkeletalComponent(Pawn, Pawn.m_oHeadMesh, m_bHideHead);
            HideSkeletalComponent(Pawn, Pawn.m_oHairMesh, m_bHideHair);
            HideSkeletalComponent(Pawn, Pawn.m_oHeadGearMesh, m_bHideHeadgear);
            HideSkeletalComponent(Pawn, Pawn.m_oVisorMesh, m_bHideVisor);
            HideSkeletalComponent(Pawn, Pawn.m_oFacePlateMesh, m_bHideFacePlate);
            HideSkeletalComponent(Pawn, , , m_bHideAccessories);
            Pawn.ApplyMaterialParameters(Pawn.m_oBehavior.m_oAppearanceType.m_oMorphFace.m_oMaterialOverrides);
            foreach Pawn.ComponentList(Class'SkeletalMeshComponent', MeshCmpt)
            {
                if (MeshCmpt != None)
                {
                    for (idx = 0; idx < MeshCmpt.Materials.Length; idx++)
                    {
                        SetMaterialParameters(MeshCmpt.Materials[idx]);
                    }
                }
            }
        }
    }
}
public function ResetSkeletalComponent(BioPawn InPawn, SkeletalMeshComponent InComponent, SkeletalMesh InMesh, array<MaterialInterface> InMaterials, int Identifier)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    InPawn.ReattachComponent(InComponent);
    if (InComponent == None && Identifier != 0)
    {
        InComponent = CreateSkeletalComponent(InPawn, Identifier);
    }
    for (idx = 0; idx < InComponent.GetNumElements(); ++idx)
    {
        InComponent.SetMaterial(idx, None);
    }
    InComponent.SetSkeletalMesh(InMesh);
    for (idx = 0; idx < InComponent.SkeletalMesh.Materials.Length; ++idx)
    {
        MIC = new (InComponent) Class'MaterialInstanceConstant';
        MIC.SetParent(InComponent.SkeletalMesh.Materials[idx]);
        if (InMaterials[idx] != None)
        {
            MIC.SetParent(InMaterials[idx]);
        }
        InComponent.SetMaterial(idx, MIC);
    }
}
public function SkeletalMeshComponent CreateSkeletalComponent(BioPawn InPawn, int Identifier)
{
    local SkeletalMeshComponent NewCmpt;
    
    NewCmpt = new (Self) Class'SkeletalMeshComponent';
    NewCmpt.bTransformFromAnimParent = 1;
    NewCmpt.bUseOnePassLightingOnTranslucency = TRUE;
    NewCmpt.SetParentAnimComponent(InPawn.Mesh);
    NewCmpt.SetShadowParent(InPawn.Mesh);
    NewCmpt.SetLightEnvironment(InPawn.m_pLightEnvComponent);
    InPawn.AttachComponent(NewCmpt);
    switch (Identifier)
    {
        case 1:
            NewCmpt.bOverrideParentSkeleton = TRUE;
            NewCmpt.nmOverrideStartBoneName = 'headBase';
            InPawn.m_oHeadMesh = NewCmpt;
            break;
        case 2:
            InPawn.m_oHairMesh = NewCmpt;
            break;
        case 3:
            InPawn.m_oHeadGearMesh = NewCmpt;
            break;
        case 4:
            InPawn.m_oVisorMesh = NewCmpt;
            break;
        case 5:
            InPawn.m_oFacePlateMesh = NewCmpt;
            break;
        case 6:
            InPawn.m_aoAccessories.AddItem(NewCmpt);
            break;
        default:
    }
    return NewCmpt;
}
public function SetMaterialParameters(MaterialInterface Material)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    MIC = MaterialInstanceConstant(Material);
    if (MIC != None)
    {
        for (idx = 0; idx < m_MaterialParameters.VectorParameterValues.Length; ++idx)
        {
            MIC.SetVectorParameterValue(m_MaterialParameters.VectorParameterValues[idx].ParameterName, m_MaterialParameters.VectorParameterValues[idx].ParameterValue);
        }
        for (idx = 0; idx < m_MaterialParameters.ScalarParameterValues.Length; ++idx)
        {
            MIC.SetScalarParameterValue(m_MaterialParameters.ScalarParameterValues[idx].ParameterName, m_MaterialParameters.ScalarParameterValues[idx].ParameterValue);
        }
        for (idx = 0; idx < m_MaterialParameters.TextureParameterValues.Length; ++idx)
        {
            MIC.SetTextureParameterValue(m_MaterialParameters.TextureParameterValues[idx].ParameterName, m_MaterialParameters.TextureParameterValues[idx].ParameterValue);
        }
    }
}
public function UpdateBoneMap(BioPawn InPawn)
{
    local SkeletalMeshComponent MeshCmpt;
    local int idx;
    
    foreach InPawn.ComponentList(Class'SkeletalMeshComponent', MeshCmpt)
    {
        if (MeshCmpt != None && MeshCmpt != InPawn.Mesh)
        {
            MeshCmpt.UpdateParentBoneMap();
        }
    }
}
public function HideSkeletalComponent(BioPawn InPawn, optional SkeletalMeshComponent InComponent, optional bool bPart, optional bool bAccessories)
{
    local SkeletalMeshComponent Hair;
    local SkeletalMeshComponent Headgear;
    local SkeletalMeshComponent Visor;
    local SkeletalMeshComponent FacePlate;
    local SkeletalMeshComponent Accessory;
    local int idx;
    
    if (InComponent != None && bPart)
    {
        InPawn.DetachComponent(InComponent);
    }
    if (bAccessories)
    {
        Hair = InPawn.m_oHairMesh;
        Headgear = InPawn.m_oHeadGearMesh;
        Visor = InPawn.m_oVisorMesh;
        FacePlate = InPawn.m_oFacePlateMesh;
        for (idx = 0; idx < InPawn.m_aoAccessories.Length; ++idx)
        {
            Accessory = InPawn.m_aoAccessories[idx];
            if (Accessory != Hair && Accessory != Headgear && Accessory != Visor && Accessory != FacePlate)
            {
                InPawn.DetachComponent(Accessory);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Pawn", 
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
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_oMesh', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 255, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Hair", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_oHairMesh', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 255, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Headgear", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_oHeadGearMesh', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 255, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Visor", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_oVisorMesh', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 255, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "FacePlate", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_oFacePlateMesh', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 255, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}