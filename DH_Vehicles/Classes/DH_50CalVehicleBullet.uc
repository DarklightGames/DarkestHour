//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_50CalVehicleBullet extends DHBullet_ArmorPiercing;

defaultproperties
{
    DHPenetrationTable(0)=2.09 // 100m
    DHPenetrationTable(1)=1.93 // 250m
    DHPenetrationTable(2)=1.65 // 500m
    DHPenetrationTable(3)=1.38 // 750m
    DHPenetrationTable(4)=1.11 // 1000m
    DHPenetrationTable(5)=0.83 // 1250m
    DHPenetrationTable(6)=0.56 // 1500m
    DHPenetrationTable(7)=0.29 // 1750m
    DHPenetrationTable(8)=0.0  // 2000m
    DHPenetrationTable(9)=0.0  // 2500m
    DHPenetrationTable(10)=0.0 // 3000m

    ShellDiameter=1.27
    BallisticCoefficient=0.65 // sources vary (as do actual round apparently), but this is about the consensus, with AP rounds a little lower than standard ball ammo

	//Damage
    ImpactDamage=75
    Damage=450.0
    HullFireChance=0.05
    EngineFireChance=0.07  //assuming that some bullets in the belt are incendiary
    MyDamageType=class'DH_Vehicles.DH_50CalDamType'

	//Speed
    Speed=53268.0 // 880 m/s
    MaxSpeed=53268.0
}
