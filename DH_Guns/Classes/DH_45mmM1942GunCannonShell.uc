//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_45mmM1942GunCannonShell extends DH_45mmM1937GunCannonShell;

defaultproperties
{
    Speed=52506.0 // 870 m/s
    MaxSpeed=52506.0

    //Damage
    ImpactDamage=315  //30 gramms TNT filler
    Damage=700.0 //"regular" damage is only changed so that AT guns are one-shot killed reliably, so the radius is small
    DamageRadius=150.0

    //Penetration
    DHPenetrationTable(0)=7.1  // 100m
    DHPenetrationTable(1)=6.3  // 250m
    DHPenetrationTable(2)=5.4  // 500m
    DHPenetrationTable(3)=4.6
    DHPenetrationTable(4)=4.0  // 1000m
    DHPenetrationTable(5)=3.5
    DHPenetrationTable(6)=3.2  // 1500m
    DHPenetrationTable(7)=3.0
    DHPenetrationTable(8)=2.8  // 2000m
    DHPenetrationTable(9)=2.4
    DHPenetrationTable(10)=2.1 // 3000m

    //Gunsight adjustments
    MechanicalRanges(1)=(Range=500,RangeValue=-45.0) // this cannon doesn't actually have mechanical aiming, but this is a fudge to adjust for sight markings that are 'out'
    MechanicalRanges(2)=(Range=1000,RangeValue=-102.0)
    MechanicalRanges(3)=(Range=1500,RangeValue=-160.0) // can only set up to here
    MechanicalRanges(4)=(Range=2000,RangeValue=-218.0)
    MechanicalRanges(5)=(Range=2500,RangeValue=-276.0)
}
