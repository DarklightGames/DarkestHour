//==============================================================================
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class UUnits extends Object
    abstract;

var localized string UnrealAngleSymbol;
var localized string DegreesSymbol;
var localized string MilsSymbol;
var localized string RadiansSymbol;

enum EAngleUnit
{
    AU_Unreal,
    AU_Degrees,
    AU_Milliradians,
    AU_Radians
};

// Used for debugging purposes.
final static function EAngleUnit GetAngleUnitFromString(coerce string AngleUnitString)
{
    switch (Caps(AngleUnitString))
    {
        case "U":
            return AU_Unreal;
        case "D":
            return AU_Degrees;
        case "M":
            return AU_Milliradians;
        case "R":
            return AU_Radians;
        default:
            return AU_Unreal;
    }
}

final static function string GetAngleUnitString(EAngleUnit Unit)
{
    switch (Unit)
    {
        case AU_Unreal:
            return default.UnrealAngleSymbol;
        case AU_Degrees:
            return default.DegreesSymbol;
        case AU_Milliradians:
            return default.MilsSymbol;
        case AU_Radians:
            return default.RadiansSymbol;
        default:
            return "";
    }
}

final static function float ConvertAngleUnitToUnreal(coerce float Angle, EAngleUnit FromUnit)
{
    switch (FromUnit)
    {
        case AU_Degrees:
            return static.DegreesToUnreal(Angle);
        case AU_Milliradians:
            return static.MilsToUnreal(Angle);
        case AU_Radians:
            return static.RadiansToUnreal(Angle);
        default:
            return Angle;
    }
}

final static function float ConvertAngleUnit(coerce float Angle, EAngleUnit FromUnit, EAngleUnit ToUnit)
{
    if (FromUnit == ToUnit)
    {
        return Angle;
    }

    // Convert the angle to our base unit (Unreal units)
    Angle = ConvertAngleUnitToUnreal(Angle, FromUnit);

    switch (ToUnit)
    {
        case AU_Milliradians:
            return static.UnrealToMils(Angle);
        case AU_Radians:
            return static.UnrealToRadians(Angle);
        case AU_Degrees:
            return static.UnrealToDegrees(Angle);
        default:
            return Angle;
    }
}

final static function float DegreesToRadians(coerce float Degrees)
{
    return Degrees * 0.01745329251994329576923690768489;
}

final static function float RadiansToDegrees(coerce float Radians)
{
    return Radians * 57.295779513082320876798154814105;
}

final static function float DegreesToUnreal(coerce float Degrees)
{
    return Degrees * 182.04444444444444444444444444444;
}

final static function float RadiansToUnreal(coerce float Radians)
{
    return Radians * 10430.378350470452724949566316381;
}

final static function float UnrealToDegrees(coerce float Unreal)
{
    return Unreal * 0.0054931640625;
}

final static function float UnrealToRadians(coerce float Unreal)
{
    return Unreal * 0.000095873799242852576857380474343247;
}

final static function float UnrealToMils(coerce float Unreal)
{
    return UnrealToRadians(Unreal) * 1000.0;
}

final static function float MilsToUnreal(coerce float Mils)
{
    return RadiansToUnreal(Mils * 0.001);
}

defaultproperties
{
    UnrealAngleSymbol = "u";
    DegreesSymbol = "�";
    MilsSymbol = "mils";
    RadiansSymbol = "rad";
}
