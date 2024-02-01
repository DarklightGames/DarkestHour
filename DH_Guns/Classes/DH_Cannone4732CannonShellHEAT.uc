//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [1] https://wwiitanks.co.uk/FORM-Gun_Data.php?I=192
//==============================================================================

class DH_Cannone4732CannonShellHEAT extends DHCannonShellHEAT;

defaultproperties
{
    Speed=15088
    MaxSpeed=15088
    ShellDiameter=4.7
    BallisticCoefficient=1.3

    //Damage
    ImpactDamage=210
    Damage=200.0
    DamageRadius=415.0

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Orange'  // TODO: white corna/shell trail
    ShellTrailClass=class'DH_Effects.DHShellTrail_YellowOrange'

    DHPenetrationTable(0)=5.5
    DHPenetrationTable(1)=5.5
    DHPenetrationTable(2)=5.5
    DHPenetrationTable(3)=5.5
    DHPenetrationTable(4)=5.5
    DHPenetrationTable(5)=5.5
    DHPenetrationTable(6)=5.5
    DHPenetrationTable(7)=5.5
    DHPenetrationTable(8)=5.5
    DHPenetrationTable(9)=5.5
    DHPenetrationTable(10)=5.5

    // TODO: fill these in!
    MechanicalRanges(0)=(Range=0,RangeValue=120)
    MechanicalRanges(1)=(Range=100,RangeValue=120)
    MechanicalRanges(2)=(Range=200,RangeValue=192)
    MechanicalRanges(3)=(Range=300,RangeValue=273)
    MechanicalRanges(4)=(Range=400,RangeValue=359)
    MechanicalRanges(5)=(Range=500,RangeValue=532)
    // TODO: anything beyond this stretches credulity with how far the pitch of the projectile is from the gun itself

    bMechanicalAiming=true
}
