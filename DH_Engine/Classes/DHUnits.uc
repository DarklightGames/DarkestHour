//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHUnits extends Object
    abstract;

enum EDistanceUnit
{
    DU_Unreal,
    DU_Meters,
    DU_Yards,
};

struct DistanceUnit
{
    var localized string Name;
    var localized string Symbol;
    var float Conversion;           // Conversion factor to Unreal units.
};

var array<DistanceUnit> DistanceUnits;

final static function float ConvertDistance(float Distance, EDistanceUnit FromUnit, EDistanceUnit ToUnit)
{
    // First convert to Unreal units, then convert to the desired unit.
    return (Distance / default.DistanceUnits[int(FromUnit)].Conversion) * default.DistanceUnits[int(ToUnit)].Conversion;
}

final static function string GetDistanceUnitSymbol(EDistanceUnit Unit)
{
    return default.DistanceUnits[int(Unit)].Symbol;
}

final static function string GetDistanceUnitName(EDistanceUnit Unit)
{
    return default.DistanceUnits[int(Unit)].Name;
}

final static function float MetersToUnreal(coerce float Meters)
{
    return ConvertDistance(Meters, DU_Meters, DU_Unreal);
}

final static function float UnrealToMeters(coerce float Unreal)
{
    return ConvertDistance(Unreal, DU_Unreal, DU_Meters);
}

defaultproperties
{
    DistanceUnits(0)=(Name="Unreal Units",Symbol="uu",Conversion=1.0)
    DistanceUnits(1)=(Name="Meters",Symbol="m",Conversion=0.01656945917285259809119830328738)
    DistanceUnits(2)=(Name="Yards",Symbol="yd",Conversion=0.01812058089769531724759219519617)
}
