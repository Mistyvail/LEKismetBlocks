Class SFXSeqAct_SetPawnMaterials extends SequenceAction;

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

var(SFXSeqAct_SetPawnMaterials) FBioPawnComponent m_eBioPawnComponent;
var(SFXSeqAct_SetPawnMaterials) array<MaterialInterface> m_aoMaterials;
var(SFXSeqAct_SetPawnMaterials) int m_nAccessory;

public function Activated()
{
    local Object ChkObject;
    local BioPawn Pawn;
    
    foreach Targets(ChkObject, )
    {
        Pawn = BioPawn(ChkObject);
        if (Pawn != None)
        {
            switch (m_eBioPawnComponent)
            {
                case FBioPawnComponent.BioPawnComponent_Mesh:
                    SetComponentMaterials(Pawn, Pawn.Mesh, m_aoMaterials);
                    break;
                case FBioPawnComponent.BioPawnComponent_Head:
                    SetComponentMaterials(Pawn, Pawn.m_oHeadMesh, m_aoMaterials);
                    break;
                case FBioPawnComponent.BioPawnComponent_Hair:
                    SetComponentMaterials(Pawn, Pawn.m_oHairMesh, m_aoMaterials);
                    break;
                case FBioPawnComponent.BioPawnComponent_Headgear:
                    SetComponentMaterials(Pawn, Pawn.m_oHeadGearMesh, m_aoMaterials);
                    break;
                case FBioPawnComponent.BioPawnComponent_Visor:
                    SetComponentMaterials(Pawn, Pawn.m_oVisorMesh, m_aoMaterials);
                    break;
                case FBioPawnComponent.BioPawnComponent_FacePlate:
                    SetComponentMaterials(Pawn, Pawn.m_oFacePlateMesh, m_aoMaterials);
                    break;
                case FBioPawnComponent.BioPawnComponent_Accessory:
                    SetComponentMaterials(Pawn, Pawn.m_aoAccessories[m_nAccessory], m_aoMaterials);
                    break;
                default:
            }
        }
    }
}
public function SetComponentMaterials(BioPawn InPawn, SkeletalMeshComponent InComponent, array<MaterialInterface> InMaterials)
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
                ApplyBasicOverrides(InPawn, MIC);
                InComponent.SetMaterial(idx, MIC);
            }
        }
    }
}
public function ApplyBasicOverrides(BioPawn InPawn, MaterialInstanceConstant InMaterial)
{
    local BioMorphFace Morph;
    local ColorParameter Param;
    
    Morph = InPawn.m_oBehavior.m_oAppearanceType.m_oMorphFace;
    if (Morph == None)
    {
        Morph = BioPawnChallengeScaledType(InPawn.m_oBehavior.m_oActorType).m_oMorphFace;
    }
    if (Morph == None)
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
