//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_6PounderCannonShellDamageAPDS extends DH_Cromwell6PdrCannonShellDamageAPDS
    abstract;

defaultproperties
{
    HUDIcon=texture'DH_InterfaceArt_tex.deathicons.ATGunKill'
    TreadDamageModifier=0.75 // TEST - this is different to parent, which has 0.95, but should be the same
}
