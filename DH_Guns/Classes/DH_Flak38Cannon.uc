//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38Cannon extends DH_Sdkfz2341Cannon;

#exec OBJ LOAD FILE=..\Animations\DH_Flak38_anm.ukx

var  name  SightBone;

// New function to update sight rotation, called by cannon pawn when gun pitch changes
simulated function UpdateSightRotation()
{
    local rotator SightRotation;

    SightRotation.Pitch = -CurrentAim.Pitch;
    SetBoneRotation(SightBone, SightRotation, 1);
}

// Added the following functions from DHATGunCannon, as parent Sd.Kfz.234/1 armoured car cannon extends DHVehicleCannon:
simulated function bool DHShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
   return true;
}

defaultproperties
{
    NumMags=12
    NumSecMags=4
    NumTertMags=4
    AddedPitch=50
    WeaponFireOffset=15.0
    RotationsPerSecond=0.05
    FireInterval=0.15
    FlashEmitterClass=class'DH_Guns.DH_Flak38MuzzleFlash'
    ProjectileClass=class'DH_Guns.DH_Flak38CannonShellMixed'
    AltFireProjectileClass=none
    CustomPitchUpLimit=15474
    CustomPitchDownLimit=64990
    InitialPrimaryAmmo=40
    InitialSecondaryAmmo=40
    InitialTertiaryAmmo=40
    PrimaryProjectileClass=class'DH_Guns.DH_Flak38CannonShellMixed'
    SecondaryProjectileClass=class'DH_Guns.DH_Flak38CannonShellAP'
    TertiaryProjectileClass=class'DH_Guns.DH_Flak38CannonShellHE'
    bLimitYaw=true // when on trailer, the wheels block much traverse
    YawStartConstraint=-3500.0
    YawEndConstraint=5000.0
    MaxPositiveYaw=4200
    MaxNegativeYaw=-2650
    SightBone="arm"
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret'
    Skins(0)=texture'DH_Artillery_tex.Flak38.Flak38_gun'
}
