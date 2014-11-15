//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHWeaponBayonetDamageType extends ROWeaponBayonetDamageType
    abstract;

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
    return Repl(default.DeathString, "%w", default.WeaponClass.default.ItemName, false);
}

defaultproperties
{
    DeathString="%o was stabbed by %k's %w bayonet."
    FemaleSuicide="%o stabbed herself with her %w bayonet."
    MaleSuicide="%o stabbed himself with his %w bayonet."
    GibModifier=0.000000
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=400.000000
    HumanObliterationThreshhold=1000001
}
