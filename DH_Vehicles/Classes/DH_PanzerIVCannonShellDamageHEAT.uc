//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIVCannonShellDamageHEAT extends DH_HEATCannonShellDamage
      abstract;

defaultproperties
{
    //  TreadDamageModifier=0.150000    // Matt: removed so uses default 0.2, same as all other HEAT damage classes
    DeathString="%o was burnt up by %k's Panzer IV HEAT shell."
    //  HumanObliterationThreshhold=325 // Matt: removed so uses default 400, same as all other HEAT damage classes
}
