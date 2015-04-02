//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WolverineCannonShellSmoke extends DHTankCannonShellSmoke;

defaultproperties
{
    DHPenetrationTable(0)=0.2
    DHPenetrationTable(1)=0.2
    DHPenetrationTable(2)=0.2
    DHPenetrationTable(3)=0.2
    DHPenetrationTable(4)=0.1
    ShellDiameter=7.62
    ImpactDamage=125
    BallisticCoefficient=1.627
    Speed=47799.0
    MaxSpeed=47799.0
    MyDamageType=class'DH_HECannonShellDamageSmoke'
    Tag="M89 WP"
}
