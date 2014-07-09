//=============================================================================
// DH_ObjSatchel
//=============================================================================

class DH_ObjSatchel extends ROObjSatchel
	placeable;

//=============================================================================
// Functions
//=============================================================================

//-----------------------------------------------------------------------------
// HandleCompletion - Overridden
//-----------------------------------------------------------------------------

function HandleCompletion(PlayerReplicationInfo CompletePRI, int Team)
{
	bActive = false;

	if (CompletePRI != None)
	{
        Level.Game.ScoreObjective(CompletePRI, 10);
	}

	BroadcastLocalizedMessage(class'DHObjectiveMsg', Team + 2, None, None, self);
    /*
	// Notify our analytics server.
	if(DarkestHourGame(Level.Game) != none && DarkestHourGame(Level.Game).Analytics != none)
		DarkestHourGame(Level.Game).Analytics.NotifyCapture(self, Team);\
	*/
}


//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
}
