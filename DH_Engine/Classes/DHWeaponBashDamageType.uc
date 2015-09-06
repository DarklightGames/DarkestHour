//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWeaponBashDamageType extends ROWeaponBashDamageType
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
    DeathString="%o was bludgeoned to death by %k's %w."
    MaleSuicide="%o bludgeoned himself to death with his own %w."
    FemaleSuicide="%o bludgeoned herself to death with her own %w."
    GibModifier=0.0
    KDamageImpulse=400.0
    HumanObliterationThreshhold=1000001
}
