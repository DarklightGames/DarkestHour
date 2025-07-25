//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_FG42Fire extends DHAutomaticFire; // TODO: could maybe use DHFastAutoFire/DHHighROFWeaponAttachment as fires at 750 rpm (higher than PPs-43 SMG's 700 rpm, which does use fast auto)

// Modifies to set the bolt mode based on the firing mode.
function PlayFiring()
{
    local DH_FG42Weapon W;

    super.PlayFiring();

    W = DH_FG42Weapon(Weapon);

    if (W != none)
    {
        if (W.GetFireMode(0).bWaitForRelease)
        {
            // Semi-automatic mode, closed bolt.
            W.SetBoltMode(BM_Closed);
        }
        else
        {
            // Fully-automatic, open bolt.
            W.SetBoltMode(BM_Open);
        }
    }
}

defaultproperties
{
    ProjectileClass=Class'DH_FG42Bullet'
    AmmoClass=Class'DH_FG42Ammo'
    FireRate=0.075 // 888 rpm (value had to be found experimentally due to an engine bug)
    bHasSemiAutoFireRate=true
    bWaitForRelease=true    // semi-automatic by default
    SemiAutoFireRate=0.2
    FAProjSpawnOffset=(X=-28.0)

    // Spread
    Spread=65.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=520
    MaxHorizontalRecoilAngle=180
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.6),(InVal=3.0,OutVal=0.75),(InVal=9.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    PctProneIronRecoil=0.50
    PctRestDeployRecoil=0.50
    PctBipodDeployRecoil=0.30

    FireSounds(0)=SoundGroup'DH_WeaponSounds.FG42_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.FG42_Fire02'

    // TODO: this "loop" nonsense is a headache! only fast-fire weapons should have looping fire animations
    FireLoopAnim="shoot"
    FireAnim="shoot"
    FireIronLoopAnim="iron_shoot"
    FireIronAnim="iron_shoot"

    BipodDeployFireAnim="deploy_shoot"
    BipodDeployFireLoopAnim="deploy_shoot"

    ShellEjectClass=Class'ShellEject1st762x54mm'
    ShellIronSightOffset=(X=20.0,Y=0.0,Z=-2.0)
    ShellRotOffsetIron=(Pitch=500)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    bReverseShellSpawnDirection=true

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=220.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=1.2
}
