//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShovelMeleeFire extends DHMeleeFire;

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
    DamageType=Class'DHShovelBashDamageType'
    DamageMin=50
    DamageMax=90
    TraceRange=95.0
    FireRate=0.21
    BashBackAnim="bash_pullback"
    BashHoldAnim="bash_hold"
    BashAnim="bash_attack"
    BashFinishAnim="bash_return"
    TearDownSound=SoundGroup'DH_WeaponSounds.shovel_hit'
}
