//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_ShermanCannonShellSmoke extends DHCannonShellSmoke;

defaultproperties
{
    Speed=37357.0
    MaxSpeed=37357.0
    ShellDiameter=7.5
    BallisticCoefficient=1.19 //TODO: pls check

    //Penetration
    DHPenetrationTable(0)=0.2
    DHPenetrationTable(1)=0.2
    DHPenetrationTable(2)=0.2
    DHPenetrationTable(3)=0.2
    DHPenetrationTable(4)=0.1
}
