//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38Cannon extends DH_Sdkfz2341Cannon;

#exec OBJ LOAD FILE=..\Animations\DH_Flak38_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Flak38_tex.utx

var name                    SightBone;
var name                    TraverseWheelBone;
var name                    ElevationWheelBone;

simulated function Tick(float DeltaTime)
{
    local rotator SightRotation;
    local rotator ElevationWheelRotation;
    local rotator TraverseWheelRotation;

    // Sight
    SightRotation.Pitch = -CurrentAim.Pitch;
    SetBoneRotation(SightBone, SightRotation, 1);

    // Elevation wheel
    ElevationWheelRotation.Roll = -CurrentAim.Pitch * 32;
    SetBoneRotation(ElevationWheelBone, ElevationWheelRotation, 1);

    // Traverse wheel
    TraverseWheelRotation.Pitch = CurrentAim.Yaw * 32;
    SetBoneRotation(TraverseWheelBone, TraverseWheelRotation, 1);
}

// Modified to play shoot open or closed firing animation based on DriverPositionIndex, as all DriverPositionsan are always bExposed in an AT gun
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    local ROVehicleWeaponPawn OwningPawn;

    if (Role == ROLE_Authority)
    {
        FiringMode = byte(bWasAltFire);
        FlashCount++;
        NetUpdateTime = Level.TimeSeconds - 1.0;
    }
    else
    {
        CalcWeaponFire(bWasAltFire);
    }

    if (Level.NetMode != NM_DedicatedServer && !bWasAltFire)
    {
        if (FlashEmitter != none)
        {
            FlashEmitter.Trigger(self, Instigator);
        }

        OwningPawn = ROVehicleWeaponPawn(Instigator);

        if (OwningPawn != none && OwningPawn.DriverPositionIndex >= 2)
        {
            if (HasAnim(TankShootOpenAnim))
            {
                PlayAnim(TankShootOpenAnim);
            }
            else if (HasAnim(TankShootClosedAnim))
            {
                PlayAnim(TankShootClosedAnim);
            }
        }
    }
}

// Added from DH_ATGunCannon, as parent 234/1 cannon now extends DH_ROTankCannon, which will run armor checks
simulated function bool DHShouldPenetrate(class<DH_ROAntiVehicleProjectile> P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
   return true;
}

// Modified as there aren't any angles that are below the driver angle for an AT gun
simulated function bool BelowDriverAngle(vector loc, vector ray)
{
    return false;
}

defaultproperties
{
    SightBone="arm"
    //TraverseWheelBone="yaw_w"
    //ElevationWheelBone="pitch_w"
    NumMags=12
    NumSecMags=4
    NumTertMags=4
    AddedPitch=50
    WeaponFireOffset=64.0
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
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_turret'
    Skins(0)=texture'DH_Flak38_tex.Flak38.flak38_gun_01_a_d'
}
