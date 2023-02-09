//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

/*
An info class, not a weapon actor, holding common information about a vehicle-mounted smoke launcher system
Avoids repeating the same information potentially for many vehicles, clogging up the cannon class
A bit of a component approach to an extra vehicle weapon, although only to weapon system info provide info, not acting as a functional weapon component
Includes a variety of self-descriptive static functions, giving user-friendly access to smoke launcher information that's derived from an array
*/

class DHVehicleSmokeLauncher extends Object;

var     class<Projectile>   ProjectileClass;              // the smoke projectile class
// TODO: probably delete InitialAmmo here & set NumSmokeLauncherRounds in cannon's def props, as no. of rounds carried is likely to vary from vehicle to vehicle
var     byte                InitialAmmo;                  // the initial & maximum no. of smoke rounds carried
var     byte                ProjectilesPerFire;           // no. of projectiles launched each time fire button is pressed (external launchers are often paired)
var     array<rotator>      FireRotation;                 // the firing rotation to launch the projectile(s), relative to vehicle - may be multiple for external launchers
var     float               Spread;                       // random spread of launched projectiles
var     sound               FireSound;                    // firing sound
var     bool                bCanBeReloaded;               // whether smoke launcher can be reloaded after firing (not for external launch tubes)
var     array<DHVehicleWeapon.ReloadStage>  ReloadStages; // stages for multi-part reload, including sounds, durations & HUD reload icon proportions
var     material            HUDAmmoIcon;                  // ammo icon for the HUD display
var     material            HUDAmmoReloadTexture;         // ammo reload icon for the HUD display (the red overlay to show reloading progress)
var     byte                NumRotationSettings;          // how many rotation settings there are for a smoke launcher that can be rotated to aim it
var     array<float>        RangeSettingSpeedModifier;    // initial launch speed for projectiles fired from a smoke launcher has a range adjustment mechanism
var     bool                bShowHUDInfo;                 // whether to show ammo & any other information on the commander's HUD

static function int GetNumberOfLauncherTubes()
{
    return default.FireRotation.Length;
}

static function rotator GetFireRotation(optional byte LauncherIndex)
{
    if (LauncherIndex < default.FireRotation.Length)
    {
        return default.FireRotation[LauncherIndex];
    }
}

static function sound GetReloadStageSound(byte StageIndex)
{
    if (StageIndex < default.ReloadStages.Length)
    {
        return default.ReloadStages[StageIndex].Sound;
    }
}

static function float GetReloadStageDuration(byte StageIndex)
{
    if (StageIndex < default.ReloadStages.Length)
    {
        return default.ReloadStages[StageIndex].Duration;
    }
}

static function float GetReloadHUDProportion(byte StageIndex)
{
    if (StageIndex < default.ReloadStages.Length)
    {
        return default.ReloadStages[StageIndex].HUDProportion;
    }
}

static function bool CanRotate()
{
    return default.NumRotationSettings > 0;
}

static function bool CanAdjustRange()
{
    return default.RangeSettingSpeedModifier.Length > 0;
}

static function int GetMaxRangeSetting()
{
    return default.RangeSettingSpeedModifier.Length - 1;
}

// Gets reduction factor for projectile's initial launch speed for given range setting, for smoke launchers that have a range adjustment mechanism
static function float GetLaunchSpeedModifier(byte RangeSetting)
{
    if (RangeSetting < default.RangeSettingSpeedModifier.Length)
    {
        return default.RangeSettingSpeedModifier[RangeSetting];
    }
}

static function StaticPrecache(LevelInfo L)
{
    if (default.HUDAmmoIcon != none)
    {
        L.AddPrecacheMaterial(default.HUDAmmoIcon);
    }

    if (default.HUDAmmoReloadTexture != none)
    {
        L.AddPrecacheMaterial(default.HUDAmmoReloadTexture);
    }
}

// New debug function to set/adjust the firing offset (called from a debug exec in the cannon pawn class)
static function SetFireOffset(DHVehicleCannon Cannon, string NewX, string NewY, string NewZ)
{
    local vector  FireLocation;
    local rotator VehicleRotation;

    if (Cannon != none)
    {
        Cannon.Log(Cannon.Tag @ "SmokeLauncherFireOffset =" @ float(NewX) @ float(NewY) @ float(NewZ) @ "(was" @ Cannon.SmokeLauncherFireOffset[0] $ ")");
        Cannon.SmokeLauncherFireOffset[0].X = float(NewX);
        Cannon.SmokeLauncherFireOffset[0].Y = float(NewY);
        Cannon.SmokeLauncherFireOffset[0].Z = float(NewZ);

        if (Cannon.bHasTurret)
        {
            VehicleRotation = Cannon.GetBoneRotation(Cannon.YawBone);
        }
        else
        {
            VehicleRotation = Cannon.Rotation;
        }

        FireLocation = Cannon.Location + (Cannon.SmokeLauncherFireOffset[0] >> VehicleRotation);
        Cannon.ClearStayingDebugLines();
        Cannon.DrawStayingDebugLine(FireLocation, FireLocation + (100.0 * vector(Cannon.SmokeLauncherClass.static.GetFireRotation(0)) >> VehicleRotation), 255, 0, 0);
        Cannon.DrawStayingDebugLine(FireLocation - (20.0 * vector(VehicleRotation)), FireLocation + (20.0 * vector(VehicleRotation)), 0, 255, 0);
    }
}

defaultproperties
{
    ProjectilesPerFire=1
    Spread=0.03
    bShowHUDInfo=true
    bCanBeReloaded=true
    ReloadStages(0)=(Sound=Sound'Inf_Weapons_Foley.mg34.mg34_reload01_000',Duration=1.24) // TODO: get some suitable stage reload sounds to replace these placeholders
    ReloadStages(1)=(Sound=Sound'Inf_Weapons_Foley.mg34.mg34_reload02_039',Duration=2.03,HUDProportion=0.7)
    ReloadStages(2)=(Sound=Sound'Inf_Weapons_Foley.mg34.mg34_reload03_104',Duration=2.07,HUDProportion=0.4)
}
