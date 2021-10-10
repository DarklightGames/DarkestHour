//==============================================================================
// Darklight Games (c) 2008-2021
//==============================================================================

class UUnits extends Object
    abstract;

static final function float DegreesToRadians(coerce float Degrees)
{
    return Degrees * 0.01745329251994329576923690768489;
}

static final function float RadiansToDegrees(coerce float Radians)
{
    return Radians * 57.295779513082320876798154814105;
}

static final function float DegreesToUnreal(coerce float Degrees)
{
    return Degrees * 182.04444444444444444444444444444;
}

static final function float RadiansToUnreal(coerce float Radians)
{
    return Radians * 10430.378350470452724949566316381;
}

static final function float UnrealToDegrees(coerce float Unreal)
{
    return Unreal * 0.0054931640625;
}

static final function float UnrealToRadians(coerce float Unreal)
{
    return Unreal * 0.000095873799242852576857380474343247;
}

static final function float UnrealToMils(coerce float Unreal)
{
    return UnrealToRadians(Unreal) * 1000.0;
}

static final function float MilsToUnreal(coerce float Mils)
{
    return RadiansToUnreal(Mils / 0.001);
}
