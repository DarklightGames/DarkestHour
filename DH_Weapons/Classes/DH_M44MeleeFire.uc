//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M44MeleeFire extends DHMeleeFire;

defaultproperties
{
    BayonetDamageType=class'DH_Weapons.DH_M44BayonetDamType'
    TraceRange=75.0
    BayonetTraceRange=125.0
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
    BotRefireRate=0.25
    AimError=800.0
}
