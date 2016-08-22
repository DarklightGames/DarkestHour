//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHWeaponsLockedMessage extends ROTouchMessagePlus
    abstract;

#exec OBJ LOAD FILE=..\Sounds\DHMenuSounds.uax

var localized string LockedMessage;
var localized string LockedWithTimerMessage;
var localized string UnlockedMessage;

var float   NextSoundTime;
var sound   MessageSound;

static function ClientReceive(
    PlayerController P,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    switch (Switch)
    {
    case 0:
    case 1:
        if (P != none && P.Level.TimeSeconds > default.NextSoundTime)
        {
            P.ClientPlaySound(default.MessageSound, false,, SLOT_Interface);

            default.NextSoundTime = P.Level.TimeSeconds + P.GetSoundDuration(default.MessageSound);
        }
        break;
    default:
        break;
    }

    super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    local DHPlayer PC;
    local int WeaponLockTimeLeft;

    PC = DHPlayer(OptionalObject);

    if (PC != none)
    {
        PC.IsWeaponLocked(WeaponLockTimeLeft);
    }

    switch (Switch)
    {
    case 0:
        return default.LockedMessage;
    case 1:
        return Repl(default.LockedWithTimerMessage, "{0}", WeaponLockTimeLeft);
    case 2:
        return default.UnlockedMessage;
    }
}

static function color GetColor(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2
    )
{
    switch (Switch)
    {
        case 0:
        case 1:
            return class'UColor'.default.Red;
        default:
            break;
    }

    return class'UColor'.default.White;
}

defaultproperties
{
    bFadeMessage=true
    bIsConsoleMessage=false
    bIsUnique=True
    Lifetime=2.5
    MessageSound=sound'DHMenuSounds.Buzz'
    LockedMessage="Your weapons have been locked due to excessive spawn killing!"
    LockedWithTimerMessage="Your weapons are locked for {0} seconds.";
    UnlockedMessage="Your weapons are now unlocked."
}
