//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MineVolume extends DHMineVolume;

function PostBeginPlay()
{
    super.PostBeginPlay();

    Level.Game.Broadcast(self, "Level uses DH_MineVolume, but should be using DHMineVolume!!!", 'Say');
    Warn("Please change the minefield types to DHMineVolume instead of DH_MineVolume.");
}
