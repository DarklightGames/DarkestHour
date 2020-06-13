//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_M712Fire extends DHAutomaticFire;

//this weapon has rate of fire 900 RPM, but small 20rnd magazine so it should be ok i think
//i really didnt like the original c96 full auto sound, so i replaced it with a different sound that is single fire only, which is another reason why i made it "DHAutomaticFire"

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M712Bullet'
    AmmoClass=class'DH_Weapons.DH_M712Ammo'
    FireRate=0.066666 // 900rpm
    Spread=180.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=275
    MaxHorizontalRecoilAngle=120
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.5),(InVal=3.0,OutVal=0.66),(InVal=6.0,OutVal=1.3),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=10.0

    FireSounds(0)=SoundGroup'DH_old_inf_weapons.C96.c96_shot1'
    FireSounds(1)=SoundGroup'DH_old_inf_weapons.C96.c96_shot2'

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellRotOffsetIron=(Pitch=5000)

}