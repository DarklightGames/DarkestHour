//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBrokenBottleMeleeFire extends DHMeleeFire;

var Sound TearDownSound;

function Sound GetGroundBashSound(Actor HitActor, Material HitMaterial)
{
    local DHConstruction C;

    C = DHConstruction(HitActor);

    if (C != none)
    {
        if (C.CanTakeTearDownDamageFromPawn(Instigator))
        {
            return TearDownSound;
        }
        else
        {
            return super.GetGroundBashSound(HitActor, HitMaterial);
        }
    }
    else
    {
        return super.GetGroundBashSound(HitActor, HitMaterial);
    }
}

defaultproperties
{
    DamageType=class'DH_Equipment.DHTrenchMaceBashDamageType'
    DamageMin=150
    DamageMax=300
    TraceRange=120.0
    FireRate=0.21
    BashBackAnim="bash_pullback_bottle"
    BashHoldAnim="bash_hold_bottle"
    BashAnim="bash_attack_bottle"
    BashFinishAnim="bash_return_bottle"
    //TearDownSound=SoundGroup'DH_WeaponSounds.Shovel.shovel_hit'
    GroundBashSound=Sound'DH_WeaponSounds.Halloween.BottleSmack'
    GroundStabSound=Sound'DH_WeaponSounds.Halloween.BottleSmack'
    PlayerStabSound=Sound'DH_WeaponSounds.Halloween.BottleStab'
    PlayerBashSound=Sound'DH_WeaponSounds.Halloween.BottleStab'
}
