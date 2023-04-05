//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanM4A176WCannonShellSmoke extends DHCannonShellSmoke;

defaultproperties
{
    Speed=47799.0
    MaxSpeed=47799.0
    ShellDiameter=7.62
    BallisticCoefficient=1.368 //TODO: this seems wrong, pls check

    //Penetration
    DHPenetrationTable(0)=0.2
    DHPenetrationTable(1)=0.2
    DHPenetrationTable(2)=0.2
    DHPenetrationTable(3)=0.2
    DHPenetrationTable(4)=0.1
}
