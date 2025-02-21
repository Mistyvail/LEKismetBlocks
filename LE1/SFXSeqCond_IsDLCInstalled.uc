Class SFXSeqCond_IsDLCInstalled extends SequenceCondition;

var(SFXSeqCond_IsDLCInstalled) string m_sDLCFolderName;

public function Activated()
{
    local string Tlk;
    
    Tlk = m_sDLCFolderName $ "_GlobalTlk.GlobalTlk_tlk";
    if (FindTLK(Tlk) || FindTLK("DLC_MOD_" $ Tlk))
    {
        OutputLinks[0].bHasImpulse = TRUE;
    }
    else
    {
        OutputLinks[1].bHasImpulse = TRUE;
    }
}
public function bool FindTLK(string Path)
{
    return DynamicLoadObject(Path, Class'BioTlkFile') != None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bManualHandleOutputs = TRUE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "True", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    ActivateDelay = 0.0, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "False", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    ActivateDelay = 0.0, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
}
