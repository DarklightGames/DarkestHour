//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommandMenu_ATGun extends DHCommandMenu
    dependson(DHATGun);

var localized string EnemyGunText;
var localized string CannotBeRotatedText;
var localized string IsBeingRotatedText;
var localized string OccupiedText;
var localized string FatalText;
var localized string CooldownText;

var DHATGun.ERotateError RotationError;
var int                  TeammatesInRadiusCount;

function OnSelect(int Index, vector Location)
{
    local DHPlayer PC;
    local DHPawn P;
    local DHATGun Gun;

    PC = GetPlayerController();
    Gun = DHATGun(MenuObject);

    if (PC == none || Index < 0 || Index >= Options.Length || Gun == none)
    {
        return;
    }

    P = DHPawn(PC.Pawn);

    if (P == none)
    {
        return;
    }

    UpdateRotationError();

    switch (Index)
    {
        case 0: // Rotate
            if (RotationError == ERROR_None)
            {
                P.EnterATRotation(Gun);
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

    if (OptionIndex != 0)
    {
        return;
    }

    UpdateRotationError();

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
}

function bool IsOptionDisabled(int OptionIndex)
{
    switch (OptionIndex)
    {
        case 0: // Rotate
            UpdateRotationError();
            return RotationError != ERROR_None;
            break;
        default:
            return false;
            break;
    }
}

simulated function UpdateRotationError()
{
    local DHPlayer PC;
    local DHPawn Pawn;
    local DHATGun Gun;

    PC = GetPlayerController();
    Gun = DHATGun(MenuObject);

    if (PC != none)
    {
        Pawn = DHPawn(PC.Pawn);

        if (Gun != none)
        {
            RotationError = Gun.GetRotationError(Pawn, TeammatesInRadiusCount);
            return;
        }
    }

    RotationError = ERROR_Fatal;
    return;
}

defaultproperties
{
    Options(0)=(ActionText="Rotate",Material=Texture'DH_InterfaceArt2_tex.Rotate')
    EnemyGunText="Cannot rotate an enemy gun"
    CannotBeRotatedText="Cannot be rotated"
    OccupiedText="Gun is occupied"
    FatalText="Rotation unavailable"
    CooldownText="Wait"
}
