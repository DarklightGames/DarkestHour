//=============================================================================
// DH_BulletWhiz
//=============================================================================
// A bullet whiz sound effect
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2003-2004 John Gibson
//============================================================================

class DH_BulletWhiz extends ROBulletWhiz;

#exec OBJ LOAD FILE=DH_ProjectileSounds.uax

simulated function PostBeginPlay()
{
	PlayOwnedSound( WhizSound, SLOT_None, 30.0, false, 500.0, 1.0, true);
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     WhizSound=SoundGroup'DH_ProjectileSounds.Bullets.Bullet_Whiz'
}
