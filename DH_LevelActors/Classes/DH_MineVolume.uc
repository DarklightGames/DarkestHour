//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MineVolume extends DHMineVolume;

function PostBeginPlay()
{
    super.PostBeginPlay();

    Level.Game.Broadcast(self, "Level uses DH_MineVolume, but should be using DHMineVolume!!!", 'Say');
    Warn("Please change the minefield types to DHMineVolume instead of DH_MineVolume.");
}
