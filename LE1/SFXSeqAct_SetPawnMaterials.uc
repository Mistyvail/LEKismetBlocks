Class SFXSeqAct_SetPawnMaterials extends SequenceAction;

struct Materials 
{
    var EBioPawnComponent m_eBioPawnComponent;
    var array<MaterialInterface> m_aoMatInt;
    var int m_nAccessory;
};
enum EBioPawnComponent
{
    BioPawnComponent_Mesh,
    BioPawnComponent_Head,
    BioPawnComponent_Hair,
    BioPawnComponent_Headgear,
    BioPawnComponent_Visor,
    BioPawnComponent_FacePlate,
    BioPawnComponent_Accessory,
};

var(SFXSeqAct_SetPawnMaterials) array<Materials> m_aoMaterials;

public function Activated()
{
    local Object ChkObject;
    local BioPawn Pawn;
    local int idx;
    
    foreach Targets(ChkObject, )
    {
        Pawn = BioPawn(ChkObject);
        if (Pawn != None)
        {
            for (idx = 0; idx < m_aoMaterials.Length; ++idx)
            {
                switch (m_aoMaterials[idx].m_eBioPawnComponent)
                {
                    case EBioPawnComponent.BioPawnComponent_Mesh:
                        SetComponentMaterials(Pawn, m_aoMaterials[idx].m_aoMatInt, Pawn.Mesh);
                        break;
                    case EBioPawnComponent.BioPawnComponent_Head:
                        SetComponentMaterials(Pawn, m_aoMaterials[idx].m_aoMatInt, Pawn.m_oHeadMesh);
                        break;
                    case EBioPawnComponent.BioPawnComponent_Hair:
                        SetComponentMaterials(Pawn, m_aoMaterials[idx].m_aoMatInt, Pawn.m_oHairMesh);
                        break;
                    case EBioPawnComponent.BioPawnComponent_Headgear:
                        SetComponentMaterials(Pawn, m_aoMaterials[idx].m_aoMatInt, Pawn.m_oHeadGearMesh);
                        break;
                    case EBioPawnComponent.BioPawnComponent_Visor:
                        SetComponentMaterials(Pawn, m_aoMaterials[idx].m_aoMatInt, Pawn.m_oVisorMesh);
                        break;
                    case EBioPawnComponent.BioPawnComponent_FacePlate:
                        SetComponentMaterials(Pawn, m_aoMaterials[idx].m_aoMatInt, Pawn.m_oFacePlateMesh);
                        break;
                    case EBioPawnComponent.BioPawnComponent_Accessory:
                        SetComponentMaterials(Pawn, m_aoMaterials[idx].m_aoMatInt, Pawn.m_aoAccessories[m_aoMaterials[idx].m_nAccessory]);
                        break;
                    default:
                }
                Pawn.ApplyMaterialParameters(Pawn.m_oBehavior.m_oAppearanceType.m_oMorphFace.m_oMaterialOverrides);
            }
        }
    }
}
public function SetComponentMaterials(BioPawn InPawn, array<MaterialInterface> MatInt, SkeletalMeshComponent InComponent)
{
    local MaterialInstanceConstant MIC;
    local int idx;
    
    if (InComponent != None)
    {
        for (idx = 0; idx < InComponent.SkeletalMesh.Materials.Length; ++idx)
        {
            if (MatInt[idx] != None)
            {
                MIC = new (InComponent) Class'MaterialInstanceConstant';
                MIC.SetParent(MatInt[idx]);
                InComponent.SetMaterial(idx, MIC);
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
