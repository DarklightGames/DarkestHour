//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBulletWhizUFO extends ROBulletWhiz;

simulated function PostBeginPlay()
{
    PlayOwnedSound(WhizSound, SLOT_None, 30.0, false, 500.0, 1.0, true);
}

defaultproperties
{
    WhizSound=Sound'DH_UFO_snd.UFO.Graze'
}
