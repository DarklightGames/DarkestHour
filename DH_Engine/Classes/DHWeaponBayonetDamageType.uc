//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWeaponBayonetDamageType extends ROWeaponBayonetDamageType
    abstract;

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
    return Repl(default.DeathString, "%w", default.WeaponClass.default.ItemName, false);
}

static function string SuicideMessage(PlayerReplicationInfo Victim)
{
    local string SuicideMessage;

    if (Victim.bIsFemale)
    {
        SuicideMessage = default.FemaleSuicide;
    }
    else
    {
        SuicideMessage = default.MaleSuicide;
    }

    return Repl(SuicideMessage, "%w", default.WeaponClass.default.ItemName, false);
}

defaultproperties
{
    DeathString="%o was skewered on %k's %w bayonet."
    MaleSuicide="%o skewered himself on his own %w bayonet."
    FemaleSuicide="%o skewered herself on her own %w bayonet."
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    KDamageImpulse=400.0
    HumanObliterationThreshhold=1000001
}
