//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SatchelDamType extends ROSatchelDamType
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
    TankDamageModifier=0.4 //was 0.8
    APCDamageModifier=0.75
    VehicleDamageModifier=1.0
    TreadDamageModifier=0.8
    WeaponClass=class'DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    DeathString="%o was blown up by %k's %w."
    MaleSuicide="%o was careless with his own %w."
    FemaleSuicide="%o was careless with her own %w."
}
