Class SFXSeqAct_SetActorAppearance extends SequenceAction;

struct Head 
{
    var SkeletalMesh Mesh;
    var array<MaterialInterface> Materials;
    var BioMorphFace MorphHead;
};
struct MaterialParameters 
{
    var array<VectorParameterValue> VectorParameterValues;
    var array<ScalarParameterValue> ScalarParameterValues;
    var array<TextureParameterValue> TextureParameterValues;
};

var(SFXSeqAct_SetActorAppearance) Head m_Head;
var(SFXSeqAct_SetActorAppearance) SkeletalMesh m_oMesh;
var(SFXSeqAct_SetActorAppearance) SkeletalMesh m_oHairMesh;
var(SFXSeqAct_SetActorAppearance) SkeletalMesh m_oHeadgearMesh;
var(SFXSeqAct_SetActorAppearance) array<MaterialInterface> m_aoMeshMaterials;
var(SFXSeqAct_SetActorAppearance) array<MaterialInterface> m_aoHairMaterials;
var(SFXSeqAct_SetActorAppearance) array<MaterialInterface> m_aoHeadgearMaterials;
var(SFXSeqAct_SetActorAppearance) MaterialParameters m_MaterialParameters;
var(SFXSeqAct_SetActorAppearance) bool m_bHideHead;
var(SFXSeqAct_SetActorAppearance) bool m_bHideHair;
var(SFXSeqAct_SetActorAppearance) bool m_bHideHeadgear;
var(SFXSeqAct_SetActorAppearance) bool m_bPreserveAnimation;

