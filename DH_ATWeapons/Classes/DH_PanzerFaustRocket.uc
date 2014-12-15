//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerFaustRocket extends DH_RocketProj;

#exec OBJ LOAD FILE=..\Staticmeshes\DH_Military_Axis.usx

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (SmokeTrail != none)
    {
        SmokeTrail.HandleOwnerDestroyed();
    }

    if (Corona != none)
    {
        Corona.Destroyed();
    }
}

defaultproperties
{
    StraightFlightTime=0.250000
    DHPenetrationTable(0)=21.500000
    DHPenetrationTable(1)=21.500000
    DHPenetrationTable(2)=21.500000
    DHPenetrationTable(3)=21.500000
    DHPenetrationTable(4)=21.500000
    DHPenetrationTable(5)=21.500000
    DHPenetrationTable(6)=21.500000
    bIsHEATRound=true
    bIsAlliedShell=false
    bHasTracer=false
    ShellImpactDamage=class'DH_ATWeapons.DH_PanzerFaustImpactDamType'
    ImpactDamage=650
    BallisticCoefficient=0.075000
    Speed=2716.000000
    MaxSpeed=2716.000000
    MyDamageType=class'DH_ATWeapons.DH_PanzerFaustDamType'
    StaticMesh=StaticMesh'DH_Military_Axis.Weapons.Panzerfaust_warhead'
}
