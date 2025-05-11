//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Extracted to its own file to avoid adding member variables to the projectile
// class. Calibration code is only used in singleplayer, so the additional
// object is not a concern.
//==============================================================================

class DHProjectileCalibrationInfo extends Object;

var DHVehicleWeapon VehicleWeapon;
var Vector StartLocation;
var float DebugAngleValue;
var UUnits.EAngleUnit DebugAngleUnit;

function LogHit(Vector HitLocation)
{
    local float Distance, Angle;

    if (VehicleWeapon != none)
    {
        Distance = class'DHUnits'.static.UnrealToMeters(VSize(HitLocation - StartLocation));
        Angle = class'UUnits'.static.ConvertAngleUnit(DebugAngleValue, AU_Unreal, DebugAngleUnit);

        Log("" $ Angle $ "," $ Distance);
    }
}
