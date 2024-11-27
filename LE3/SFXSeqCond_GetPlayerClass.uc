Class SFXSeqCond_GetPlayerClass extends SequenceCondition;

public function Activated()
{
    local WorldInfo WI;
    local PlayerController PC;
    local SFXPawn_Player PlayerPawn;
    
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI != None)
    {
        PC = WI.GetALocalPlayerController();
        if (PC != None)
        {
            PlayerPawn = SFXPawn_Player(PC.Pawn);
            ActivateOutputLink(GetClass(PlayerPawn.Class));
        }
    }
}
public function int GetClass(Class<Pawn> PlayerPawn)
{
    if (Class<SFXPawn_PlayerSoldier>(PlayerPawn) != None || Class<SFXPawn_PlayerSoldierNonCombat>(PlayerPawn) != None)
    {
        return 0;
    }
    if (Class<SFXPawn_PlayerEngineer>(PlayerPawn) != None || Class<SFXPawn_PlayerEngineerNonCombat>(PlayerPawn) != None)
    {
        return 1;
    }
    if (Class<SFXPawn_PlayerAdept>(PlayerPawn) != None || Class<SFXPawn_PlayerAdeptNonCombat>(PlayerPawn) != None)
    {
        return 2;
    }
    if (Class<SFXPawn_PlayerInfiltrator>(PlayerPawn) != None || Class<SFXPawn_PlayerInfiltratorNonCombat>(PlayerPawn) != None)
    {
        return 3;
    }
    if (Class<SFXPawn_PlayerSentinel>(PlayerPawn) != None || Class<SFXPawn_PlayerSentinelNonCombat>(PlayerPawn) != None)
    {
        return 4;
    }
    if (Class<SFXPawn_PlayerVanguard>(PlayerPawn) != None || Class<SFXPawn_PlayerVanguardNonCombat>(PlayerPawn) != None)
    {
        return 5;
    }
    return 0;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
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
