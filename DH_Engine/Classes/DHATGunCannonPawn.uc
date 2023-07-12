//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHATGunCannonPawn extends DHVehicleCannonPawn
    abstract;

// Modified to prevent any switch for a normal AT gun
// But if the gun is mounted on a mobile vehicle base, player switches positions as normal
simulated function bool CanSwitchToVehiclePosition(byte F)
{
    return DHATGun(VehicleBase) == none && super.CanSwitchToVehiclePosition(F);
}

// Emptied out so we just use plain RO rotate/pitch sounds & ignore DHVehicleCannonPawn's manual/powered sounds
simulated function SetManualTurret(bool bManual)
{
}

// Functions emptied out as not relevant to an AT gun:
simulated function DrawPeriscopeOverlay(Canvas C);
function AltFire(optional float F);
function float GetAltAmmoReloadState() { return 0.0; }
exec function SetAltFireOffset(string NewX, string NewY, string NewZ);
exec function SetAltFireSpawnOffset(float NewValue);
exec function Deploy();
function float GetSmokeLauncherAmmoReloadState() { return 0.0; }
exec simulated function ToggleVehicleLock();
function ServerToggleVehicleLock();

defaultproperties
{
    bMustBeTankCrew=false
    bManualTraverseOnly=true
    ManualMinRotateThreshold=0.5
    ManualMaxRotateThreshold=3.0
    UnbuttonedPositionIndex=0
    RaisedPositionIndex=1
    BinocPositionIndex=2
    bHasAltFire=false
    RotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    PitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    RotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    HudName="Gunner"
    FireImpulse=(X=-1000.0)
}
