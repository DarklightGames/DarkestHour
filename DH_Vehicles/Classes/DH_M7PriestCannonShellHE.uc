//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// This is a 105mm shell with the "base" charge, which has a significantly lower
// muzzle velocity than a fully charged round. This allows the Priest to be used
// to deliver rounds with a higher angle-of-incidence.
//==============================================================================

class DH_M7PriestCannonShellHE extends DH_ShermanM4A3105CannonShellHE;

defaultproperties
{
    Speed=8962.5         // 198m/s x 75%
    MaxSpeed=8962.5
    LifeSpan=20.0
    SpeedFudgeScale=1.0
    HitMapMarkerClass=class'DH_Engine.DHMapMarker_ArtilleryHit_HE'
    MyDamageType=class'DH_Engine.DHShellHE105mmDamageType_Artillery'
    ShellImpactDamage=class'DH_Engine.DHShellImpactDamageType_Artillery'
}
