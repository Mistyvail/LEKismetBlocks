Class SFXSeqAct_GiveWeapon extends SequenceAction;

var(SFXSeqAct_GiveWeapon) EBioItemWeaponRangedType m_eWeapon;
var(SFXSeqAct_GiveWeapon) string m_sLabel;
var(SFXSeqAct_GiveWeapon) int m_nManufacturer;
var(SFXSeqAct_GiveWeapon) int m_nLevel;

public function Activated()
{
    local Object ChkObject;
    local BioPawn Pawn;
    
    foreach Targets(ChkObject, )
    {
        Pawn = BioPawn(ChkObject);
        if (Pawn != None)
        {
            CreateWeapon(Pawn);
        }
    }
}
public function CreateWeapon(BioPawn Pawn)
{
    local BioInventory Inv;
    local BioItemWeaponRanged Weapon;
    
    if (m_sLabel == "")
    {
        m_sLabel = StandardLabel(m_eWeapon);
    }
    if (m_sLabel == "")
    {
        return;
    }
    Inv = Pawn.m_oBehavior.GetInventory();
    if (Inv != None)
    {
        Weapon = BioItemWeaponRanged(Class'BioItemImporter'.static.LoadGameItemByLabel(m_sLabel, byte(m_nLevel), 'None', Inv, m_nManufacturer));
        if (Weapon != None)
        {
            Pawn.m_oBehavior.m_oItemInterface.SetQuickSlot(Weapon.m_eWeaponRangedType, Inv.Add(Weapon));
        }
    }
}
public function string StandardLabel(EBioItemWeaponRangedType Type)
{
    switch (Type)
    {
        case EBioItemWeaponRangedType.ITEM_WEAPON_RANGED_PISTOL:
            return "Pistol";
            break;
        case EBioItemWeaponRangedType.ITEM_WEAPON_RANGED_SHOTGUN:
            return "Shotgun";
            break;
        case EBioItemWeaponRangedType.ITEM_WEAPON_RANGED_ASSAULT_RIFLE:
            return "Assault_Rifle";
            break;
        case EBioItemWeaponRangedType.ITEM_WEAPON_RANGED_SNIPER:
            return "Sniper_Rifle";
            break;
        default:
    }
    return "";
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
                      LinkDesc = "Label", 
                      ExpectedType = Class'SeqVar_String', 
                      LinkVar = 'None', 
                      PropertyName = 'm_sWeaponLabel', 
                      CachedProperty = None, 
                      MinVars = 1, 
                      MaxVars = 1, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}