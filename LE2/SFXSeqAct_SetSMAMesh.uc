Class SFXSeqAct_SetSMAMesh extends SequenceAction;

enum ESMAComponent
{
    SMAComponent_Mesh,
    SMAComponent_Head,
    SMAComponent_Hair,
};

var(SFXSeqAct_SetSMAMesh) ESMAComponent m_eSMAComponent;
var(SFXSeqAct_SetSMAMesh) SkeletalMesh m_oMesh;
var(SFXSeqAct_SetSMAMesh) array<MaterialInterface> m_aoMaterials;

public function Activated()
{
    local Object ChkObject;
    local SkeletalMeshActor SMA;
    
    foreach Targets(ChkObject, )
    {
        SMA = SFXSkeletalMeshActor(ChkObject);
        if (SMA != None)
        {
            switch (m_eSMAComponent)
            {
                case ESMAComponent.SMAComponent_Mesh:
                    SetComponentMesh(SMA, SMA.SkeletalMeshComponent, m_oMesh, m_aoMaterials);
                    UpdateBoneMap(SFXSkeletalMeshActor(SMA));
                    break;
                case ESMAComponent.SMAComponent_Head:
                    SetComponentMesh(SMA, SFXSkeletalMeshActorMAT(SMA).HeadMesh, m_oMesh, m_aoMaterials);
                    break;
                case ESMAComponent.SMAComponent_Hair:
                    SetComponentMesh(SMA, SFXSkeletalMeshActor(SMA).HairMesh, m_oMesh, m_aoMaterials);
                    break;
                default:
            }
        }
        else
        {
            SMA = SFXSkeletalMeshActorMAT(ChkObject);
            if (SMA != None)
            {
                switch (m_eSMAComponent)
                {
                    case ESMAComponent.SMAComponent_Mesh:
                        SetComponentMesh(SMA, SMA.SkeletalMeshComponent, m_oMesh, m_aoMaterials);
                        UpdateBoneMap(SFXSkeletalMeshActorMAT(SMA));
                        break;
                    case ESMAComponent.SMAComponent_Head:
                        SetComponentMesh(SMA, SFXSkeletalMeshActorMAT(SMA).HeadMesh, m_oMesh, m_aoMaterials);
                        break;
                    case ESMAComponent.SMAComponent_Hair:
                        SetComponentMesh(SMA, SFXSkeletalMeshActorMAT(SMA).HairMesh, m_oMesh, m_aoMaterials);
                        break;
                    default:
                }
            }
            else
            {
                SMA = SkeletalMeshActor(ChkObject);
                if (SMA != None)
                {
                    SetComponentMesh(SMA, SMA.SkeletalMeshComponent, m_oMesh, m_aoMaterials);
                }
            }
        }
    }
}
public function SetComponentMesh(SkeletalMeshActor InSMA, SkeletalMeshComponent InComponent, SkeletalMesh InMesh, array<MaterialInterface> InMaterials)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    for (idx = 0; idx < InComponent.GetNumElements(); ++idx)
    {
        InComponent.SetMaterial(idx, None);
    }
    InComponent.SetSkeletalMesh(InMesh, TRUE);
    if (InComponent.SkeletalMesh != None)
    {
        for (idx = 0; idx < InComponent.SkeletalMesh.Materials.Length; ++idx)
        {
            MIC = new (InComponent) Class'MaterialInstanceConstant';
            MIC.SetParent(InComponent.SkeletalMesh.Materials[idx]);
            if (InMaterials[idx] != None)
            {
                MIC.SetParent(InMaterials[idx]);
            }
            ApplyBasicOverrides(InSMA, MIC);
            InComponent.SetMaterial(idx, MIC);
        }
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
                     }
                    )
}