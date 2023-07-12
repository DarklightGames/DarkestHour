//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletWhiz extends ROBulletWhiz;

#exec OBJ LOAD FILE=DH_ProjectileSounds.uax

simulated function PostBeginPlay()
{
    PlayOwnedSound(WhizSound, SLOT_None, 30.0, false, 500.0, 1.0, true);
}

defaultproperties
{
    WhizSound=SoundGroup'DH_ProjectileSounds.Bullets.Bullet_Whiz'
}
