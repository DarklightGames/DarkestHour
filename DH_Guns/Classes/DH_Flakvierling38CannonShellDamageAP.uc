//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flakvierling38CannonShellDamageAP extends DH_Sdkfz2341CannonShellDamageAP;

#exec OBJ LOAD FILE=..\Textures\DH_Flakvierling38_tex.utx

defaultproperties
{
    HUDIcon=Texture'DH_Flakvierling38_tex.flak.flakv38_icon'
    DeathString="%o was killed by %k's Flakvierling 38 AP shell."
    HumanObliterationThreshhold=400
}
