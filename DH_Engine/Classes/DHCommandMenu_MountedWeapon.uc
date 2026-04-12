//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCommandMenu_MountedWeapon extends DHCommandMenu
    dependson(DHMountedGun);

const ROTATE_OPTION_INDEX = 0;
const PICK_UP_OPTION_INDEX = 1;
const UNMOUNT_OPTION_INDEX = 2;
const MOUNT_OPTION_INDEX = 3;

var localized string EnemyGunText;
var localized string CannotBeRotatedText;
var localized string IsBeingRotatedText;
var localized string OccupiedText;
var localized string FatalText;
var localized string CooldownText;
var localized string BusyText;
var localized string CannotBePickedUpText;
var localized string PlayerMovingText;
var localized string AlreadyUnmountedText;
var localized string AlreadyMountedText;
var localized string AlreadyHasWeaponText;
var localized string IncompatibleWeapon;

var DHMountedGun.EInteractionError  InteractionError;
var DHMountedGun.ERotateError       RotationError;
var DHMountedGun.EPickUpError       PickUpError;
var DHMountedGun.EMountError        MountError;
var DHMountedGun.EUnmountError      UnmountError;

var int                             TeammatesInRadiusCount;

function bool MountWeapon(DHPawn Pawn, DHMountedGun Gun)
{
    if (Gun == none)
    {
        return false;
    }
    
    Gun.ServerMountWeapon(Pawn);

    MenuObject = none;

    return true;
}

function bool UnmountWeapon(DHPawn Pawn, DHMountedGun Gun)
{
    local DHWeapon Weapon;

    if (Gun == none)
    {
        return false;
    }

    Gun.ServerUnmountWeapon(Pawn);
    
    // Without this, the menu is holding on to a reference to the gun, which is an actor.
    // There is a bug in the engine where Objects holding on to Actors can cause segfaults when the actor is destroyed.
    // This would result in a crash about 10% of the time when the player picked up a gun.
    // This is a workaround for that bug.
    // TODO: There is still the possiblity to have the client crash if the gun is destroyed by other means while the
    // menu is open (i.e., gun is blown up or picked up by another player). We should find another method for finding
    // the gun in the world or turn this into an Actor itself.
    MenuObject = none;

    return true;
}

function PickUpMountedWeapon(DHPawn Pawn, DHMountedGun Gun)
{
    local DHMountedWeapon MountedWeapon;

    if (Pawn == none || Gun == none)
    {
        return;
    }

    // Give the player the stationary gun, delete the construction.
    // Make sure to store the state of the weapon in the inventory item.
    Pawn.GiveWeapon(string(Gun.MountedWeaponClass));

    // Find the reference to the weapon that we just gave the player and transfer the state.
    MountedWeapon = DHMountedWeapon(Pawn.FindInventoryType(Gun.MountedWeaponClass));

    if (MountedWeapon != none)
    {
        MountedWeapon.SetVehicleState(Gun.GetVehicleState());
    }

    Gun.Destroy();
    
    // Without this, the menu is holding on to a reference to the gun, which is an actor.
    // There is a bug in the engine where Objects holding on to Actors can cause segfaults when the actor is destroyed.
    // This would result in a crash about 10% of the time when the player picked up a gun.
    // This is a workaround for that bug.
    // TODO: There is still the possiblity to have the client crash if the gun is destroyed by other means while the
    // menu is open (i.e., gun is blown up or picked up by another player). We should find another method for finding
    // the gun in the world or turn this into an Actor itself.
    MenuObject = none;
}

