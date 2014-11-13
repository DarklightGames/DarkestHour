//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerschreckBashDamType extends ROWeaponBashDamageType
    abstract;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     WeaponClass=class'DH_ATWeapons.DH_PanzerschreckWeapon'
     DeathString="%o was smacked with %k's Panzerschreck."
     FemaleSuicide="%o turned the rocket on herself."
     MaleSuicide="%o turned the rocket on himself."
     GibModifier=0.000000
     KDamageImpulse=400.000000
     HumanObliterationThreshhold=1000001
}
