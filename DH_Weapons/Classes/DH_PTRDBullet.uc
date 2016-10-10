//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PTRDBullet extends DHBullet_ArmorPiercing;

defaultproperties
{
    DHPenetrationTable(0)=3.5  // 100
    DHPenetrationTable(1)=2.4  // 250
    DHPenetrationTable(2)=1.5  // 500
    DHPenetrationTable(3)=1.0  // 750
    DHPenetrationTable(4)=0.0  // 1000
    DHPenetrationTable(5)=0.0  // 1250
    DHPenetrationTable(6)=0.0  // 1500
    DHPenetrationTable(7)=0.0  // 1750
    DHPenetrationTable(8)=0.0  // 2000
    DHPenetrationTable(9)=0.0  // 2500
    DHPenetrationTable(10)=0.0 // 3000

    ShellDiameter=1.45
    BallisticCoefficient=0.675 // sources vary (as do actual round apparently), but this is about the consensus, with AP rounds a little lower than standard ball ammo
    Damage=125.0
    MyDamageType=class'DH_Weapons.DH_PTRDDamType'
    MyVehicleDamage=class'DH_Weapons.DH_PTRDVehDamType'
    Speed=60352.0 // 1000 m/s
    MaxSpeed=60352.0
}

