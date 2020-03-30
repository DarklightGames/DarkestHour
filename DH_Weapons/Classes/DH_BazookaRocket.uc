//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BazookaRocket extends DHRocketProjectile;

defaultproperties
{
    Speed=4967.0
    MaxSpeed=4967.0
    BallisticCoefficient=0.0475 //guestimate
    ImpactDamage=575
    DamageRadius=400.0
    ShellImpactDamage=class'DH_Weapons.DH_BazookaImpactDamType'

    MyDamageType=class'DH_Weapons.DH_BazookaDamType'

    StraightFlightTime=0.5

    //Effects
    DrawScale=1.33
    bHasSmokeTrail=false // bazooka has no smoke trail irl
    bHasTracer=true // represents glow of burnt out rocket motor
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Bazooka_shell'

    //Penetration
    DHPenetrationTable(0)=9.8
    DHPenetrationTable(1)=9.8
    DHPenetrationTable(2)=9.8
    DHPenetrationTable(3)=9.8
    DHPenetrationTable(4)=9.8
    DHPenetrationTable(5)=9.8
    DHPenetrationTable(6)=9.8
}
