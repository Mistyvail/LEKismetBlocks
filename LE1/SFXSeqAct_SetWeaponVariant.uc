Class SFXSeqAct_SetWeaponVariant extends SequenceAction;

var(SFXSeqAct_SetWeaponVariant) EBioItemWeaponRangedType m_eWeapon;
var(SFXSeqAct_SetWeaponVariant) BioAppearanceItemSophisticatedVariant m_Override;
var(SFXSeqAct_SetWeaponVariant) int m_nVariation;

public function Activated()
{
    local Object ChkObject;
    local BioPawn Pawn;
    local BioWeaponRanged Weapon;
    
    foreach Targets(ChkObject, )
    {
        Pawn = BioPawn(ChkObject);
        if (Pawn != None)
        {
            Weapon = GetWeapon(Pawn);
            if (Weapon != None)
            {
                ApplyVariation(Weapon, m_nVariation);
                ApplyOverride(Weapon);
            }
        }
    }
}
public function BioWeaponRanged GetWeapon(BioPawn Pawn)
{
    local BioPawnBehavior Behavior;
    local BioEquipment Equipment;
    local BioWeaponRanged Weapon;
    local int I;
    
    Behavior = BioPawnBehavior(Pawn.oBioComponent);
    if (Behavior != None)
    {
        Equipment = Behavior.m_oEquipment;
        if (Equipment != None)
        {
            Weapon = BioWeaponRanged(Equipment.m_QuickSlotArray[int(m_eWeapon)]);
            if (Weapon != None && int(m_eWeapon) == int(Weapon.GetRangedWeaponType()))
            {
                return Weapon;
            }
            for (I = 0; I < 4; ++I)
            {
                Weapon = BioWeaponRanged(Equipment.m_QuickSlotArray[I]);
                if (Weapon != None && int(m_eWeapon) == int(Weapon.GetRangedWeaponType()))
                {
                    return Weapon;
                }
            }
        }
    }
    return None;
}
public function ApplyVariation(BioWeaponRanged Weapon, int Variation)
{
    local BioAppearanceItemWeapon Appr;
    local SkeletalMeshComponent SkelCmpt;
    local BioAppearanceItemSophisticatedVariant Variant;
    local int I;
    
    Appr = BioAppearanceItemWeapon(Weapon.m_oItem.m_oAppearance);
    SkelCmpt = SkeletalMeshComponent(Weapon.Mesh);
    if (Appr != None)
    {
        Variant = Appr.m_variants[Variation];
        SkelCmpt.SetSkeletalMesh(Variant.m_oModelMesh);
        Appr.ApplyMaterials(Variation, SkelCmpt);
        SkelCmpt.AnimSets[0] = Variant.m_oWeaponAnimSet;
        SkelCmpt.SetAnimTreeTemplate(Variant.m_oWeaponAnimTree);
        SkelCmpt.SetPhysicsAsset(Variant.m_oPhysicsAsset);
    }
}
public function ApplyOverride(BioWeaponRanged Weapon)
{
    local SkeletalMeshComponent SkelCmpt;
    local MaterialInstanceConstant MIC;
    local int I;
    
    SkelCmpt = SkeletalMeshComponent(Weapon.Mesh);
    if (m_Override.m_oModelMesh != None)
    {
        SkelCmpt.SetSkeletalMesh(m_Override.m_oModelMesh);
    }
    if (m_Override.m_aMaterials.Length != 0 || m_Override.m_oModelMesh != None)
    {
        for (I = 0; I < SkelCmpt.SkeletalMesh.Materials.Length; ++I)
        {
            MIC = new (Self) Class'MaterialInstanceConstant';
            MIC.SetParent(SkelCmpt.SkeletalMesh.Materials[I]);
            if (m_Override.m_aMaterials[I] != None)
            {
                MIC.SetParent(m_Override.m_aMaterials[I]);
            }
            SkelCmpt.SetMaterial(I, MIC);
        }
    }
    if (m_Override.m_oWeaponAnimSet != None)
    {
        SkelCmpt.AnimSets[0] = m_Override.m_oWeaponAnimSet;
    }
    if (m_Override.m_oWeaponAnimTree != None)
    {
        SkelCmpt.SetAnimTreeTemplate(m_Override.m_oWeaponAnimTree);
    }
    if (m_Override.m_oPhysicsAsset != None)
    {
        SkelCmpt.SetPhysicsAsset(m_Override.m_oPhysicsAsset);
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
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Weapon", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_eWeapon', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Variant", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nVariation', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}