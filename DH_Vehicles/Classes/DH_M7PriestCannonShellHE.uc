//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================
// This is a 105mm shell with the "base" charge, which has a significantly lower
// muzzle velocity than a fully charged round. This allows the Priest to be used
// to deliver rounds with a higher angle-of-incidence.
//==============================================================================

class DH_M7PriestCannonShellHE extends DH_ShermanM4A3105CannonShellHE;

defaultproperties
{
    SpeedFudgeScale=1.0
    Speed=11950.0         // 198m/s
    MaxSpeed=11950.0
    LifeSpan=20.0
}
