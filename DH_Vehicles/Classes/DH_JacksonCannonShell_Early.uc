//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JacksonCannonShell_Early extends DH_JacksonCannonShell;

defaultproperties
{
    Speed=49115.0 //2670 fps or 814 m/s
    MaxSpeed=49115.0
    ShellDiameter=9.0
    BallisticCoefficient=3.85 // Correct - verified on range at 1000 yards

    //Penetration
    DHPenetrationTable(0)=16.4
    DHPenetrationTable(1)=15.6
    DHPenetrationTable(2)=15.0
    DHPenetrationTable(3)=14.3
    DHPenetrationTable(4)=13.7
    DHPenetrationTable(5)=13.1
    DHPenetrationTable(6)=12.5
    DHPenetrationTable(7)=11.9
    DHPenetrationTable(8)=11.4
    DHPenetrationTable(9)=10.4
    DHPenetrationTable(10)=9.2
}
