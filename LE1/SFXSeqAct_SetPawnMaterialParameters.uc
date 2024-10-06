Class SFXSeqAct_SetPawnMaterialParameters extends SequenceAction;

enum FBioPawnComponent
{
    BioPawnComponent_Mesh,
    BioPawnComponent_Head,
    BioPawnComponent_Hair,
    BioPawnComponent_Headgear,
    BioPawnComponent_Visor,
    BioPawnComponent_FacePlate,
    BioPawnComponent_Accessory,
};

var(SFXSeqAct_SetPawnMaterialParameters) array<VectorParameterValue> VectorParameterValues;
var(SFXSeqAct_SetPawnMaterialParameters) array<ScalarParameterValue> ScalarParameterValues;
var(SFXSeqAct_SetPawnMaterialParameters) array<TextureParameterValue> TextureParameterValues;
var(SFXSeqAct_SetPawnMaterialParameters) FBioPawnComponent m_eBioPawnComponent;
var(SFXSeqAct_SetPawnMaterialParameters) int m_nAccessory;

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
            switch (m_eBioPawnComponent)
            {
                case FBioPawnComponent.BioPawnComponent_Mesh:
                    for (idx = 0; idx < Pawn.Mesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.Mesh.Materials[idx]);
                    }
                    break;
                case FBioPawnComponent.BioPawnComponent_Head:
                    for (idx = 0; idx < Pawn.m_oHeadMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.m_oHeadMesh.Materials[idx]);
                    }
                    break;
                case FBioPawnComponent.BioPawnComponent_Hair:
                    for (idx = 0; idx < Pawn.m_oHairMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.m_oHairMesh.Materials[idx]);
                    }
                    break;
                case FBioPawnComponent.BioPawnComponent_Headgear:
                    for (idx = 0; idx < Pawn.m_oHeadGearMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.m_oHeadGearMesh.Materials[idx]);
                    }
                    break;
                case FBioPawnComponent.BioPawnComponent_Visor:
                    for (idx = 0; idx < Pawn.m_oVisorMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.m_oVisorMesh.Materials[idx]);
                    }
                    break;
                case FBioPawnComponent.BioPawnComponent_FacePlate:
                    for (idx = 0; idx < Pawn.m_oFacePlateMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.m_oFacePlateMesh.Materials[idx]);
                    }
                    break;
                case FBioPawnComponent.BioPawnComponent_Accessory:
                    for (idx = 0; idx < Pawn.m_aoAccessories[m_nAccessory].Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.m_aoAccessories[m_nAccessory].Materials[idx]);
                    }
                    break;
                default:
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
                    break;
            }
        }
    }
}
public function SetMaterialParameters(MaterialInterface Material)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    MIC = MaterialInstanceConstant(Material);
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
                     }
                    )
}
