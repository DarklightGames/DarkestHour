//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHAmmunition extends ROAmmunition
    abstract;

// TODO: can probably deprecate ammo classes entirely
// They only contain MaxAmmo, InitialAmount & IconMaterial, which don't change & are only looked up from the ammo Class's default values
// Those 3 variables could easily be added to the WeaponFire class & looked up from there
// The IconCoords in default properties here appears to be unused (& never changes anyway)

defaultproperties
{
    IconCoords=(X1=445,Y1=75,X2=544,Y2=149)
}
