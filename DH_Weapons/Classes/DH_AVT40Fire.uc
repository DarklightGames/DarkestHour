//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_AVT40Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_AVT40Bullet'
    AmmoClass=class'ROAmmo.SVT40Ammo'
	FireRate=0,085 // ~700rpm
    Spread=90.0
	
    RecoilRate=0.06
    MaxVerticalRecoilAngle=480
    MaxHorizontalRecoilAngle=210
	RecoilCurve=(Points=((InVal=0.0,OutVal=0.6),(InVal=5.0,OutVal=1.0),(InVal=12.0,OutVal=1.3),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=2.0
    RecoilFallOffFactor=12.0

    FireSounds(0)=Sound'Inf_Weapons.svt40.svt40_fire01'
    FireSounds(1)=Sound'Inf_Weapons.svt40.svt40_fire02'
    FireSounds(2)=Sound'Inf_Weapons.svt40.svt40_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'
    ShellEmitBone="ejector"
    ShellRotOffsetHip=(Pitch=-3000,Yaw=0,Roll=-3000)

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=200.0)
    ShakeRotRate=(X=12500.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
}
