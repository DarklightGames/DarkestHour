//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerschreckRocket extends DH_RocketProj; //PanzerFaustRocket;

defaultproperties
{
    StraightFlightTime=0.500000
    DHPenetrationTable(0)=17.500000
    DHPenetrationTable(1)=17.500000
    DHPenetrationTable(2)=17.500000
    DHPenetrationTable(3)=17.500000
    DHPenetrationTable(4)=17.500000
    DHPenetrationTable(5)=17.500000
    DHPenetrationTable(6)=17.500000
    bIsHEATRound=true
    bIsAlliedShell=false
    ShellImpactDamage=class'DH_ATWeapons.DH_PanzerschreckImpactDamType'
    ImpactDamage=625
    Speed=6337.000000
    MaxSpeed=6337.000000
    MyDamageType=class'DH_ATWeapons.DH_PanzerschreckDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Panzerschreck_shell'
}
