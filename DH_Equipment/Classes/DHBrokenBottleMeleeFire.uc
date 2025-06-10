//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
    DamageType=Class'DHTrenchMaceBashDamageType'
    DamageMin=150
    DamageMax=300
    TraceRange=120.0
    FireRate=0.21
    BashBackAnim="bash_pullback_bottle"
    BashHoldAnim="bash_hold_bottle"
    BashAnim="bash_attack_bottle"
    BashFinishAnim="bash_return_bottle"
    //TearDownSound=SoundGroup'DH_WeaponSounds.Shovel.shovel_hit'
    // TODO: These sounds got lost in a merge & need to be added back.
    // GroundBashSound=Sound'DH_WeaponSounds.Halloween.BottleSmack'
    // GroundStabSound=Sound'DH_WeaponSounds.Halloween.BottleSmack'
    // PlayerStabSound=Sound'DH_WeaponSounds.Halloween.BottleStab'
    // PlayerBashSound=Sound'DH_WeaponSounds.Halloween.BottleStab'
}
