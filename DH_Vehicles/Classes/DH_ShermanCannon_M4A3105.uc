//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanCannon_M4A3105 extends DH_ROTankCannon;


// Special tracer handling for this type of cannon
simulated function UpdateTracer()
{
    local rotator SpawnDir;

    if (Level.NetMode == NM_DedicatedServer || !bUsesTracers)
        return;


    if (Level.TimeSeconds > mLastTracerTime + mTracerInterval)
    {
        if (Instigator != none && Instigator.IsLocallyControlled())
        {
            SpawnDir = WeaponFireRotation;
        }
        else
        {
            SpawnDir = GetBoneRotation(WeaponFireAttachmentBone);
        }

        if (Instigator != none && !Instigator.PlayerReplicationInfo.bBot)
        {
            SpawnDir.Pitch += AddedPitch;
        }

        Spawn(DummyTracerClass,,, WeaponFireLocation, SpawnDir);

        mLastTracerTime = Level.TimeSeconds;
    }
}


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
     InitialTertiaryAmmo=6
     TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellSmoke'
     SecondarySpread=0.003000
     TertiarySpread=0.003600
     ManualRotationsPerSecond=0.012500
     PoweredRotationsPerSecond=0.012500
     FrontArmorFactor=9.000000
     RightArmorFactor=5.100000
     LeftArmorFactor=5.100000
     RearArmorFactor=2.500000
     RightArmorSlope=5.000000
     LeftArmorSlope=5.000000
     FrontLeftAngle=316.000000
     FrontRightAngle=44.000000
     RearRightAngle=136.000000
     RearLeftAngle=224.000000
     ReloadSoundOne=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_01'
     ReloadSoundTwo=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_02'
     ReloadSoundThree=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_03'
     ReloadSoundFour=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_04'
     CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
     CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
     CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
     ProjectileDescriptions(0)="HEAT"
     ProjectileDescriptions(2)="Smoke"
     RangeSettings(1)=400
     RangeSettings(2)=800
     RangeSettings(3)=1200
     RangeSettings(4)=1600
     RangeSettings(5)=2000
     RangeSettings(6)=2400
     RangeSettings(7)=2800
     RangeSettings(8)=3200
     RangeSettings(9)=4200
     AddedPitch=340
     ReloadSound=Sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
     NumAltMags=5
     DummyTracerClass=class'DH_Vehicles.DH_30CalVehicleClientTracer'
     mTracerInterval=0.600000
     bUsesTracers=true
     bAltFireTracersOnly=true
     MinCommanderHitHeight=45.0;
     VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=6.000000))
     VehHitpoints(1)=(PointRadius=12.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=-5.000000))
     hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
     YawBone="Turret"
     PitchBone="Gun"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Barrel"
     GunnerAttachmentBone="com_attachment"
     WeaponFireOffset=12.000000
     AltFireOffset=(X=-70.000000,Y=-17.000000,Z=7.500000)
     RotationsPerSecond=0.012500
     bAmbientAltFireSound=true
     Spread=0.002250
     FireInterval=10.000000
     AltFireInterval=0.120000
     EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
     AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
     bAmbientEmitterAltFireOnly=true
     FireSoundVolume=512.000000
     AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_loop01'
     AltFireSoundScaling=3.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
     AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_end01'
     FireForce="Explosion05"
     ProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHEAT'
     AltFireProjectileClass=class'DH_Vehicles.DH_30CalVehicleBullet'
     ShakeRotMag=(Z=50.000000)
     ShakeRotRate=(Z=1000.000000)
     ShakeRotTime=4.000000
     ShakeOffsetMag=(Z=1.000000)
     ShakeOffsetRate=(Z=100.000000)
     ShakeOffsetTime=10.000000
     AltShakeRotMag=(X=0.010000,Y=0.010000,Z=0.010000)
     AltShakeRotRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     AltShakeRotTime=2.000000
     AltShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
     AltShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     AltShakeOffsetTime=2.000000
     AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
     AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
     CustomPitchUpLimit=6372
     CustomPitchDownLimit=63716
     BeginningIdleAnim="com_idle_close"
     InitialPrimaryAmmo=15
     InitialSecondaryAmmo=45
     InitialAltAmmo=200
     PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHEAT'
     SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHE'
     Mesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3105_turret_ext'
     Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.Sherman_105_ext'
     SoundVolume=200
     SoundRadius=50.000000
}
