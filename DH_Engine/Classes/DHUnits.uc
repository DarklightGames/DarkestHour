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

enum ETemperatureUnit
{
    TU_Celcius,
    TU_Fahrenheit
};

struct TemperatureUnit
{
    var localized string Name;
    var localized string Symbol;
};

var array<DistanceUnit> DistanceUnits;
var array<TemperatureUnit> TemperatureUnits;

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

final static function float CelciusToFahrenheit(float Celcius)
{
    return (Celcius * 1.8) + 32;
}

final static function float FahrenheitToCelcius(float Fahrenheit)
{
    return (Fahrenheit - 32) / 1.8;
}

final static function string GetTemperatureUnitSymbol(ETemperatureUnit Unit)
{
    return default.TemperatureUnits[int(Unit)].Symbol;
}

final static function string GetTemperatureUnitName(ETemperatureUnit Unit)
{
    return default.TemperatureUnits[int(Unit)].Name;
}

defaultproperties
{
    DistanceUnits(0)=(Name="Unreal Units",Symbol="uu",Conversion=1.0)
    DistanceUnits(1)=(Name="Meters",Symbol="m",Conversion=0.01656945917285259809119830328738)
    DistanceUnits(2)=(Name="Yards",Symbol="yd",Conversion=0.01812058089769531724759219519617)
    TemperatureUnits(0)=(Name="Celcius",Symbol="°C")
    TemperatureUnits(1)=(Name="Fahrenheit",Symbol="°F")
}
