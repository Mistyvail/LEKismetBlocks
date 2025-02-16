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
var(SFXSeqAct_SetActorAppearance) array<MaterialInterface> m_aoMeshMaterials;
var(SFXSeqAct_SetActorAppearance) array<MaterialInterface> m_aoHairMaterials;
var(SFXSeqAct_SetActorAppearance) MaterialParameters m_MaterialParameters;
var(SFXSeqAct_SetActorAppearance) bool m_bHideHead;
var(SFXSeqAct_SetActorAppearance) bool m_bHideHair;
var(SFXSeqAct_SetActorAppearance) bool bPreserveAnimation;

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
    InComponent.SetSkeletalMesh(InMesh, bPreserveAnimation);
    for (idx = 0; idx < InComponent.SkeletalMesh.Materials.Length; ++idx)
    {
        MIC = new (InComponent) Class'MaterialInstanceConstant';
        MIC.SetParent(InComponent.SkeletalMesh.Materials[idx]);
        if (InMaterials.Length > 0 && InMaterials[idx] != None)
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
        if (MeshCmpt != None && MeshCmpt != SkeletalMeshActor(InActor).SkeletalMeshComponent)
        {
            MeshCmpt.UpdateParentBoneMap();
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
        Morph = BioPawnType(InActor.ActorType).m_oMorphFace;
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