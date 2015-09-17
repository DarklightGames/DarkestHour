//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flak38CannonShellDamageAP extends DH_Sdkfz2341CannonShellDamageAP;

defaultproperties
{
    HUDIcon=texture'DH_Artillery_tex.ATGun_Hud.flakv38_deathicon' // TODO: add one specifically for single barrelled Flak 38
    HumanObliterationThreshhold=400 // TEST - this is different to parent, which has 75, but should be the same
}
