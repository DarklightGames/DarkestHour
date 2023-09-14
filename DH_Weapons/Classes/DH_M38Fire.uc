//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M38Fire extends DH_M44Fire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M38Bullet'
    AmmoClass=class'DH_Weapons.DH_MN9130Ammo'
    FAProjSpawnOffset=(X=-30.0)
    Spread=55.0
    MaxVerticalRecoilAngle=1550
    MaxHorizontalRecoilAngle=200
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stKar'
    ShellRotOffsetHip=(Pitch=5000)
    ShakeRotMag=(X=50.0,Y=50.0,Z=350.0)
    ShakeRotTime=2.5
}
