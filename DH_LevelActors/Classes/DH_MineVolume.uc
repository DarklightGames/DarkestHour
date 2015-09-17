//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_MineVolume extends DHMineVolume;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    Level.Game.Broadcast(self, "Level uses DH_MineVolume, but should be using DHMineVolume!!!", 'Say');
    Warn("Please change the minefield types to DHMineVolume instead of DH_MineVolume.");
}

defaultproperties
{
}