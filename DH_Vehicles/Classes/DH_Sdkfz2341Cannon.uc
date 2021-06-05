//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_Sdkfz2341Cannon extends DHVehicleAutoCannon;

// Extra collision static mesh actors for the mesh covers over turret, which open & close like a hatch:
var     DHCollisionMeshActor  TurretCoverColMeshLeft;
var     DHCollisionMeshActor  TurretCoverColMeshRight;
var     StaticMesh            TurretCoverColStaticMeshLeft;
var     StaticMesh            TurretCoverColStaticMeshRight;

// Modified to attach 2 extra collision static mesh actors, to represent the mesh covers over the turret, which open & close like a hatch as the player unbuttons/buttons
// These collision actors are set so they won't stop bullets or blast damage, as they are only mesh, but will stop grenades, as they were designed for
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // Matt: would use SM literals here as it's a one-off, but weirdly it won't compile ("Missing StaticMesh name") because mesh and/or group name begin with a number!
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

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_dunk'
    Skins(1)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_dunk'
    Skins(2)=Texture'Weapons1st_tex.MG.mg42_barrel'
    Skins(3)=Texture'Weapons1st_tex.MG.mg42'
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
    ProjectileClass=class'DH_Engine.DHCannonShell_MixedMag'
    PrimaryProjectileClass=class'DH_Engine.DHCannonShell_MixedMag'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShell'
    TertiaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellHE'

    ProjectileDescriptions(0)="Mixed"
    ProjectileDescriptions(1)="AP"
    ProjectileDescriptions(2)="HE-T"

    nProjectileDescriptions(0)="PzGr.+Sprgr.39"
    nProjectileDescriptions(1)="PzGr."
    nProjectileDescriptions(2)="Sprgr.39"


    NumPrimaryMags=15
    NumSecondaryMags=15
    NumTertiaryMags=15
    InitialPrimaryAmmo=10
    InitialSecondaryAmmo=10
    InitialTertiaryAmmo=10

    // Coaxial MG ammo
    AltFireProjectileClass=class'DH_Weapons.DH_MG42Bullet'
    InitialAltAmmo=150
    NumMGMags=12
    TracerProjectileClass=class'DH_Weapons.DH_MG42TracerBullet'
    TracerFrequency=7

    // Weapon fire
    FireInterval=0.2
    WeaponFireOffset=2.5 // 8.5
    AltFireInterval=0.05
    AltFireOffset=(X=-65.0,Y=-24.0,Z=-3.0)

    // Sounds
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'

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
