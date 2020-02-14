//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_C96Fire extends DHFastAutoFire;

// Overridden here to allow semi auto fire sound handling for a FastAuto weapon class
// This is an extremely messy & inefficient way of doing this, however it works - Ch!cken
// TODO: (Matt, Oct 2017) Have greatly simplified this, but suspect we could just make it so we only enter this state if firing auto,
//                        then in SpawnProjectile() we only do the packed shot info stuff if firing full auto
state FireLoop
{
    function BeginState()
    {
        if (!bWaitForRelease) // if we've been set to bWaitForRelease, it means semi-atuo fire mode is selected
        {
            super.BeginState();
        }
    }

    function ServerPlayFiring()
    {
        if (bWaitForRelease)
        {
            global.ServerPlayFiring();
        }
    }

    function PlayFiring()
    {
        if (bWaitForRelease)
        {
            global.PlayFiring();
        }
    }

    function PlayFireEnd()
    {
        if (bWaitForRelease)
        {
            global.PlayFireEnd();
        }
    }

    function EndState()
    {
        if (!bWaitForRelease)
        {
            super.EndState();
        }
    }
}

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_C96Bullet'
    AmmoClass=class'DH_Weapons.DH_C96Ammo'
    FireRate=0.066666 // 900rpm
    Spread=180.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=275
    MaxHorizontalRecoilAngle=120
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.5),(InVal=3.0,OutVal=0.66),(InVal=6.0,OutVal=1.3),(InVal=15.0,OutVal=1.5),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=10.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.c96.C96_FireLoop01'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle02'
    FireEndSound=SoundGroup'DH_WeaponSounds.c96.C96_FireEnd01'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellRotOffsetIron=(Pitch=5000)
    // TODO: in semi-auto fire mode the ejected 1st person shells eject the wrong way (to the left, instead of to the right as for auto fire or when using ironsights
}
