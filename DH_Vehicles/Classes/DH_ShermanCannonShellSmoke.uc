//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanCannonShellSmoke extends DH_ROTankCannonShellSmoke;

defaultproperties
{
    DHPenetrationTable(0)=0.2
    DHPenetrationTable(1)=0.2
    DHPenetrationTable(2)=0.2
    DHPenetrationTable(3)=0.2
    DHPenetrationTable(4)=0.1
    ShellDiameter=7.5
    ImpactDamage=125
    BallisticCoefficient=1.19
    Speed=37357.0
    MaxSpeed=37357.0
    MyDamageType=class'DH_HECannonShellDamageSmoke'
    Tag="M89 WP"
}
