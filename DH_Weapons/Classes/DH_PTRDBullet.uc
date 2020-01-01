//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_PTRDBullet extends DHBullet_ArmorPiercing;

defaultproperties
{
    Speed=60352.0 // 1000 m/s
    MaxSpeed=60352.0
    ShellDiameter=1.45
    BallisticCoefficient=0.675 // sources vary (as do actual round apparently), but this is about the consensus, with AP rounds a little lower than standard ball ammo

    //Damage
    Damage=125.0
    MyDamageType=class'DH_Weapons.DH_PTRDDamType'
	
	
    //adjusted penetration, my main source is this https://media.discordapp.net/attachments/339838693617565697/661960666399244320/5450cb284c38.png?width=883&height=621
    //Penetration
	//should penetrate ~41mm at point blank
    DHPenetrationTable(0)=3.8  // 100
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

