//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuH42CannonShellImpactDamageHEAT extends ROTankShellImpactDamage
      abstract;

defaultproperties
{
     APCDamageModifier=0.750000
     DeathString="%o was killed by %k's StuH42 Ausf.G HEAT shell."
     bArmorStops=true // Matt: added so side skirts stop HEAT round
}
