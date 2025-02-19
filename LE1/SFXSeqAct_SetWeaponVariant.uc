Class SFXSeqAct_SetWeaponVariant extends SequenceAction;

var(SFXSeqAct_SetWeaponVariant) EBioItemWeaponRangedType m_eWeapon;
var(SFXSeqAct_SetWeaponVariant) BioAppearanceItemSophisticatedVariant m_Override;
var(SFXSeqAct_SetWeaponVariant) int m_nVariation;

public function Activated()
{
    local Object ChkObject;
    local BioWeaponRanged Weapon;
    local SkeletalMeshComponent SkelCmpt;
    local BioAppearanceItemWeapon Appr;
    
    foreach Targets(ChkObject, )
    {
        Weapon = GetWeapon(BioPawn(ChkObject));
        Appr = FindVariants(m_eWeapon, Weapon);
        if (Appr == None)
        {
            return;
        }
        SkelCmpt = SkeletalMeshComponent(Weapon.Mesh);
        if (SkelCmpt == None)
        {
            SkelCmpt = SkeletalMeshActor(ChkObject).SkeletalMeshComponent;
        }
        ApplyVariation(Appr, SkelCmpt, m_nVariation);
        ApplyOverride(SkelCmpt);
    }
}
public function BioWeaponRanged GetWeapon(BioPawn Pawn)
{
    local BioPawnBehavior Behavior;
    local BioEquipment Equipment;
    local BioWeaponRanged Weapon;
    local int I;
    
    if (Pawn == None)
    {
        return None;
    }
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
public function BioAppearanceItemWeapon FindVariants(EBioItemWeaponRangedType Type, BioWeaponRanged Weapon)
{
    local Object Obj;
    
    Obj = Weapon.m_oItem.m_oAppearance;
    if (BioAppearanceItemWeapon(Obj) == None)
    {
        Obj = FindObject("BIOG_WPN_ALL_MASTER_L.Appearance." $ AppearanceItem(Type), Class'BioAppearanceItemWeapon');
    }
    if (BioAppearanceItemWeapon(Obj) == None)
    {
        Obj = DynamicLoadObject("BIOG_WPN_ALL_MASTER_L.Appearance." $ AppearanceItem(Type), Class'BioAppearanceItemWeapon');
    }
    return BioAppearanceItemWeapon(Obj);
}
public function string AppearanceItem(EBioItemWeaponRangedType Type)
{
    switch (Type)
    {
        case EBioItemWeaponRangedType.ITEM_WEAPON_RANGED_PISTOL:
            return "Pistol.Default_WPN_PST_Appr";
            break;
        case EBioItemWeaponRangedType.ITEM_WEAPON_RANGED_SHOTGUN:
            return "Shotgun.Default_WPN_BLS_Appr";
            break;
        case EBioItemWeaponRangedType.ITEM_WEAPON_RANGED_ASSAULT_RIFLE:
            return "Assault_Rifle.Default_WPN_ASL_Appr";
            break;
        case EBioItemWeaponRangedType.ITEM_WEAPON_RANGED_SNIPER:
            return "Sniper_Rifle.Default_WPN_SNP_Appr";
            break;
        default:
    }
    return "";
}
public function ApplyVariation(BioAppearanceItemWeapon Appr, SkeletalMeshComponent SkelCmpt, int Variation)
{
    if (Appr != None && SkelCmpt != None)
    {
        SkelCmpt.SetSkeletalMesh(Appr.GetSkeletalMesh(Variation));
        Appr.ApplyMaterials(Variation, SkelCmpt);
        SkelCmpt.AnimSets[0] = Appr.GetAnimationSet(Variation);
        SkelCmpt.SetAnimTreeTemplate(Appr.GetAnimationTree(Variation));
        SkelCmpt.SetPhysicsAsset(Appr.GetPhysicsAsset(Variation));
    }
}
public function ApplyOverride(SkeletalMeshComponent SkelCmpt)
{
    local MaterialInstanceConstant MIC;
    local int I;
    
    if (SkelCmpt != None)
    {
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
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
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