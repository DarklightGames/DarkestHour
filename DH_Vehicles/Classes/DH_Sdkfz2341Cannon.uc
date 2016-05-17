//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Sdkfz2341Cannon extends DHVehicleCannon;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc3.usx

var     bool    bMixedMagFireAP; // flags that a mixed AP/HE mag is due to fire an AP round

// Extra collision static mesh actors for the mesh covers over turret, which open & close like a hatch:
var     DHCollisionMeshActor  TurretCoverColMeshLeft;
var     DHCollisionMeshActor  TurretCoverColMeshRight;
var     StaticMesh            TurretCoverColStaticMeshLeft;
var     StaticMesh            TurretCoverColStaticMeshRight;

// Modified to attach 2 extra collision static mesh actors, to represent the mesh covers over the turret, which open & close like a hatch as the player unbuttons/buttons
// These collision actors are set so they won't stop bullets or blast damage, as they are only mesh, but will stop grenades, as they were designed for
// Using literals as it isn't worth defining variables for one specific vehicle
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // Matt: I would use SM literals here, as it's a one-off, but for some strange reason it won't compile ("Missing StaticMesh name")
    // The #exec OBJ LOAD FILE directive should fix that, but it seems to have no effect, so I've had to add variables for the SMs
    TurretCoverColMeshLeft = class'DHCollisionMeshActor'.static.AttachCollisionMesh(self, TurretCoverColStaticMeshLeft, 'com_hatch_L');
    TurretCoverColMeshRight = class'DHCollisionMeshActor'.static.AttachCollisionMesh(self, TurretCoverColStaticMeshRight, 'com_hatch_R');

    if (TurretCoverColMeshLeft != none)
    {
        TurretCoverColMeshLeft.bWontStopBullet = true;
        TurretCoverColMeshLeft.bWontStopBlastDamage = true;
    }

    if (TurretCoverColMeshRight != none)
    {
        TurretCoverColMeshRight.bWontStopBullet = true;
        TurretCoverColMeshRight.bWontStopBlastDamage = true;
    }
}

// Modified to include extra collision static mesh actors (not actually effects, but convenient to add here)
simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (TurretCoverColMeshLeft != none)
    {
        TurretCoverColMeshLeft.Destroy();
    }

    if (TurretCoverColMeshRight != none)
    {
        TurretCoverColMeshRight.Destroy();
    }
}

// Modified to alternate between AP & HE rounds if firing a mixed mag (the tertiary ammo type)
state ProjectileFireMode
{
    function Fire(Controller C)
    {
        if (ProjectileClass == PrimaryProjectileClass)
        {
            if (bMixedMagFireAP)
            {
                SpawnProjectile(SecondaryProjectileClass, false);
            }
            else
            {
                SpawnProjectile(TertiaryProjectileClass, false);
            }

            bMixedMagFireAP = !bMixedMagFireAP;
        }
        else
        {
            SpawnProjectile(ProjectileClass, false);
        }
    }
}

// Modified so if we're loading a new mixed mag, we reset the 1st shot to be the default AP or HE round
function AttemptReload()
{
    super.AttemptReload();

    if (ReloadState == RL_Empty && ProjectileClass == PrimaryProjectileClass && Role == ROLE_Authority)
    {
        bMixedMagFireAP = default.bMixedMagFireAP;
    }
}

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext'
    Skins(0)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_dunk'
    Skins(1)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_dunk'
    Skins(2)=texture'Weapons1st_tex.MG.mg42_barrel'
    Skins(3)=texture'Weapons1st_tex.MG.mg42'
    CollisionStaticMesh=StaticMesh'DH_German_vehicles_stc3.234.234_turret_coll'
    TurretCoverColStaticMeshLeft=StaticMesh'DH_German_vehicles_stc3.234.234_TurretCoverLeft_coll'
    TurretCoverColStaticMeshRight=StaticMesh'DH_German_vehicles_stc3.234.234_TurretCoverRight_coll'
    FireEffectScale=1.3 // turret fire is larger & positioned in centre of open turret
    FireEffectOffset=(X=20.0,Y=-25.0,Z=10.0)

    // Turret armor
    FrontArmorFactor=0.8
    RightArmorFactor=0.8
    LeftArmorFactor=0.8
    RearArmorFactor=0.8
    FrontArmorSlope=30.0
    RightArmorSlope=30.0
    LeftArmorSlope=30.0
    RearArmorSlope=30.0
    FrontLeftAngle=306.0
    FrontRightAngle=54.0
    RearRightAngle=130.0
    RearLeftAngle=230.0

    // Turret movement
    ManualRotationsPerSecond=0.04
    CustomPitchUpLimit=12743
    CustomPitchDownLimit=64443

    // Cannon ammo
    bUsesMags=true
    ProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellMixed'
    PrimaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellMixed'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShell'
    TertiaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellHE'
    ProjectileDescriptions(0)="Mixed"
    ProjectileDescriptions(1)="AP"
    ProjectileDescriptions(2)="HE-T"
    NumPrimaryMags=15
    NumSecondaryMags=15
    NumTertiaryMags=15
    InitialPrimaryAmmo=10
    InitialSecondaryAmmo=10
    InitialTertiaryAmmo=10
    Spread=0.003

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_MG42Bullet''
    InitialAltAmmo=150
    NumMGMags=12
    TracerProjectileClass=class'DH_Weapons.DH_MG42TracerBullet'
    TracerFrequency=7

    // Weapon fire
    FireInterval=0.2
    WeaponFireOffset=8.5
    AltFireInterval=0.05
    AltFireOffset=(X=-65.0,Y=-24.0,Z=-3.0)
    FlashEmitterClass=class'ROEffects.MuzzleFlash3rdSTG'
    EffectEmitterClass=none
    CannonDustEmitterClass=none // avoids having to override FlashMuzzleFlash function
    AIInfo(0)=(RefireRate=0.99)

    // Screen shake
    ShakeRotMag=(Z=5.0)
    ShakeRotRate=(Z=100.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(Z=0.5)
    ShakeOffsetRate=(Z=10.0)
    ShakeOffsetTime=2.0
    AltShakeRotMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeRotRate=(X=1000.0,Y=1000.0,Z=1000.0)

    // Sounds (HUDProportion overrides to better suit the magazine reload)
    CannonFireSound(0)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire01G'
    CannonFireSound(1)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire02G'
    CannonFireSound(2)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire03G'
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
    ReloadStages(0)=(Sound=sound'Vehicle_reloads.Reloads.T60_reload_01')
    ReloadStages(1)=(Sound=sound'DH_GerVehicleSounds2.Reloads.234_reload_02',HUDProportion=0.6)
    ReloadStages(2)=(Sound=sound'DH_GerVehicleSounds2.Reloads.234_reload_03')
    ReloadStages(3)=(Sound=sound'Vehicle_reloads.Reloads.T60_reload_04',HUDProportion=0.4)

    // Cannon range settings
    RangeSettings(1)=100
    RangeSettings(2)=200
    RangeSettings(3)=300
    RangeSettings(4)=400
    RangeSettings(5)=500
    RangeSettings(6)=600
    RangeSettings(7)=700
    RangeSettings(8)=800
    RangeSettings(9)=900
    RangeSettings(10)=1000
    RangeSettings(11)=1100
    RangeSettings(12)=1200
}
