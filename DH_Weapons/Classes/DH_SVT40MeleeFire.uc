//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40MeleeFire extends DHMeleeFire;

function PlayFireEnd()
{
    if (Weapon.bBayonetMounted)
    {
        // No tween time for the post stab anim, as it causes a visual glitch on this weapon - hacky, but works for now
        Weapon.PlayAnim(BayoFinishAnim, FireEndAnimRate, 0.0);
    }
    else
    {
        if (Weapon.AmmoAmount(0) < 1 && Weapon.HasAnim(BashFinishEmptyAnim))
        {
            Weapon.PlayAnim(BashFinishEmptyAnim, FireEndAnimRate, TweenTime);
        }
        else
        {
            Weapon.PlayAnim(BashFinishAnim, FireEndAnimRate, TweenTime);
        }
    }
}

defaultproperties
{
    DamageType=class'DH_Weapons.DH_SVT40BashDamType'
    BayonetDamageType=class'DH_Weapons.DH_SVT40BayonetDamType'
    BashBackAnim="bash_pullback"
    BashHoldAnim="bash_hold"
    BashAnim="bash_attack"
    BashFinishAnim="bash_return"
    BayoBackAnim="stab_pullback"
    BayoHoldAnim="stab_hold"
    BayoStabAnim="stab_attack"
    BayoFinishAnim="stab_return"
    TraceRange=75.0
    BayonetTraceRange=115.0
    BotRefireRate=0.25
    AimError=800.0
}
