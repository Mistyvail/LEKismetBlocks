Class SFXSeqAct_SetActorMesh extends SequenceAction;

enum EActorComponent
{
    ActorComponent_Mesh,
    ActorComponent_Head,
    ActorComponent_Hair,
    ActorComponent_Headgear,
};

var(SFXSeqAct_SetActorMesh) EActorComponent m_eActorComponent;
var(SFXSeqAct_SetActorMesh) SkeletalMesh m_oMesh;
var(SFXSeqAct_SetActorMesh) array<MaterialInterface> m_aoMaterials;
var(SFXSeqAct_SetActorMesh) bool m_bPreserveAnimation;

public function Activated()
{
    local Object ChkObject;
    local SFXStuntActor StuntActor;
    local SkeletalMeshActor SMA;
    
    foreach Targets(ChkObject, )
    {
        StuntActor = SFXStuntActor(ChkObject);
        if (StuntActor != None)
        {
            switch (m_eActorComponent)
            {
                case EActorComponent.ActorComponent_Mesh:
                    SetComponentMesh(StuntActor, StuntActor.BodyMesh, m_oMesh, m_aoMaterials);
                    UpdateBoneMap(StuntActor);
                    break;
                case EActorComponent.ActorComponent_Head:
                    SetComponentMesh(StuntActor, StuntActor.HeadMesh, m_oMesh, m_aoMaterials);
                    break;
                case EActorComponent.ActorComponent_Hair:
                    SetComponentMesh(StuntActor, StuntActor.HairMesh, m_oMesh, m_aoMaterials);
                    break;
                case EActorComponent.ActorComponent_Headgear:
                    SetComponentMesh(StuntActor, StuntActor.HeadGearMesh, m_oMesh, m_aoMaterials);
                    break;
                default:
            }
            continue;
        }
        SMA = SFXSkeletalMeshActor(ChkObject);
        if (SMA != None)
        {
            switch (m_eActorComponent)
            {
                case EActorComponent.ActorComponent_Mesh:
                    SetComponentMesh(SMA, SMA.SkeletalMeshComponent, m_oMesh, m_aoMaterials);
                    UpdateBoneMap(SFXSkeletalMeshActor(SMA));
                    break;
                case EActorComponent.ActorComponent_Head:
                    SetComponentMesh(SMA, SFXSkeletalMeshActorMAT(SMA).HeadMesh, m_oMesh, m_aoMaterials);
                    break;
                case EActorComponent.ActorComponent_Hair:
                    SetComponentMesh(SMA, SFXSkeletalMeshActor(SMA).HairMesh, m_oMesh, m_aoMaterials);
                    break;
                default:
            }
            continue;
        }
        else
        {
            SMA = SFXSkeletalMeshActorMAT(ChkObject);
            if (SMA != None)
            {
                switch (m_eActorComponent)
                {
                    case EActorComponent.ActorComponent_Mesh:
                        SetComponentMesh(SMA, SMA.SkeletalMeshComponent, m_oMesh, m_aoMaterials);
                        UpdateBoneMap(SFXSkeletalMeshActorMAT(SMA));
                        break;
                    case EActorComponent.ActorComponent_Head:
                        SetComponentMesh(SMA, SFXSkeletalMeshActorMAT(SMA).HeadMesh, m_oMesh, m_aoMaterials);
                        break;
                    case EActorComponent.ActorComponent_Hair:
                        SetComponentMesh(SMA, SFXSkeletalMeshActorMAT(SMA).HairMesh, m_oMesh, m_aoMaterials);
                        break;
                    default:
                }
                continue;
            }
            else
            {
                SMA = SkeletalMeshActor(ChkObject);
                if (SMA == None)
                {
                    SMA = SkeletalMeshActorMAT(ChkObject);
                }
                if (SMA != None)
                {
                    SetComponentMesh(SMA, SMA.SkeletalMeshComponent, m_oMesh, m_aoMaterials);
                }
            }
        }
    }
}
public function SetComponentMesh(Actor InActor, SkeletalMeshComponent InComponent, SkeletalMesh InMesh, array<MaterialInterface> InMaterials)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    for (idx = 0; idx < InComponent.GetNumElements(); ++idx)
    {
        InComponent.SetMaterial(idx, None);
    }
    InComponent.SetSkeletalMesh(InMesh, m_bPreserveAnimation);
    if (InComponent.SkeletalMesh != None)
    {
        for (idx = 0; idx < InComponent.SkeletalMesh.Materials.Length; ++idx)
        {
            MIC = new (InComponent) Class'MaterialInstanceConstant';
            MIC.SetParent(InComponent.SkeletalMesh.Materials[idx]);
            if (InMaterials.Length > idx && InMaterials[idx] != None)
            {
                MIC.SetParent(InMaterials[idx]);
            }
            ApplyBasicOverrides(InActor, MIC);
            InComponent.SetMaterial(idx, MIC);
        }
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
                     }
                    )
}