//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHWeaponsLockedMessage extends LocalMessage
    abstract;

#exec OBJ LOAD FILE=..\Sounds\DHMenuSounds.uax

var localized string LockedMessage;
var localized string LockedWithTimerMessage;
var localized string UnlockedMessage;

// Modified to play a buzz sound to go with screen screen message if player's weapon's are locked and he can't fire
static function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if ((Switch == 0 || Switch == 1) && P != none)
    {
        P.ClientPlaySound(sound'DHMenuSounds.Buzz',,, SLOT_Interface);

        P.bFire = 0; // 'releases' fire button if being held down, which avoids spammed repeating messages & buzz sounds
        P.bAltFire = 0;
    }

    super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

// Modified to show appropriate weapons locked/unlocked message based on passed Switch value
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local DHPlayer PC;
    local int      WeaponLockTimeLeft;

    switch (Switch)
    {
        case 0:
            return default.LockedMessage;

        case 1:
            PC = DHPlayer(OptionalObject);

            // Get seconds remaining until weapons will be unlocked, to include in screen message to player
            if (PC != none && PC.GameReplicationInfo != none)
            {
                WeaponLockTimeLeft = PC.WeaponUnlockTime - PC.GameReplicationInfo.ElapsedTime;
            }

            return Repl(default.LockedWithTimerMessage, "{0}", WeaponLockTimeLeft);

        case 2:
            return default.UnlockedMessage;
    }

    return "";
}

// Modified to show message in red if weapon is locked, or white when unlocked
static function color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    if (Switch == 0 || Switch == 1)
    {
        return class'UColor'.default.Red;
    }

    return class'UColor'.default.White;
}

defaultproperties
{
    bFadeMessage=true
    bIsConsoleMessage=false
    bIsUnique=true
    Lifetime=2.5
    PosY=0.8
    LockedMessage="Your weapons have been locked due to excessive spawn killing!"
    LockedWithTimerMessage="Your weapons are locked for {0} seconds"
    UnlockedMessage="Your weapons are now unlocked"
}
