//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Wz35Bullet extends DHBullet_ArmorPiercing;

// https://en.wikipedia.org/wiki/7.92%C3%97107mm_DS
// 7.92x107mm DS

defaultproperties
{
    Speed=76948.0           // 1275m/s
    MaxSpeed=76948.0        // 1275m/s
    ShellDiameter=0.818     // 8.18mm
    BallisticCoefficient=0.504  // http://gundata.org/ballistic-coefficient-calculator/#spitzer (boat-tail shape, 226gr, .32 diameter, 0.818 length, 0.504 BC)

    //Damage
    ImpactDamage=120
    Damage=1000.0  //should leave no one alive, as even if it hits a limb, it should be ripped apart making victim uncapable of continuing fighting
    MyDamageType=class'DH_Weapons.DH_Wz35DamType'

    //Penetration
    DHPenetrationTable(0)=3.3  // 100
    DHPenetrationTable(1)=2.0  // 250
    DHPenetrationTable(2)=1.0  // 500
    DHPenetrationTable(3)=0.5  // 750
    DHPenetrationTable(4)=0.2  // 1000
    DHPenetrationTable(5)=0.1  // 1250
    DHPenetrationTable(6)=0.0  // 1500
    DHPenetrationTable(7)=0.0  // 1750
    DHPenetrationTable(8)=0.0  // 2000
    DHPenetrationTable(9)=0.0  // 2500
    DHPenetrationTable(10)=0.0 // 3000
}
