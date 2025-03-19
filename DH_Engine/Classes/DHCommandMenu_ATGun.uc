//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCommandMenu_ATGun extends DHCommandMenu
    dependson(DHATGun);

var localized string EnemyGunText;
var localized string CannotBeRotatedText;
var localized string IsBeingRotatedText;
var localized string OccupiedText;
var localized string FatalText;
var localized string CooldownText;
var localized string BusyText;
var localized string CannotBePickUpText;
var localized string PlayerMovingText;

var DHATGun.ERotateError RotationError;
var DHATGun.EPickUpError PickUpError;
var int                  TeammatesInRadiusCount;

function PickUpStationaryWeapon(DHPawn Pawn, DHATGun Gun)
{
    local DHStationaryWeapon StationaryWeapon;

    if (Pawn == none || Gun == none)
    {
        return;
    }

    // Give the player the stationary gun, delete the construction.
    // Make sure to store the state of the weapon in the inventory item.
    Pawn.GiveWeapon(string(Gun.StationaryWeaponClass));

    // Find the reference to the weapon that we just gave the player and transfer the state.
    StationaryWeapon = DHStationaryWeapon(Pawn.FindInventoryType(Gun.StationaryWeaponClass));

    if (StationaryWeapon != none)
    {
        StationaryWeapon.VehicleState = Gun.GetVehicleState();
    }

    Gun.Destroy();
}

function OnSelect(int OptionIndex, vector Location, optional vector HitNormal)
{
    local DHPlayer PC;
    local DHPawn P;
    local DHATGun Gun;

    PC = GetPlayerController();
    Gun = DHATGun(MenuObject);

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
        case 0: // Rotate
            if (RotationError == ERROR_None)
            {
                P.EnterATRotation(Gun);
            }
            break;
        case 1: // Pick Up
            if (PickUpError == ERROR_None)
            {
                PickUpStationaryWeapon(P, Gun);
            }
            break;
        default:
            break;
    }

    Interaction.Hide();
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local DHATGun Gun;
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;

    Gun = DHATGun(MenuObject);

    super.GetOptionRenderInfo(OptionIndex, ORI);
    
    if (Gun == none)
    {
        return;
    }
    
    UpdateErrors();

    switch (OptionIndex)
    {
        case 0: // Rotate

            if (RotationError != ERROR_None)
            {
                ORI.InfoColor = class'UColor'.default.Red;
            }
            else
            {
                ORI.InfoColor = class'UColor'.default.White;
            }

            switch (RotationError)
            {
                case ERROR_Busy:
                    ORI.InfoText[0] = default.BusyText;
                    break;
                case ERROR_Occupied:
                    ORI.InfoText[0] = default.OccupiedText;
                    break;
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
                    ORI.InfoText[0] = class'DHATCannonMessage'.default.GunIsRotating;
                    break;
                case ERROR_EnemyGun:
                    ORI.InfoText[0] = default.EnemyGunText;
                    break;
                case ERROR_NeedMorePlayers:
                    ORI.InfoIcon = Texture'DH_InterfaceArt2_tex.Icons.squad';
                    ORI.InfoText[0] = string(TeammatesInRadiusCount) $ "/" $ string(Gun.PlayersNeededToRotate);
                    break;
                default:
                    break;
            }
            break;
        
        case 1: // Pick Up
            if (PickUpError != ERROR_None)
            {
                ORI.InfoColor = class'UColor'.default.Red;
            }
            else
            {
                ORI.InfoColor = class'UColor'.default.White;
            }

            switch (PickUpError)
            {
                case ERROR_CannotBePickedUp:
                    ORI.InfoText[0] = default.CannotBePickUpText;
                    break;
                case ERROR_Occupied:
                    ORI.InfoText[0] = default.OccupiedText;
                    break;
                case ERROR_Fatal:
                    ORI.InfoText[0] = default.FatalText;
                    break;
                case ERROR_Busy:
                    ORI.InfoText[0] = default.BusyText;
                    break;
                case ERROR_PlayerMoving:
                    ORI.InfoText[0] = default.PlayerMovingText;
                    break;
                default:
                    break;
            }
            break;
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    UpdateErrors();

    switch (OptionIndex)
    {
        case 0: // Rotate
            return RotationError != ERROR_None;
        case 1: // Pick Up
            return PickUpError != ERROR_None;
        default:
            return false;
    }
}

simulated function UpdateErrors()
{
    local DHPlayer PC;
    local DHPawn DHP;
    local DHATGun Gun;

    RotationError = ERROR_Fatal;
    PickUpError = ERROR_Fatal;

    PC = GetPlayerController();
    Gun = DHATGun(MenuObject);

    if (PC != none && Gun != none)
    {
        DHP = DHPawn(PC.Pawn);
        RotationError = Gun.GetRotationError(DHP, TeammatesInRadiusCount);
        PickUpError = Gun.GetPickUpError(DHP);
    }
}

defaultproperties
{
    Options(0)=(ActionText="Rotate",Material=Texture'DH_InterfaceArt2_tex.Rotate')
    Options(1)=(ActionText="Pick Up",Material=Texture'DH_InterfaceArt2_tex.pickup_icon',HoldTime=3.0)
    EnemyGunText="Cannot rotate an enemy gun"
    CannotBePickUpText="Cannot be picked up"
    CannotBeRotatedText="Cannot be rotated"
    OccupiedText="Gun is occupied"
    FatalText="Rotation unavailable"
    CooldownText="Wait"
    BusyText="Busy"
    PlayerMovingText="Must be stationary"
}
