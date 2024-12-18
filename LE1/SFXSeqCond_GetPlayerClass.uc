Class SFXSeqCond_GetPlayerClass extends SequenceCondition;

public function Activated()
{
    local WorldInfo WI;
    local PlayerController PC;
    local BioPawn PlayerPawn;
    
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI != None)
    {
        PC = WI.GetALocalPlayerController();
        if (PC != None)
        {
            PlayerPawn = BioPawn(PC.Pawn);
            ActivateOutputLink(GetClass(PlayerPawn));
        }
    }
}
public function int GetClass(BioPawn PlayerPawn)
{
    local EBioPartyMemberClassBase PlayerClass;
    
    PlayerClass = PlayerPawn.m_oBehavior.GetClass();
    if (PlayerClass == EBioPartyMemberClassBase.BIO_PARTY_MEMBER_CLASS_BASE_SOLDIER || int(PlayerClass) == 13)
    {
        return 0;
    }
    if (PlayerClass == EBioPartyMemberClassBase.BIO_PARTY_MEMBER_CLASS_BASE_ENGINEER || int(PlayerClass) == 14)
    {
        return 1;
    }
    if (PlayerClass == EBioPartyMemberClassBase.BIO_PARTY_MEMBER_CLASS_BASE_ADEPT || int(PlayerClass) == 15)
    {
        return 2;
    }
    if (PlayerClass == EBioPartyMemberClassBase.BIO_PARTY_MEMBER_CLASS_BASE_INFILTRATOR || int(PlayerClass) == 16)
    {
        return 3;
    }
    if (PlayerClass == EBioPartyMemberClassBase.BIO_PARTY_MEMBER_CLASS_BASE_SAVANT || int(PlayerClass) == 17)
    {
        return 4;
    }
    if (PlayerClass == EBioPartyMemberClassBase.BIO_PARTY_MEMBER_CLASS_BASE_REAVER || int(PlayerClass) == 18)
    {
        return 5;
    }
    return 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bManualHandleOutputs = TRUE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Soldier", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Engineer", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Adept", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Infiltrator", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Sentinel", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Vanguard", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
}
