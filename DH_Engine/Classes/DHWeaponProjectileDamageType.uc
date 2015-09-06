//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWeaponProjectileDamageType extends ROWeaponProjectileDamageType
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
    DeathString="%o was killed by %k's %w."
    FemaleSuicide="%o was killed by her own %w."
    MaleSuicide="%o was killed by his own %w."
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
}

