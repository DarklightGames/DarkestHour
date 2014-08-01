/*
Primary function of this was just to act as our mortar spawn.  For
posterity, I'll just call it the DH spawn area so anyone extending it doesn't
have to have to feel weird about extending it.
-Colin Basnett, 2010
*/
class DHSpawnArea extends ROSpawnArea
	placeable;

var()	bool	bMortarmanSpawnArea;
var()   bool    bReconnaissanceSpawnArea;

function PostBeginPlay()
{
	if (DarkestHourGame(Level.Game) != none)
	{
		if (bTankCrewSpawnArea)
			DarkestHourGame(Level.Game).TankCrewSpawnAreas[DarkestHourGame(Level.Game).TankCrewSpawnAreas.Length] = self;
		else if (bMortarmanSpawnArea)
			DarkestHourGame(Level.Game).DHMortarSpawnAreas[DarkestHourGame(Level.Game).DHMortarSpawnAreas.Length] = self;
		else if (bReconnaissanceSpawnArea)
			DarkestHourGame(Level.Game).DHReconSpawnAreas[DarkestHourGame(Level.Game).DHReconSpawnAreas.Length] = self;
		else
			DarkestHourGame(Level.Game).SpawnAreas[DarkestHourGame(Level.Game).SpawnAreas.Length] = self;
	}

	if (VolumeTag != '')
	{
		foreach AllActors(class'Volume', AttachedVolume, VolumeTag)
		{
			AttachedVolume.AssociatedActor = self;
			break;
		}
	}

	Disable('Trigger');
}

defaultproperties
{
}
