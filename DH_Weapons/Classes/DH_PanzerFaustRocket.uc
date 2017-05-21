//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_PanzerFaustRocket extends DHRocketProjectile;

#exec OBJ LOAD FILE=..\Staticmeshes\DH_Military_Axis.usx

defaultproperties
{
    StraightFlightTime=0.25
    DHPenetrationTable(0)=21.5
    DHPenetrationTable(1)=21.5
    DHPenetrationTable(2)=21.5
    DHPenetrationTable(3)=21.5
    DHPenetrationTable(4)=21.5
    DHPenetrationTable(5)=21.5
    DHPenetrationTable(6)=21.5
    bIsAlliedShell=false
    bHasTracer=false
    ShellImpactDamage=class'DH_Weapons.DH_PanzerFaustImpactDamType'
    ImpactDamage=650
    BallisticCoefficient=0.075
    Speed=2716.0
    MaxSpeed=2716.0
    MyDamageType=class'DH_Weapons.DH_PanzerFaustDamType'
    StaticMesh=StaticMesh'DH_Military_Axis.Weapons.Panzerfaust_warhead'
}
