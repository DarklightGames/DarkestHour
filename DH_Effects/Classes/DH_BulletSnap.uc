//=============================================================================
// DH_BulletSnap
//=============================================================================
// A supersonic bullet snap sound effect
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2003-2004 John Gibson
//============================================================================

class DH_BulletSnap extends ROBulletWhiz;

#exec OBJ LOAD FILE=DH_ProjectileSounds.uax

simulated function PostBeginPlay()
{
    PlayOwnedSound(WhizSound, SLOT_none, 30.0, false, 500.0, 1.0, true);
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     WhizSound=SoundGroup'DH_ProjectileSounds.Bullets.Bullet_Snap'
}
