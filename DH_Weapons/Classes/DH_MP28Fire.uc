//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MP28Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MP28Bullet'
    AmmoClass=class'ROAmmo.MP32Rd9x19Ammo'
    FireRate=0.104 // ~580rpm
    Spread=135.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=260
    MaxHorizontalRecoilAngle=70
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.4),(InVal=3.0,OutVal=0.6),(InVal=6.0,OutVal=1.15),(InVal=12.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0))))
    RecoilFallOffFactor=14.0

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'MNInfantryWeapons_sound.Sten.StenFire01'
    FireSounds(1)=SoundGroup'MNInfantryWeapons_sound.Sten.StenFire02'
    FireSounds(2)=SoundGroup'MNInfantryWeapons_sound.Sten.StenFire03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
}
