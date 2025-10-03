//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LeFH18CannonShellHEAT extends DHCannonShellHEAT;

defaultproperties
{
    Speed=29874.0
    MaxSpeed=29874.0
    ShellDiameter=10.5
    BallisticCoefficient=2.96

    //Damage
    ImpactDamage=650 // 1.49kg of PETN: UK HANDBOOK OF ENEMY AMMUNITION PAMPHLET No. 14
    Damage=415.0
    DamageRadius=700.0

    bDebugInImperial=false

    //Effects
    DrawScale=1.5
    CoronaClass=Class'DHShellTracer_OrangeLarge'
    ShellTrailClass=Class'DHShellTrail_YellowOrange'

    //Penetration
    DHPenetrationTable(0)=11.5
    DHPenetrationTable(1)=11.5
    DHPenetrationTable(2)=11.5
    DHPenetrationTable(3)=11.5
    DHPenetrationTable(4)=11.5
    DHPenetrationTable(5)=11.5
    DHPenetrationTable(6)=11.5
    DHPenetrationTable(7)=11.5
    DHPenetrationTable(8)=11.5
    DHPenetrationTable(9)=11.5
    DHPenetrationTable(10)=11.5
}
