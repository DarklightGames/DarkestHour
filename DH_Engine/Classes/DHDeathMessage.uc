//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHDeathMessage extends RODeathMessage;

// Modified to handle suicided death messages, if Killer is same as Killed
// Also to make into a generic function, avoiding the need for repeated functionality in various DamageType classes to insert a weapon name
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerReplicationInfo Killer, Victim;
    local class<DamageType>     DamageType;
    local string                DeathString, KillerName, VictimName;

    DamageType = class<DamageType>(OptionalObject);

    if (DamageType == none)
    {
        return "";
    }

    Killer = RelatedPRI_1;
    Victim = RelatedPRI_2;

    if (Victim != none)
    {
        VictimName = Victim.PlayerName;

    }
    else
    {
        VictimName = default.SomeoneString;
    }

    if (Killer == Victim && Victim != none)
    {
        if (Victim.bIsFemale)
        {
            DeathString = DamageType.default.FemaleSuicide;
        }
        else
        {
            DeathString = DamageType.default.MaleSuicide;
        }
    }
    else
    {
        if (Killer != none)
        {
            KillerName = Killer.PlayerName;
        }
        else
        {
            KillerName = default.SomeoneString;
        }

        DeathString = DamageType.default.DeathString;
    }

    if (class<WeaponDamageType>(DamageType) != none && class<WeaponDamageType>(DamageType).default.WeaponClass != none)
    {
        DeathString = Repl(DeathString, "%w", class<WeaponDamageType>(DamageType).default.WeaponClass.default.ItemName, false);
    }

    return class'GameInfo'.static.ParseKillMessage(KillerName, VictimName, DeathString);
}