function OnSelect(int OptionIndex, Vector Location, optional Vector HitNormal)
{
    local DHPlayer PC;
    local DHPawn P;
    local DHMountedGun Gun;

    PC = GetPlayerController();
    Gun = DHMountedGun(MenuObject);

    if (PC == none || OptionIndex < 0 || OptionIndex >= Options.Length || Gun == none)
    {
        return;
    }

    P = DHPawn(PC.Pawn);

    if (P == none)
    {
        return;
    }

    UpdateErrors();

    switch (OptionIndex)
    {
        case ROTATE_OPTION_INDEX:
            if (RotationError == ERROR_None)
            {
                P.EnterMountedGunRotation(Gun);
            }
            break;
        case PICK_UP_OPTION_INDEX:
            if (PickUpError == ERROR_None)
            {
                PickUpMountedWeapon(P, Gun);
            }
            break;
        case UNMOUNT_OPTION_INDEX:
            if (UnmountError == ERROR_None)
            {
                UnmountWeapon(P, Gun);
            }
            break;
        case MOUNT_OPTION_INDEX:
            // TODO: make sure you can't dupe weapons.
            if (MountError == ERROR_None)
            {
                MountWeapon(P, Gun);
            }
            break;
        default:
            break;
    }

    Interaction.Hide();
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local DHMountedGun Gun;
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    Gun = DHMountedGun(MenuObject);

    super.GetOptionRenderInfo(OptionIndex, ORI);
    
    if (Gun == none)
    {
        return;
    }
    
    UpdateErrors();

    switch (InteractionError)
    {
        case ERROR_PlayerBusy:
            ORI.InfoText[0] = default.BusyText;
            break;
        case ERROR_Occupied:
            ORI.InfoText[0] = default.OccupiedText;
            break;
        case ERROR_PlayerMoving:
            ORI.InfoText[0] = default.PlayerMovingText;
            break;
        case ERROR_TooFarAway:
            // The menu will close when it's too far away, so no message needed here.
            break;
        default:
            break;
    }

    switch (OptionIndex)
    {
        case ROTATE_OPTION_INDEX:

            if (RotationError != ERROR_None)
            {
                ORI.InfoColor = Class'UColor'.default.Red;
            }
            else
            {
                ORI.InfoColor = Class'UColor'.default.White;
            }

            switch (RotationError)
            {
                case ERROR_Fatal:
                    ORI.InfoText[0] = default.FatalText;
                    break;
                case ERROR_Cooldown:
                    PC = GetPlayerController();
                    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
                    ORI.InfoText[0] = default.CooldownText @ string(Gun.NextRotationTime - GRI.ElapsedTime) $ "s";
                    break;
                case ERROR_CannotBeRotated:
                    ORI.InfoText[0] = default.CannotBeRotatedText;
                    break;
                case ERROR_IsBeingRotated:
                    ORI.InfoText[0] = Class'DHATCannonMessage'.default.GunIsRotating;
                    break;
                case ERROR_EnemyGun:
                    ORI.InfoText[0] = default.EnemyGunText;
                    break;
                case ERROR_NeedMorePlayers:
                    ORI.InfoIcon = Texture'DH_InterfaceArt2_tex.squad';
                    ORI.InfoText[0] = string(TeammatesInRadiusCount) $ "/" $ string(Gun.PlayersNeededToRotate);
                    break;
                default:
                    break;
            }
            break;
        
        case PICK_UP_OPTION_INDEX:
            if (PickUpError != ERROR_None)
            {
                ORI.InfoColor = Class'UColor'.default.Red;
            }
            else
            {
                ORI.InfoColor = Class'UColor'.default.White;
            }

            switch (PickUpError)
            {
                case ERROR_CannotBePickedUp:
                    ORI.InfoText[0] = default.CannotBePickedUpText;
                    break;
                case ERROR_Fatal:
                    ORI.InfoText[0] = default.FatalText;
                    break;
                default:
                    break;
            }
            break;
        case UNMOUNT_OPTION_INDEX:
            if (UnmountError != ERROR_None)
            {
                ORI.InfoColor = Class'UColor'.default.Red;
            }
            else
            {
                ORI.InfoColor = Class'UColor'.default.White;
            }

            switch (UnmountError)
            {
                case ERROR_Unmounted:
                    ORI.InfoText[0] = default.AlreadyUnmountedText;
                    break;
                case ERROR_NotAllowed:
                    // If it's not allowed, this option won't be visible!
                    break;
                case ERROR_AlreadyHasWeapon:
                    ORI.InfoText[0] = default.AlreadyHasWeaponText;
                    break;
            }
            break;
        case MOUNT_OPTION_INDEX:

            if (MountError != ERROR_None)
            {
                ORI.InfoColor = Class'UColor'.default.Red;
            }
            else
            {
                ORI.InfoColor = Class'UColor'.default.White;
            }

            switch (MountError)
            {
                case ERROR_Mounted:
                    ORI.InfoText[0] = default.AlreadyMountedText;
                    break;
                case ERROR_NotAllowed:
                    // If it's not allowed, this option won't be visible.
                    break;
                case ERROR_IncompatibleWeapon:
                    ORI.InfoText[0] = default.IncompatibleWeapon;
                    break;
            }
            break;
    }
}


