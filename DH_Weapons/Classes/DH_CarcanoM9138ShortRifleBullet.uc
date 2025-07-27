//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// 6.5x52mm (562mm barrel)

class DH_CarcanoM9138ShortRifleBullet extends DHBullet;

defaultproperties
{
    Speed=40254.78              // 667m/s (calculated based on M91/38 carbine and M91 muzzle velocities)
    BallisticCoefficient=0.276  // https://www.topgun.es/punta-65-carcano-160gr-hornady.html
    Damage=108.0                // Almost an intermediate cartridge, lower damage than other rifles.
    MyDamageType=Class'DH_CarcanoM9138ShortRifleDamType'
}