//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_AT57Cannon extends DH_ATGunCannon;

#exec OBJ LOAD FILE=..\Sounds\DH_ArtillerySounds.uax

// American tanks must use the actual sight markings to aim!
simulated function int GetRange()
{
    return RangeSettings[0];
}

// Disable clicking sound for range adjustment
function IncrementRange()
{
    if (CurrentRangeIndex < RangeSettings.Length - 1)
    {
        if (Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none)
            //ROPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,,SLOT_Interface);

        CurrentRangeIndex++;
    }
}

function DecrementRange()
{
    if (CurrentRangeIndex > 0)
    {
        if (Instigator != none && Instigator.Controller != none && ROPlayer(Instigator.Controller) != none)
            //ROPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,,SLOT_Interface);

        CurrentRangeIndex --;
    }
}

defaultproperties
{
     SecondarySpread=0.001250
     ReloadSoundOne=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
     ReloadSoundTwo=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
     ReloadSoundThree=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
     CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
     CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
     CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
     ProjectileDescriptions(0)="APC"
     AddedPitch=-15
     YawBone="Turret"
     YawStartConstraint=-7000.000000
     YawEndConstraint=7000.000000
     PitchBone="Gun"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Barrel"
     GunnerAttachmentBone="com_player"
     WeaponFireOffset=20.000000
     RotationsPerSecond=0.025000
     FireInterval=3.000000
     EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
     FireSoundVolume=512.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     FireForce="Explosion05"
     ProjectileClass=class'DH_Guns.DH_AT57CannonShell'
     ShakeRotMag=(Z=110.000000)
     ShakeRotRate=(Z=1000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Z=5.000000)
     ShakeOffsetRate=(Z=100.000000)
     ShakeOffsetTime=2.000000
     AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
     CustomPitchUpLimit=2731
     CustomPitchDownLimit=64626
     MaxPositiveYaw=6000
     MaxNegativeYaw=-6000
     bLimitYaw=true
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=60
     InitialSecondaryAmmo=25
     PrimaryProjectileClass=class'DH_Guns.DH_AT57CannonShell'
     SecondaryProjectileClass=class'DH_Guns.DH_AT57CannonShellHE'
     Mesh=SkeletalMesh'DH_AT57_anm.AT57_turret'
     Skins(0)=Texture'DH_Artillery_Tex.57mmGun.57mmGun'
     Skins(1)=Texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle_MN'
     SoundVolume=130
     SoundRadius=200.000000
}
