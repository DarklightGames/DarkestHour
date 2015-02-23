//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanM4A176WCannonShellHVAP extends DH_ROTankCannonShellHVAP;

defaultproperties
{
    DHPenetrationTable(0)=19.200001
    DHPenetrationTable(1)=17.700001
    DHPenetrationTable(2)=16.5
    DHPenetrationTable(3)=14.6
    DHPenetrationTable(4)=13.7
    DHPenetrationTable(5)=12.5
    DHPenetrationTable(6)=11.3
    DHPenetrationTable(7)=10.6
    DHPenetrationTable(8)=9.4
    DHPenetrationTable(9)=8.0
    DHPenetrationTable(10)=6.7
    ShellDiameter=7.62
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageHVAP'
    ImpactDamage=450
    BallisticCoefficient=0.888
    SpeedFudgeScale=0.4
    Speed=62525.0
    MaxSpeed=62525.0
    Tag="M93 HVAP"
}
