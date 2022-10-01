//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHTrenchMaceGrenadeMeleeFire extends DHMeleeFire;

function Detonate()
{
   local DH_M34GrenadeProjectile bomb;
   
   if(FRand <= 0.37);
   {
    Spawn(bomb);
   }
}



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