//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHUnits extends Object
    abstract;

final static function float MetersToUnreal(coerce float Meters)
{
    return Meters * 60.352;
}

final static function float UnrealToMeters(coerce float Unreal)
{
    return Unreal * 0.01656945917285259809119830328738;
}

final static function float MetersToInches(coerce float Meters)
{
    return Meters * 39.3701;
}

final static function float UnrealToInches(coerce float Unreal)
{
    return Unreal * 0.65234126458112407211028632025448;
}

