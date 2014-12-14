//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GreyhoundCannonShellDamageAP extends ROTankShellImpactDamage //ROWeaponDamageType
      abstract;

//Damage class for shells in the 37mm to 50mm calibers

defaultproperties
{
    APCDamageModifier=0.750000
    TreadDamageModifier=0.750000
    DeathString="%o was killed by %k's Greyhound APC shell."
}
