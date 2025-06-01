//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM91Bullet extends DHBullet;

defaultproperties
{
    Speed=42246.4               // 700m/s (https://en.wikipedia.org/wiki/Carcano)
    BallisticCoefficient=0.276  // https://www.topgun.es/punta-65-carcano-160gr-hornady.html
    Damage=110.0                // Almost an intermediate cartridge, lower damage than other rifles.
    MyDamageType=class'DH_Weapons.DH_CarcanoM91DamType'
}