public function Activated()
{
    local Object ChkObject;
    local SFXStuntActor StuntActor;
    local SkeletalMeshActor SMA;
    local SkeletalMeshComponent MeshCmpt;
    local int idx;
    
    foreach Targets(ChkObject, )
    {
        StuntActor = SFXStuntActor(ChkObject);
        if (StuntActor != None)
        {
            if (m_oMesh != None)
            {
                ResetSkeletalComponent(StuntActor, StuntActor.BodyMesh, m_oMesh, m_aoMeshMaterials, 0);
                UpdateBoneMap(StuntActor);
            }
            if (m_Head.Mesh != None)
            {
                ResetSkeletalComponent(StuntActor, StuntActor.HeadMesh, m_Head.Mesh, m_Head.Materials, 1);
                StuntActor.MorphHead = m_Head.MorphHead;
            }
            if (m_oHairMesh != None)
            {
                ResetSkeletalComponent(StuntActor, StuntActor.HairMesh, m_oHairMesh, m_aoHairMaterials, 2);
            }
            if (m_oHeadgearMesh != None)
            {
                ResetSkeletalComponent(StuntActor, StuntActor.HeadGearMesh, m_oHeadgearMesh, m_aoHeadgearMaterials, 3);
            }
            HideSkeletalComponent(StuntActor, StuntActor.HeadMesh, m_bHideHead);
            HideSkeletalComponent(StuntActor, StuntActor.HairMesh, m_bHideHair);
            HideSkeletalComponent(StuntActor, StuntActor.HeadGearMesh, m_bHideHeadgear);
            foreach StuntActor.ComponentList(Class'SkeletalMeshComponent', MeshCmpt)
            {
                if (MeshCmpt != None)
                {
                    for (idx = 0; idx < MeshCmpt.Materials.Length; idx++)
                    {
                        ApplyBasicOverrides(StuntActor, MaterialInstanceConstant(MeshCmpt.Materials[idx]));
                        SetMaterialParameters(MeshCmpt.Materials[idx]);
                    }
                }
            }
            continue;
        }
        SMA = SFXSkeletalMeshActor(ChkObject);
        if (SMA != None)
        {
            if (m_oMesh != None)
            {
                ResetSkeletalComponent(SMA, SMA.SkeletalMeshComponent, m_oMesh, m_aoMeshMaterials, 0);
                UpdateBoneMap(SMA);
            }
            if (m_Head.Mesh != None)
            {
                ResetSkeletalComponent(SMA, SFXSkeletalMeshActor(SMA).HeadMesh, m_Head.Mesh, m_Head.Materials, 1);
                SFXSkeletalMeshActor(SMA).MorphHead = m_Head.MorphHead;
            }
            if (m_oHairMesh != None)
            {
                ResetSkeletalComponent(SMA, SFXSkeletalMeshActor(SMA).HairMesh, m_oHairMesh, m_aoHairMaterials, 2);
            }
            HideSkeletalComponent(SMA, SFXSkeletalMeshActor(SMA).HeadMesh, m_bHideHead);
            HideSkeletalComponent(SMA, SFXSkeletalMeshActor(SMA).HairMesh, m_bHideHair);
        }
        else
        {
            SMA = SFXSkeletalMeshActorMAT(ChkObject);
            if (SMA != None)
            {
                if (m_oMesh != None)
                {
                    ResetSkeletalComponent(SMA, SMA.SkeletalMeshComponent, m_oMesh, m_aoMeshMaterials, 0);
                    UpdateBoneMap(SMA);
                }
                if (m_Head.Mesh != None)
                {
                    ResetSkeletalComponent(SMA, SFXSkeletalMeshActorMAT(SMA).HeadMesh, m_Head.Mesh, m_Head.Materials, 1);
                    SFXSkeletalMeshActorMAT(SMA).MorphHead = m_Head.MorphHead;
                }
                if (m_oHairMesh != None)
                {
                    ResetSkeletalComponent(SMA, SFXSkeletalMeshActorMAT(SMA).HairMesh, m_oHairMesh, m_aoHairMaterials, 2);
                }
                HideSkeletalComponent(SMA, SFXSkeletalMeshActorMAT(SMA).HeadMesh, m_bHideHead);
                HideSkeletalComponent(SMA, SFXSkeletalMeshActorMAT(SMA).HairMesh, m_bHideHair);
            }
            else
            {
                SMA = SkeletalMeshActor(ChkObject);
                if (SMA == None)
                {
                    SMA = SkeletalMeshActorMAT(ChkObject);
                }
                if (SMA != None && m_oMesh != None)
                {
                    ResetSkeletalComponent(SMA, SMA.SkeletalMeshComponent, m_oMesh, m_aoMeshMaterials, 0);
                }
            }
        }
        if (SMA != None)
        {
            foreach SMA.ComponentList(Class'SkeletalMeshComponent', MeshCmpt)
            {
                if (MeshCmpt != None)
                {
                    for (idx = 0; idx < MeshCmpt.Materials.Length; idx++)
                    {
                        ApplyBasicOverrides(SMA, MaterialInstanceConstant(MeshCmpt.Materials[idx]));
                        SetMaterialParameters(MeshCmpt.Materials[idx]);
                    }
                }
            }
        }
    }
}
public function ResetSkeletalComponent(Actor InActor, SkeletalMeshComponent InComponent, SkeletalMesh InMesh, array<MaterialInterface> InMaterials, int Identifier)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    InActor.ReattachComponent(InComponent);
    if (InComponent == None && Identifier != 0)
    {
        InComponent = CreateSkeletalComponent(InActor, Identifier);
    }
    for (idx = 0; idx < InComponent.GetNumElements(); ++idx)
    {
        InComponent.SetMaterial(idx, None);
    }
    InComponent.SetSkeletalMesh(InMesh, m_bPreserveAnimation);
    for (idx = 0; idx < InComponent.SkeletalMesh.Materials.Length; ++idx)
    {
        MIC = new (InComponent) Class'MaterialInstanceConstant';
        MIC.SetParent(InComponent.SkeletalMesh.Materials[idx]);
        if (InMaterials.Length > idx && InMaterials[idx] != None)
        {
            MIC.SetParent(InMaterials[idx]);
        }
        InComponent.SetMaterial(idx, MIC);
    }
}
public function SkeletalMeshComponent CreateSkeletalComponent(Actor InActor, int Identifier)
{
    local SkeletalMeshActor SMA;
    local SkeletalMeshComponent NewCmpt;
    
    NewCmpt = new (Self) Class'SkeletalMeshComponent';
    NewCmpt.bTransformFromAnimParent = 1;
    NewCmpt.bUseOnePassLightingOnTranslucency = TRUE;
    InActor.AttachComponent(NewCmpt);
    if (SFXStuntActor(InActor) != None)
    {
        NewCmpt.SetParentAnimComponent(SFXStuntActor(InActor).BodyMesh);
        NewCmpt.SetShadowParent(SFXStuntActor(InActor).BodyMesh);
        NewCmpt.SetLightEnvironment(SFXStuntActor(InActor).LightEnvironment);
        switch (Identifier)
        {
            case 1:
                NewCmpt.bOverrideParentSkeleton = TRUE;
                NewCmpt.nmOverrideStartBoneName = 'headBase';
                SFXStuntActor(InActor).HeadMesh = NewCmpt;
                break;
            case 2:
                SFXStuntActor(InActor).HairMesh = NewCmpt;
                break;
            case 3:
                SFXStuntActor(InActor).HeadGearMesh = NewCmpt;
                break;
            default:
        }
    }
    SMA = SFXSkeletalMeshActor(InActor);
    if (SMA == None)
    {
        SMA = SFXSkeletalMeshActorMAT(InActor);
    }
    if (SMA != None)
    {
        NewCmpt.SetParentAnimComponent(SMA.SkeletalMeshComponent);
        NewCmpt.SetShadowParent(SMA.SkeletalMeshComponent);
        NewCmpt.SetLightEnvironment(SMA.LightEnvironment);
        switch (Identifier)
        {
            case 1:
                NewCmpt.bOverrideParentSkeleton = TRUE;
                NewCmpt.nmOverrideStartBoneName = 'headBase';
                if (SFXSkeletalMeshActor(SMA) != None)
                {
                    SFXSkeletalMeshActor(SMA).HeadMesh = NewCmpt;
                }
                if (SFXSkeletalMeshActorMAT(SMA) != None)
                {
                    SFXSkeletalMeshActorMAT(SMA).HeadMesh = NewCmpt;
                }
                break;
            case 2:
                if (SFXSkeletalMeshActor(SMA) != None)
                {
                    SFXSkeletalMeshActor(SMA).HairMesh = NewCmpt;
                }
                if (SFXSkeletalMeshActorMAT(SMA) != None)
                {
                    SFXSkeletalMeshActorMAT(SMA).HairMesh = NewCmpt;
                }
                break;
            default:
        }
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
public function UpdateBoneMap(Actor InActor)
{
    local SkeletalMeshComponent MeshCmpt;
    local int idx;
    
    foreach InActor.ComponentList(Class'SkeletalMeshComponent', MeshCmpt)
    {
        if (MeshCmpt != None)
        {
            if (SFXStuntActor(InActor) != None && SFXStuntActor(InActor).BodyMesh != MeshCmpt)
            {
                MeshCmpt.UpdateParentBoneMap();
            }
            if (SkeletalMeshActor(InActor) != None && MeshCmpt != SkeletalMeshActor(InActor).SkeletalMeshComponent)
            {
                MeshCmpt.UpdateParentBoneMap();
            }
        }
    }
}
public function HideSkeletalComponent(Actor InActor, SkeletalMeshComponent InComponent, bool bPart)
{
    if (InComponent != None && bPart)
    {
        InActor.DetachComponent(InComponent);
    }
}
public function ApplyBasicOverrides(Actor InActor, MaterialInstanceConstant InMaterial)
{
    local BioMorphFace Morph;
    local ColorParameter Param;
    
    if (SFXStuntActor(InActor) != None)
    {
        Morph = SFXStuntActor(InActor).MorphHead;
    }
    if (SFXSkeletalMeshActor(InActor) != None)
    {
        Morph = SFXSkeletalMeshActor(InActor).MorphHead;
    }
    if (SFXSkeletalMeshActorMAT(InActor) != None)
    {
        Morph = SFXSkeletalMeshActorMAT(InActor).MorphHead;
    }
    if (Morph == None || Morph.m_oMaterialOverrides == None)
    {
        return;
    }
    foreach Morph.m_oMaterialOverrides.m_aColorOverrides(Param, )
    {
        if (Param.nName == 'SkinTone' || Param.nName == 'HED_Hair_Colour_Vector')
        {
            InMaterial.SetVectorParameterValue(Param.nName, Param.cValue);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Actor", 
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
                      MaxVars = 1, 
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
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}