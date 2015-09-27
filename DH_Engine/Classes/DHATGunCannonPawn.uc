//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHATGunCannonPawn extends DHVehicleCannonPawn
    abstract;

// Modified to show player a message if no valid exit can be found
function bool KDriverLeave(bool bForceLeave)
{
    if (super.KDriverLeave(bForceLeave))
    {
        return true;
    }

    ReceiveLocalizedMessage(class'DHATCannonMessage', 4); // no exit can be found

    return false;
}

// Modified to avoid turret damage checks in DHVehicleCannonPawn, just for processing efficiency as this function is called many times per second
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    super(ROTankCannonPawn).HandleTurretRotation(DeltaTime, YawChange, PitchChange);
}

// Emptied out so we just use plain RO rotate/pitch sounds & ignore DHVehicleCannonPawn's manual/powered sounds
simulated function SetManualTurret(bool bManual)
{
}

// Emptied out as can't switch positions in an AT gun
simulated function SwitchWeapon(byte F)
{
}

// Modified to use 3 part reload for AT gun, instead of 4 part reload in tank cannon
function float GetAmmoReloadState()
{
    if (ROTankCannon(Gun) != none)
    {
        switch (ROTankCannon(Gun).CannonReloadState)
        {
            case CR_ReadyToFire:    return 0.0;
            case CR_Waiting:
            case CR_Empty:
            case CR_ReloadedPart1:  return 1.0;
            case CR_ReloadedPart2:  return 0.66;
            case CR_ReloadedPart3:  return 0.33;
        }
    }

    return 0.0;
}

defaultproperties
{
    UnbuttonedPositionIndex=0
    RaisedPositionIndex=1
    bMustBeTankCrew=false
    bHasAltFire=false
    PitchUpLimit=6000
    PitchDownLimit=64000
    RotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    PitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    RotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
    HudName="Gunner"
    FireImpulse=(X=-1000.0)
    EntryRadius=130.0
}
