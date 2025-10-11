//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_DieGlockeGunShellHE extends DH_Sdkfz2341CannonShellHE;

defaultproperties
{
    ShellImpactDamage=Class'DH_Flak38CannonShellDamageHE'
    MyDamageType=Class'DHShellHE20mmATDamageType'
    
    //Penetration
    DHPenetrationTable(0)=20.7
    DHPenetrationTable(1)=20.5
    DHPenetrationTable(2)=20.1
    DHPenetrationTable(3)=10.9
    DHPenetrationTable(4)=10.6
    DHPenetrationTable(5)=10.3
    DHPenetrationTable(6)=10.0
    DHPenetrationTable(7)=9.9
    DHPenetrationTable(8)=8.7
    DHPenetrationTable(9)=7.5
    DHPenetrationTable(10)=6.3
}
