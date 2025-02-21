Class SFXSeqAct_SetPawnMaterialParams extends SequenceAction;

enum GBioPawnComponent
{
    BioPawnComponent_Mesh,
    BioPawnComponent_Head,
    BioPawnComponent_Hair,
    BioPawnComponent_Headgear,
    BioPawnComponent_Visor,
    BioPawnComponent_FacePlate,
    BioPawnComponent_Accessory,
};

var(SFXSeqAct_SetPawnMaterialParams) array<VectorParameterValue> m_aVectorParameterValues;
var(SFXSeqAct_SetPawnMaterialParams) array<ScalarParameterValue> m_aScalarParameterValues;
var(SFXSeqAct_SetPawnMaterialParams) array<TextureParameterValue> m_aTextureParameterValues;
var(SFXSeqAct_SetPawnMaterialParams) GBioPawnComponent m_eBioPawnComponent;
var(SFXSeqAct_SetPawnMaterialParams) int m_nAccessory;

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
                case GBioPawnComponent.BioPawnComponent_Mesh:
                    for (idx = 0; idx < Pawn.Mesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.Mesh.Materials[idx]);
                    }
                    break;
                case GBioPawnComponent.BioPawnComponent_Head:
                    for (idx = 0; idx < Pawn.HeadMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.HeadMesh.Materials[idx]);
                    }
                    break;
                case GBioPawnComponent.BioPawnComponent_Hair:
                    for (idx = 0; idx < Pawn.m_oHairMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.m_oHairMesh.Materials[idx]);
                    }
                    break;
                case GBioPawnComponent.BioPawnComponent_Headgear:
                    for (idx = 0; idx < Pawn.m_oHeadGearMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.m_oHeadGearMesh.Materials[idx]);
                    }
                    break;
                case GBioPawnComponent.BioPawnComponent_Visor:
                    for (idx = 0; idx < Pawn.m_oVisorMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.m_oVisorMesh.Materials[idx]);
                    }
                    break;
                case GBioPawnComponent.BioPawnComponent_FacePlate:
                    for (idx = 0; idx < Pawn.m_oFacePlateMesh.Materials.Length; idx++)
                    {
                        SetMaterialParameters(Pawn.m_oFacePlateMesh.Materials[idx]);
                    }
                    break;
                case GBioPawnComponent.BioPawnComponent_Accessory:
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
public function SetMaterialParameters(MaterialInterface InMaterial)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    MIC = MaterialInstanceConstant(InMaterial);
    if (MIC != None)
    {
        for (idx = 0; idx < m_aVectorParameterValues.Length; ++idx)
        {
            MIC.SetVectorParameterValue(m_aVectorParameterValues[idx].ParameterName, m_aVectorParameterValues[idx].ParameterValue);
        }
        for (idx = 0; idx < m_aScalarParameterValues.Length; ++idx)
        {
            MIC.SetScalarParameterValue(m_aScalarParameterValues[idx].ParameterName, m_aScalarParameterValues[idx].ParameterValue);
        }
        for (idx = 0; idx < m_aTextureParameterValues.Length; ++idx)
        {
            MIC.SetTextureParameterValue(m_aTextureParameterValues[idx].ParameterName, m_aTextureParameterValues[idx].ParameterValue);
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