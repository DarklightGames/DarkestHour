//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DO_Pawn extends DH_Pawn;

var string RandomFaceArray[4];

static function xUtil.PlayerRecord GetModelRecord()
{
    local xUtil.PlayerRecord RecordToReturn;

    RecordToReturn.Sex = "Male";
    RecordToReturn.Menu = "ROSP";
    RecordToReturn.Tactics = "2.0";
    RecordToReturn.CombatStyle = "1";
    RecordToReturn.StrafingAbility = "-2.0";
    RecordToReturn.Accuracy = ".5";
    RecordToReturn.RagDoll = "German_tunic";
    RecordToReturn.BotUse = 1;
    RecordToReturn.Race = "Soviet";

    return RecordToReturn;
}

// MergeTODO: Replace xUtil with ROUtil
simulated function Setup(xUtil.PlayerRecord rec, optional bool bLoadNow)
{
    //Level.Game.Broadcast(self, "Calling Setup in DO_Pawn!", 'Say');

    if ( (rec.Species == None) || ForceDefaultCharacter() )
    {
        //Level.Game.Broadcast(self, "No species was found, getting default character", 'Say');
        rec = class'xUtil'.static.FindPlayerRecord(GetDefaultCharacter());
    }

    rec = GetModelRecord();

    Species = rec.Species;
    RagdollOverride = rec.Ragdoll;

    if ( !Species.static.Setup(self,rec) )
    {
        //Level.Game.Broadcast(self, "WTF WTF WTF IS THIS DOING?", 'Say');
        rec = class'xUtil'.static.FindPlayerRecord(GetDefaultCharacter());
        if ( !Species.static.Setup(self,rec) )
            return;
    }
    ResetPhysicsBasedAnim();
}

defaultproperties
{

}
