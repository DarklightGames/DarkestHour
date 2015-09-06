//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleDamageType extends ROVehicleDamageType
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
    DeathString="%o was killed by %k's %w"
    MaleSuicide="%o was killed by his own %w"
    FemaleSuicide="%o was killed by her own %w"
    GibModifier=0.0
    PawnDamageEmitter=class'ROEffects.ROBloodPuff'
    LowDetailEmitter=class'ROEffects.ROBloodPuffSmall'
    LowGoreDamageEmitter=class'ROEffects.ROBloodPuffNoGore'
    KDamageImpulse=200.0
}
