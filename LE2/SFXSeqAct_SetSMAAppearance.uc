Class SFXSeqAct_SetSMAAppearance extends SequenceAction;

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

var(SFXSeqAct_SetSMAAppearance) Head m_Head;
var(SFXSeqAct_SetSMAAppearance) SkeletalMesh m_oMesh;
var(SFXSeqAct_SetSMAAppearance) SkeletalMesh m_oHairMesh;
var(SFXSeqAct_SetSMAAppearance) array<MaterialInterface> m_aoMeshMaterials;
var(SFXSeqAct_SetSMAAppearance) array<MaterialInterface> m_aoHairMaterials;
var(SFXSeqAct_SetSMAAppearance) MaterialParameters m_MaterialParameters;
var(SFXSeqAct_SetSMAAppearance) bool m_bHideHead;
var(SFXSeqAct_SetSMAAppearance) bool m_bHideHair;
var(SFXSeqAct_SetSMAAppearance) bool bPreserveAnimation;

public function Activated()
{
    local Object ChkObject;
    local SkeletalMeshActor SMA;
    local SkeletalMeshComponent MeshCmpt;
    local int idx;
    
    foreach Targets(ChkObject, )
    {
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
                if (SMA != None)
                {
                    if (m_oMesh != None)
                    {
                        ResetSkeletalComponent(SMA, SMA.SkeletalMeshComponent, m_oMesh, m_aoMeshMaterials, 0);
                    }
                }
            }
        }
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
public function ResetSkeletalComponent(SkeletalMeshActor InSMA, SkeletalMeshComponent InComponent, SkeletalMesh InMesh, array<MaterialInterface> InMaterials, int Identifier)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    InSMA.ReattachComponent(InComponent);
    if (InComponent == None && Identifier != 0)
    {
        InComponent = CreateSkeletalComponent(InSMA, Identifier);
    }
    for (idx = 0; idx < InComponent.GetNumElements(); ++idx)
    {
        InComponent.SetMaterial(idx, None);
    }
    InComponent.SetSkeletalMesh(InMesh, bPreserveAnimation);
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
public function SkeletalMeshComponent CreateSkeletalComponent(SkeletalMeshActor InSMA, int Identifier)
{
    local SkeletalMeshActor SMA;
    local SkeletalMeshComponent NewCmpt;
    
    NewCmpt = new (Self) Class'SkeletalMeshComponent';
    NewCmpt.bTransformFromAnimParent = 1;
    NewCmpt.bUseOnePassLightingOnTranslucency = TRUE;
    NewCmpt.SetParentAnimComponent(InSMA.SkeletalMeshComponent);
    NewCmpt.SetShadowParent(InSMA.SkeletalMeshComponent);
    NewCmpt.SetLightEnvironment(InSMA.LightEnvironment);
    InSMA.AttachComponent(NewCmpt);
    SMA = SFXSkeletalMeshActor(InSMA);
    if (SMA != None)
    {
        switch (Identifier)
        {
            case 1:
                NewCmpt.bOverrideParentSkeleton = TRUE;
                NewCmpt.nmOverrideStartBoneName = 'headBase';
                SFXSkeletalMeshActor(SMA).HeadMesh = NewCmpt;
                break;
            case 2:
                SFXSkeletalMeshActor(SMA).HairMesh = NewCmpt;
                break;
            default:
        }
    }
    else
    {
        SMA = SFXSkeletalMeshActorMAT(InSMA);
        if (SMA != None)
        {
            switch (Identifier)
            {
                case 1:
                    NewCmpt.bOverrideParentSkeleton = TRUE;
                    NewCmpt.nmOverrideStartBoneName = 'headBase';
                    SFXSkeletalMeshActorMAT(SMA).HeadMesh = NewCmpt;
                    break;
                case 2:
                    SFXSkeletalMeshActorMAT(SMA).HairMesh = NewCmpt;
                    break;
                default:
            }
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
public function UpdateBoneMap(SkeletalMeshActor InSMA)
{
    local SkeletalMeshComponent MeshCmpt;
    local int idx;
    
    foreach InSMA.ComponentList(Class'SkeletalMeshComponent', MeshCmpt)
    {
        if (MeshCmpt != None && MeshCmpt != InSMA.SkeletalMeshComponent)
        {
            MeshCmpt.UpdateParentBoneMap();
        }
    }
}
public function HideSkeletalComponent(SkeletalMeshActor InSMA, SkeletalMeshComponent InComponent, bool bPart)
{
    if (InComponent != None && bPart)
    {
        InSMA.DetachComponent(InComponent);
    }
}
public function ApplyBasicOverrides(SkeletalMeshActor InSMA, MaterialInstanceConstant InMaterial)
{
    local BioMorphFace Morph;
    local ColorParameter Param;
    
    Morph = SFXSkeletalMeshActor(InSMA).MorphHead;
    if (Morph.m_oMaterialOverrides == None)
    {
        Morph = SFXSkeletalMeshActorMAT(InSMA).MorphHead;
    }
    if (Morph.m_oMaterialOverrides == None)
    {
        Morph = BioPawnType(InSMA.ActorType).m_oMorphFace;
    }
    if (Morph.m_oMaterialOverrides == None)
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
                      LinkDesc = "MeshActor", 
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
                     }
                    )
}