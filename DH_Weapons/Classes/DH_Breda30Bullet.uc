//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Breda30Bullet extends DHBullet;

defaultproperties
{
    Speed=37418.24              // 620m/s (https://en.wikipedia.org/wiki/Breda_30)
    BallisticCoefficient=0.276  // https://www.topgun.es/punta-65-carcano-160gr-hornady.html
    Damage=100.0                // Intermediate cartridge, lower damage than other rifles.
    MyDamageType=class'DH_Weapons.DH_Breda30DamType'
}
