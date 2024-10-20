Class SFXSeqAct_SetSMAMaterials extends SequenceAction;

enum FSMAComponent
{
    SMAComponent_Mesh,
    SMAComponent_Head,
    SMAComponent_Hair,
};

var(SFXSeqAct_SetSMAMaterials) FSMAComponent m_eSMAComponent;
var(SFXSeqAct_SetSMAMaterials) array<MaterialInterface> m_aoMaterials;

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
                case FSMAComponent.SMAComponent_Mesh:
                    SetComponentMaterials(SMA, SMA.SkeletalMeshComponent, m_aoMaterials);
                    break;
                case FSMAComponent.SMAComponent_Head:
                    SetComponentMaterials(SMA, SFXSkeletalMeshActor(SMA).HeadMesh, m_aoMaterials);
                    break;
                case FSMAComponent.SMAComponent_Hair:
                    SetComponentMaterials(SMA, SFXSkeletalMeshActor(SMA).HairMesh, m_aoMaterials);
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
                    case FSMAComponent.SMAComponent_Mesh:
                        SetComponentMaterials(SMA, SMA.SkeletalMeshComponent, m_aoMaterials);
                        break;
                    case FSMAComponent.SMAComponent_Head:
                        SetComponentMaterials(SMA, SFXSkeletalMeshActorMAT(SMA).HeadMesh, m_aoMaterials);
                        break;
                    case FSMAComponent.SMAComponent_Hair:
                        SetComponentMaterials(SMA, SFXSkeletalMeshActorMAT(SMA).HairMesh, m_aoMaterials);
                        break;
                    default:
                }
            }
            else
            {
                SMA = SkeletalMeshActor(ChkObject);
                if (SMA != None)
                {
                    SetComponentMaterials(SMA, SMA.SkeletalMeshComponent, m_aoMaterials);
                }
            }
        }
    }
}
public function SetComponentMaterials(SkeletalMeshActor InSMA, SkeletalMeshComponent InComponent, array<MaterialInterface> InMaterials)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    if (InComponent != None)
    {
        for (idx = 0; idx < InComponent.SkeletalMesh.Materials.Length; ++idx)
        {
            if (InMaterials[idx] != None)
            {
                MIC = new (InComponent) Class'MaterialInstanceConstant';
                MIC.SetParent(InMaterials[idx]);
                ApplyBasicOverrides(InSMA, MIC);
                InComponent.SetMaterial(idx, MIC);
            }
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
                     }
                    )
}