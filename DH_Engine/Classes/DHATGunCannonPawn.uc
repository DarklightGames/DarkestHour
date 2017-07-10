//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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
exec function SetAltFireOffset(int NewX, int NewY, int NewZ, optional bool bScaleOneTenth);
exec function SetAltFireSpawnOffset(float NewValue);
exec function Deploy();
function float GetSmokeLauncherAmmoReloadState() { return 0.0; }
simulated exec function ToggleVehicleLock();
function ServerToggleVehicleLock();

defaultproperties
{
    bMustBeTankCrew=false
    UnbuttonedPositionIndex=0
    RaisedPositionIndex=1
    BinocPositionIndex=2
    bHasAltFire=false
    RotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    PitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    RotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
    HudName="Gunner"
    FireImpulse=(X=-1000.0)
}
