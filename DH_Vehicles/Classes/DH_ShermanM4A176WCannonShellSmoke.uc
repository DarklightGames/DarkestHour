//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanM4A176WCannonShellSmoke extends DHCannonShellSmoke;

defaultproperties
{
    DHPenetrationTable(0)=0.2
    DHPenetrationTable(1)=0.2
    DHPenetrationTable(2)=0.2
    DHPenetrationTable(3)=0.2
    DHPenetrationTable(4)=0.1
    ShellDiameter=7.62
    ImpactDamage=125
    BallisticCoefficient=1.368
    Speed=47799.0
    MaxSpeed=47799.0
    MyDamageType=class'DHHECannonShellDamageSmoke'
    Tag="M89 WP"
}
