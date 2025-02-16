Class SFXSeqAct_SetActorMaterialParameters extends SequenceAction;

enum GActorComponent
{
    ActorComponent_Mesh,
    ActorComponent_Head,
    ActorComponent_Hair,
    ActorComponent_Headgear,
};

var(SFXSeqAct_SetActorMaterialParameters) GActorComponent m_eActorComponent;
var(SFXSeqAct_SetActorMaterialParameters) array<VectorParameterValue> VectorParameterValues;
var(SFXSeqAct_SetActorMaterialParameters) array<ScalarParameterValue> ScalarParameterValues;
var(SFXSeqAct_SetActorMaterialParameters) array<TextureParameterValue> TextureParameterValues;

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
            switch (m_eActorComponent)
            {
                case GActorComponent.ActorComponent_Mesh:
                    for (idx = 0; idx < StuntActor.BodyMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(StuntActor.BodyMesh.Materials[idx]);
                    }
                    break;
                case GActorComponent.ActorComponent_Head:
                    for (idx = 0; idx < StuntActor.HeadMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(StuntActor.HeadMesh.Materials[idx]);
                    }
                    break;
                case GActorComponent.ActorComponent_Hair:
                    for (idx = 0; idx < StuntActor.HairMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(StuntActor.HairMesh.Materials[idx]);
                    }
                    break;
                case GActorComponent.ActorComponent_Headgear:
                    for (idx = 0; idx < StuntActor.HeadGearMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(StuntActor.HeadGearMesh.Materials[idx]);
                    }
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
                case GActorComponent.ActorComponent_Mesh:
                    for (idx = 0; idx < SMA.SkeletalMeshComponent.Materials.Length; idx++)
                    {
                        SetMaterialParameters(SMA.SkeletalMeshComponent.Materials[idx]);
                    }
                    break;
                case GActorComponent.ActorComponent_Head:
                    for (idx = 0; idx < SFXSkeletalMeshActor(SMA).HeadMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(SFXSkeletalMeshActor(SMA).HeadMesh.Materials[idx]);
                    }
                    break;
                case GActorComponent.ActorComponent_Hair:
                    for (idx = 0; idx < SFXSkeletalMeshActor(SMA).HairMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(SFXSkeletalMeshActor(SMA).HairMesh.Materials[idx]);
                    }
                    break;
                default:
                    foreach SMA.ComponentList(Class'SkeletalMeshComponent', MeshCmpt)
                    {
                        if (MeshCmpt != None)
                        {
                            for (idx = 0; idx < MeshCmpt.Materials.Length; idx++)
                            {
                                SetMaterialParameters(MeshCmpt.Materials[idx]);
                            }
                        }
                    }
                    break;
            }
        }
        else
        {
            SMA = SFXSkeletalMeshActorMAT(ChkObject);
            if (SMA != None)
            {
                switch (m_eActorComponent)
                {
                    case GActorComponent.ActorComponent_Mesh:
                        for (idx = 0; idx < SMA.SkeletalMeshComponent.Materials.Length; idx++)
                        {
                            SetMaterialParameters(SMA.SkeletalMeshComponent.Materials[idx]);
                        }
                        break;
                    case GActorComponent.ActorComponent_Head:
                        for (idx = 0; idx < SFXSkeletalMeshActorMAT(SMA).HeadMesh.Materials.Length; idx++)
                        {
                            SetMaterialParameters(SFXSkeletalMeshActorMAT(SMA).HeadMesh.Materials[idx]);
                        }
                        break;
                    case GActorComponent.ActorComponent_Hair:
                        for (idx = 0; idx < SFXSkeletalMeshActorMAT(SMA).HairMesh.Materials.Length; idx++)
                        {
                            SetMaterialParameters(SFXSkeletalMeshActorMAT(SMA).HairMesh.Materials[idx]);
                        }
                        break;
                    default:
                        foreach SMA.ComponentList(Class'SkeletalMeshComponent', MeshCmpt)
                        {
                            if (MeshCmpt != None)
                            {
                                for (idx = 0; idx < MeshCmpt.Materials.Length; idx++)
                                {
                                    SetMaterialParameters(MeshCmpt.Materials[idx]);
                                }
                            }
                        }
                        break;
                }
            }
            else
            {
                for (idx = 0; idx < SMA.SkeletalMeshComponent.Materials.Length; idx++)
                {
                    SetMaterialParameters(SMA.SkeletalMeshComponent.Materials[idx]);
                }
            }
        }
    }
}
public function SetMaterialParameters(MaterialInterface InMaterial)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    MIC = MaterialInstanceConstant(InMaterial);
    if (MIC != None)
    {
        for (idx = 0; idx < VectorParameterValues.Length; ++idx)
        {
            MIC.SetVectorParameterValue(VectorParameterValues[idx].ParameterName, VectorParameterValues[idx].ParameterValue);
        }
        for (idx = 0; idx < ScalarParameterValues.Length; ++idx)
        {
            MIC.SetScalarParameterValue(ScalarParameterValues[idx].ParameterName, ScalarParameterValues[idx].ParameterValue);
        }
        for (idx = 0; idx < TextureParameterValues.Length; ++idx)
        {
            MIC.SetTextureParameterValue(TextureParameterValues[idx].ParameterName, TextureParameterValues[idx].ParameterValue);
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
                     }
                    )
}