//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHStationaryWeaponMessage extends ROCriticalMessage
    abstract;

var localized string MustCrouch;
var localized string MustBeStill;
var localized string CannotLean;
var localized string BadSurface;
var localized string NotEnoughRoom;
var localized string CannotDeploy;
var localized string InWater;
var localized string NotQualified;
var localized string InUse;
var localized string EnemyWeapon;

static function string GetSwitchString(int Switch)
{
    switch (Switch)
    {
        case 1:
            return default.MustCrouch;
        case 3:
            return default.MustBeStill;
        case 4:
            return default.BadSurface;
        case 5:
            return default.NotEnoughRoom;
        case 6:
            return default.CannotLean;
        case 7:
            return default.InWater;
        case 8:
            return default.NotQualified;
        case 9:
            return default.InUse;
        case 10:
            return default.EnemyWeapon;
        case 11:
            return default.CannotDeploy;
        default:
            return default.CannotDeploy;
    }
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local DHWeapon Weapon;
    local DHPlayer PC;

    Weapon = DHWeapon(OptionalObject);

    if (Weapon == none || Weapon.Level == none)
    {
        return "";
    }

    PC = DHPlayer(Weapon.Level.GetLocalPlayerController());

    if (PC == none)
    {
        return "";
    }

    return Repl(GetSwitchString(Switch), "{weapon}", PC.GetInventoryName(Weapon.Class));
}

defaultproperties
{
    MustCrouch="You must be crouched to deploy your {weapon}"
    MustBeStill="You cannot deploy your {weapon} while moving"
    CannotLean="You cannot deploy your {weapon} while leaning"
    BadSurface="You cannot deploy your {weapon} on this surface"
    NotEnoughRoom="You do not have enough room to deploy your {weapon} here"
    CannotDeploy="You cannot deploy your {weapon} here"
    InWater="You cannot deploy your {weapon} in water"
    NotQualified="You are not qualified to operate this {weapon}"
    InUse="You cannot operate this {weapon} as it is currently in use"
    EnemyWeapon="You cannot operate an enemy {weapon}"
}
