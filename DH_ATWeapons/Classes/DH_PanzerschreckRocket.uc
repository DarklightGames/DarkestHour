//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerschreckRocket extends DH_RocketProj;

defaultproperties
{
    StraightFlightTime=0.5
    DHPenetrationTable(0)=17.5
    DHPenetrationTable(1)=17.5
    DHPenetrationTable(2)=17.5
    DHPenetrationTable(3)=17.5
    DHPenetrationTable(4)=17.5
    DHPenetrationTable(5)=17.5
    DHPenetrationTable(6)=17.5
    bIsAlliedShell=false
    ShellImpactDamage=class'DH_ATWeapons.DH_PanzerschreckImpactDamType'
    ImpactDamage=625
    Speed=6337.0
    MaxSpeed=6337.0
    MyDamageType=class'DH_ATWeapons.DH_PanzerschreckDamType'
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Panzerschreck_shell'
}
