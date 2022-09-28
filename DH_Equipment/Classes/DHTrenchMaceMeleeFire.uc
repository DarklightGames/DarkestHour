//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHTrenchMaceMeleeFire extends DHMeleeFire;


defaultproperties
{
    DamageType=class'DH_Equipment.DHTrenchMaceBashDamageType'
    DamageMin=70
    DamageMax=150
    TraceRange=95.0
    FireRate=0.21
    BashBackAnim="bash_pullback"
    BashHoldAnim="bash_hold"
    BashAnim="bash_attack"
    BashFinishAnim="bash_return"
    //TearDownSound=SoundGroup'DH_WeaponSounds.Shovel.shovel_hit'
}