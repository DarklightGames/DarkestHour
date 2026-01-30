//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// https://en.wikipedia.org/wiki/Reibel_machine_gun
// Mitrailleuse modèle 1931
//==============================================================================

class DH_ReibelMGBullet extends DHBullet;

defaultproperties
{
    Speed=50092.16  // 830 m/s
    BallisticCoefficient=0.41
    Damage=100.0
    MyDamageType=Class'DH_ReibelMGDamageType'
}
