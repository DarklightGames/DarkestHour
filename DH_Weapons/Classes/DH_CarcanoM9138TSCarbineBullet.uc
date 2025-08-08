//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// 6.5x52mm (451mm barrel)

class DH_CarcanoM9138TSCarbineBullet extends DHBullet;

defaultproperties
{
    Speed=38323.52              // 635m/s (https://en.wikipedia.org/wiki/Carcano)
    BallisticCoefficient=0.276  // https://www.topgun.es/punta-65-carcano-160gr-hornady.html
    Damage=107.0                // Almost an intermediate cartridge, lower damage than other rifles.
    MyDamageType=Class'DH_CarcanoM9138TSCarbineDamType'
}