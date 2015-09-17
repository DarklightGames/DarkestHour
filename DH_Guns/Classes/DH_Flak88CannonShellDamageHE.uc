//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak88CannonShellDamageHE extends DH_TigerCannonShellDamageHE
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    HumanObliterationThreshhold=450 // TEST - this is different to parent, which has 425, but should be the same
}