// Modified to hide the unmount option when the gun doesn't allow this.
function bool IsOptionHidden(int OptionIndex)
{
    local DHPlayer PC;
    local DHMountedGun Gun;

    PC = GetPlayerController();
    Gun = DHMountedGun(MenuObject);

    if (PC == none || Gun == none)
    {
        return true;
    }

    switch (OptionIndex)
    {
        case UNMOUNT_OPTION_INDEX:
        case MOUNT_OPTION_INDEX:
            if (!Gun.CanWeaponBeUnmounted())
            {
                // Gun cannot be unmounted. Hide the related options.
                return true;
            }
        default:
            break;
    }
    
    switch (OptionIndex)
    {
        case UNMOUNT_OPTION_INDEX:
            // If the weapon is not mounted, then we can't unmount it, so hide the option.
            return !Gun.bIsWeaponMounted;
        case MOUNT_OPTION_INDEX:
            // If the weapon is mounted, we can't mount it again.
            return Gun.bIsWeaponMounted;
        default:
            return super.IsOptionHidden(OptionIndex);
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    UpdateErrors();

    if (InteractionError != ERROR_None)
    {
        return true;
    }

    switch (OptionIndex)
    {
        case ROTATE_OPTION_INDEX:
            return RotationError != ERROR_None;
        case PICK_UP_OPTION_INDEX:
            return PickUpError != ERROR_None;
        case UNMOUNT_OPTION_INDEX:
            return UnmountError != ERROR_None;
        case MOUNT_OPTION_INDEX:
            return MountError != ERROR_NOne;
        default:
            return false;
    }
}

simulated function UpdateErrors()
{
    local DHPlayer PC;
    local DHPawn DHP;
    local DHMountedGun Gun;

    InteractionError = ERROR_Fatal;
    RotationError = ERROR_Fatal;
    PickUpError = ERROR_Fatal;
    MountError = ERROR_Fatal;
    UnmountError = ERROR_Fatal;

    PC = GetPlayerController();
    Gun = DHMountedGun(MenuObject);

    if (PC != none && Gun != none)
    {
        DHP = DHPawn(PC.Pawn);
        InteractionError = Gun.GetInteractionError(DHP);
        RotationError = Gun.GetRotationError(DHP, TeammatesInRadiusCount);
        PickUpError = Gun.GetPickUpError(DHP);
        MountError = Gun.GetMountError(DHP);
        UnmountError = Gun.GetUnmountError(DHP);
    }
}

public function bool ShouldHideMenu()
{
    // TODO: close this if we are too far away for any interaction.
    return false;
}

defaultproperties
{
    Options(0)=(ActionText="Rotate",Material=Texture'DH_InterfaceArt2_tex.Rotate')
    Options(1)=(ActionText="Pick Up",Material=Texture'DH_InterfaceArt2_tex.pickup_icon',HoldTime=2.5,HoldSound=Sound'DH_MortarSounds.mortar_pickup')
    Options(2)=(ActionText="Detatch Weapon",Material=Texture'DH_InterfaceArt2_tex.pickup_icon',HoldTime=2.5,HoldSound=Sound'DH_MortarSounds.mortar_pickup',Tag=1)
    Options(3)=(ActionText="Attach Weapon",Material=Texture'DH_InterfaceArt2_tex.pickup_icon',HoldTime=2.5,HoldSound=Sound'DH_MortarSounds.mortar_pickup',Tag=2)
    EnemyGunText="Cannot rotate an enemy gun"
    CannotBePickedUpText="Cannot be picked up"
    CannotBeRotatedText="Cannot be rotated"
    OccupiedText="Gun is occupied"
    FatalText="Interaction unavailable"
    CooldownText="Wait"
    BusyText="Busy"
    PlayerMovingText="Must be stationary"
    AlreadyUnmountedText="Weapon already detached"
    AlreadyMountedText="Weapon already attached"
    AlreadyHasWeaponText="Already holding weapon"
    IncompatibleWeapon="Weapon incompatible"
}
