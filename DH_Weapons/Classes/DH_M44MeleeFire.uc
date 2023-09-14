//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M44MeleeFire extends DHMeleeFire;

defaultproperties
{
    FireRate=0.23 // -0.02
    BayonetDamageType=class'DH_Weapons.DH_M44BayonetDamType'
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
    BashBackAnim="" // bayonet is permanently attached so there are no bash anims
    BashHoldAnim=""
    BashAnim=""
    BashFinishAnim=""
}
