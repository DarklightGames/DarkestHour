//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanCannonShellSmoke extends DHCannonShellSmokeWP;

defaultproperties
{
    Speed=37358.0 // 2030 fps or 619 m/s
    MaxSpeed=37358.0
    ShellDiameter=7.5
    BallisticCoefficient=2.8 //TODO: pls check - this is the APC shell's BC

    //Penetration
    DHPenetrationTable(0)=0.2
    DHPenetrationTable(1)=0.2
    DHPenetrationTable(2)=0.2
    DHPenetrationTable(3)=0.2
    DHPenetrationTable(4)=0.1
}
