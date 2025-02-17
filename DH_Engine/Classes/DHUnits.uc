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

var float UnrealDistanceConversion[3];

var localized string UnrealDistanceSymbol;
var localized string MetersSymbol;
var localized string YardsSymbol;

final static function float ConvertDistance(float Distance, EDistanceUnit FromUnit, EDistanceUnit ToUnit)
{
    // First convert to Unreal units, then convert to the desired unit.
    return (Distance / default.UnrealDistanceConversion[FromUnit]) * default.UnrealDistanceConversion[ToUnit];
}

final static function string GetDistanceUnitString(EDistanceUnit Unit)
{
    switch (Unit)
    {
        case DU_Unreal:
            return default.UnrealDistanceSymbol;
        case DU_Meters:
            return default.MetersSymbol;
        case DU_Yards:
            return default.YardsSymbol;
    }
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
    UnrealDistanceSymbol="uu"
    MetersSymbol="m"
    YardsSymbol="yd"

    UnrealDistanceConversion(0)=1.0 // Unreal
    UnrealDistanceConversion(1)=0.01656945917285259809119830328738 // Meters
    UnrealDistanceConversion(2)=0.01812058089769531724759219519617 // Yards
}