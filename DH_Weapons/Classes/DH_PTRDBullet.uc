//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PTRDBullet extends DHBullet_ArmorPiercing; // this is a tungsten core BS-41 bullet; TO DO: B-39 steel core AP bullet and functionality of having 2 types of ammo in the same weapon

defaultproperties
{
    Speed=60352.0 // 1000 m/s
    MaxSpeed=60352.0
    ShellDiameter=1.45
    BallisticCoefficient=0.675 // sources vary (as do actual round apparently), but this is about the consensus, with AP rounds a little lower than standard ball ammo

    //Damage
    ImpactDamage=120
    Damage=1000.0  //should leave no one alive, as even if it hits a limb, it should be ripped apart making victim uncapable of continuing fighting
    MyDamageType=class'DH_Weapons.DH_PTRDDamType'
    HullFireChance=0.12  //although its just a bullet, it has a bit of incendiary part in it which should make it more likely to ignite or detonate something
    EngineFireChance=0.2

    //adjusted penetration, my main source is this https://media.discordapp.net/attachments/339838693617565697/661960666399244320/5450cb284c38.png?width=883&height=621
    //Penetration
    //should penetrate ~41mm at point blank
    DHPenetrationTable(0)=3.9  // 100
    DHPenetrationTable(1)=3.4  // 250
    DHPenetrationTable(2)=2.8  // 500
    DHPenetrationTable(3)=2.2  // 750
    DHPenetrationTable(4)=1.5  // 1000
    DHPenetrationTable(5)=1.0  // 1250
    DHPenetrationTable(6)=0.5  // 1500
    DHPenetrationTable(7)=0.4  // 1750
    DHPenetrationTable(8)=0.3  // 2000
    DHPenetrationTable(9)=0.2  // 2500
    DHPenetrationTable(10)=0.1 // 3000
}
