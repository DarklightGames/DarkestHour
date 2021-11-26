//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M1928_30rndFire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_ThompsonBullet'
    AmmoClass=class'DH_Weapons.DH_ThompsonAmmo'
    FireRate=0.073 // ~800rpm
    Spread=140.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=270
    MaxHorizontalRecoilAngle=85
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.33),(InVal=2.0,OutVal=0.6),(InVal=5.0,OutVal=0.7),(InVal=9.0,OutVal=1.2),(InVal=20.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=12.0

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    AmbientFireSound=SoundGroup'DH_MN_InfantryWeapons_sound.Thompson.Thompson_fireloop'
    FireEndSound=SoundGroup'DH_MN_InfantryWeapons_sound.Thompson.Thompson_fireend1'
    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.Thompson.Thompson_fire01'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.Thompson.Thompson_fire02'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.Thompson.Thompson_fire03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    //PreFireAnim="Shoot1_start"

    //EjectedShellParams
    ShellCaseEjectClass=class'DH_Effects.DHShellEject1st9x19mm'
    //ShellEjectOffset=(X=0.0,Y=-1.0,Z=0.0)
    ShellVelMinX=200.0
    ShellVelMaxX=300.0
    ShellVelMinY=50.0 //200
    ShellVelMaxY=-50.0 //300.0
    ShellVelMinZ=-25.0
    ShellVelMaxZ=25.0)
}
