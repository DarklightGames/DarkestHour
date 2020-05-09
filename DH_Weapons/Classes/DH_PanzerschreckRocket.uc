//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_PanzerschreckRocket extends DHRocketProjectile;

defaultproperties
{
    Speed=6337.0
    MaxSpeed=6337.0
    StraightFlightTime=0.5

    //Damage
    ImpactDamage=775
    ShellImpactDamage=class'DH_Weapons.DH_PanzerschreckImpactDamType'
    DamageRadius=400.0
    MyDamageType=class'DH_Weapons.DH_PanzerschreckDamType'

    bDebugInImperial=false

    //Effects
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Panzerschreck_shell'
    bHasTracer=true // represents glow of burnt out rocket motor
    bHasShellTrail=true
    ShellTrailClass=class'DH_Effects.DHPanzerschreckTrail'

    //Penetration
    DHPenetrationTable(0)=17.5
    DHPenetrationTable(1)=17.5
    DHPenetrationTable(2)=17.5
    DHPenetrationTable(3)=17.5
    DHPenetrationTable(4)=17.5
    DHPenetrationTable(5)=17.5
    DHPenetrationTable(6)=17.5
}
