//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JacksonCannonShellHVAP extends DHTankCannonShellHVAP; // Matt: extended DHTankCannonShellHVAP90, but now a deprecated class

defaultproperties
{
    DHPenetrationTable(0)=30.6
    DHPenetrationTable(1)=29.5
    DHPenetrationTable(2)=27.799999
    DHPenetrationTable(3)=26.200001
    DHPenetrationTable(4)=24.6
    DHPenetrationTable(5)=23.200001
    DHPenetrationTable(6)=21.799999
    DHPenetrationTable(7)=17.9
    DHPenetrationTable(8)=14.7
    DHPenetrationTable(9)=13.1
    DHPenetrationTable(10)=11.8
    ShellDiameter=9.0
    ShellImpactDamage=class'DH_Vehicles.DH_JacksonCannonShellDamageHVAP'
    ImpactDamage=525
    BallisticCoefficient=1.564
    SpeedFudgeScale=0.4
    Speed=61619.0
    MaxSpeed=61619.0
    Tag="M304 HVAP"
}
