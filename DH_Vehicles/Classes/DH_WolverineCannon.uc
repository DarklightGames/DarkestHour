//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WolverineCannon extends DH_ROTankCannon;


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
     InitialTertiaryAmmo=24
     TertiaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellHE'
     SecondarySpread=0.001000
     TertiarySpread=0.001350
     ManualRotationsPerSecond=0.010000
     PoweredRotationsPerSecond=0.010000
     FrontArmorFactor=5.700000
     RightArmorFactor=2.500000
     LeftArmorFactor=2.500000
     RearArmorFactor=2.500000
     FrontArmorSlope=45.000000
     RightArmorSlope=25.000000
     LeftArmorSlope=25.000000
     FrontLeftAngle=332.000000
     FrontRightAngle=28.000000
     RearRightAngle=152.000000
     RearLeftAngle=208.000000
     ReloadSoundOne=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
     ReloadSoundTwo=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
     ReloadSoundThree=Sound'DH_Vehicle_Reloads.Reloads.reload_02s_03'
     ReloadSoundFour=Sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
     CannonFireSound(0)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire01'
     CannonFireSound(1)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire02'
     CannonFireSound(2)=SoundGroup'Vehicle_Weapons.T34_85.85mm_fire03'
     ProjectileDescriptions(0)="APCBC"
     ProjectileDescriptions(1)="HVAP"
     ProjectileDescriptions(2)="HE"
     RangeSettings(1)=400
     RangeSettings(2)=800
     RangeSettings(3)=1200
     RangeSettings(4)=1600
     RangeSettings(5)=2000
     RangeSettings(6)=2400
     RangeSettings(7)=2800
     RangeSettings(8)=3200
     RangeSettings(9)=4200
     AddedPitch=52
     VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(X=15.000000,Y=6.000000,Z=3.000000))
     YawBone="Turret"
     PitchBone="Gun"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Gun"
     GunnerAttachmentBone="com_attachment"
     WeaponFireOffset=200.000000
     RotationsPerSecond=0.010000
     FireInterval=5.000000
     EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
     FireSoundVolume=512.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
     FireForce="Explosion05"
     ProjectileClass=class'DH_Vehicles.DH_WolverineCannonShell'
     ShakeRotMag=(Z=50.000000)
     ShakeRotRate=(Z=1000.000000)
     ShakeRotTime=4.000000
     ShakeOffsetMag=(Z=1.000000)
     ShakeOffsetRate=(Z=100.000000)
     ShakeOffsetTime=10.000000
     AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
     CustomPitchUpLimit=5461
     CustomPitchDownLimit=63715
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=25
     InitialSecondaryAmmo=5
     PrimaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShell'
     SecondaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellHVAP'
     Mesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext'
     Skins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.M10_turret_ext'
     Skins(1)=Texture'DH_VehiclesUS_tex.ext_vehicles.M10_turret_ext'
     Skins(2)=Texture'DH_VehiclesUS_tex.ext_vehicles.M10_turret_ext'
     Skins(3)=Texture'DH_VehiclesUS_tex.ext_vehicles.M10_turret_ext'
     Skins(4)=Texture'DH_VehiclesUS_tex.int_vehicles.M10_turret_int'
     Skins(5)=Texture'DH_VehiclesUS_tex.int_vehicles.M10_turret_int'
     Skins(6)=Texture'DH_VehiclesUS_tex.ext_vehicles.M10_turret_ext'
     SoundVolume=80
     SoundRadius=300.000000
}
