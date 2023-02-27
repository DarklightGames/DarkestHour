//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCommandMenu extends Object
    abstract;

const MAX_LABELS = 3;

var color SpottingMarkerDisabledColor;
var color SpottingMarkerEnabledColor;

struct OptionRenderInfo
{
    var string      OptionName;
    var string      InfoText[MAX_LABELS];
    var Material    InfoIcon;
    var color       InfoColor;
    var string      DescriptionText;
};

struct Option
{
    var string ActionText;    // TODO: rename Action/Subject to something more understandable
    var string SubjectText;
    var string DescriptionText;
    var Material ActionIcon;
    var Material Material;
    var Object OptionalObject;
    var Color IconColor;    // If unspecified, will default to white.
    var int OptionalInteger;
};

var array<Option> Options;

var DHCommandInteraction    Interaction;
var DHCommandMenu           NextMenu;
var DHCommandMenu           PreviousMenu;
var Object                  MenuObject;
var int                     SlotCount;
var int                     SlotCountOverride;  // If non-zero, the amount of slots will always be at least this many.

var bool                    bShouldTick;
var bool                    bUsesSpottingMarker;

// Called before pushed onto the stack
function Setup()
{
    local int i, OptionCount;

    for (i = 0; i < Options.Length; ++i)
    {
        if (!IsOptionHidden(i))
        {
            ++OptionCount;
        }
    }

    SlotCount = Max(OptionCount, SlotCountOverride);
}

function int GetOptionIndexFromSlotIndex(int SlotIndex)
{
    local int i;

    SlotIndex = SlotIndex % SlotCount;

    for (i = 0; i < Options.Length; ++i)
    {
        if (IsOptionHidden(i))
        {
            continue;
        }

        if (SlotIndex <= 0)
        {
            return i;
        }

        SlotIndex -= 1;
    }

    return -1;
}

function DHPlayer GetPlayerController()
{
    if (Interaction != none && Interaction.ViewportOwner != none)
    {
        return DHPlayer(Interaction.ViewportOwner.Actor);
    }

    return none;
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    if (OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    ORI.OptionName = Options[OptionIndex].ActionText;
    ORI.InfoText[0] = Options[OptionIndex].SubjectText;
    ORI.InfoColor = class'UColor'.default.White;
    ORI.DescriptionText = Options[OptionIndex].DescriptionText;
}

// Called when the menu is pushed to the top of the stack
function OnPush()
{
    local DHPlayer PC;

    if (bUsesSpottingMarker)
    {
        PC = GetPlayerController();

        if (PC == none)
        {
            return;
        }

        if (PC.SpottingMarker == none)
        {
            PC.SpottingMarker = PC.Spawn(class'DHSpottingMarker', PC);
        }

        if (PC.SpottingMarker != none)
        {
            PC.SpottingMarker.SetColor(default.SpottingMarkerEnabledColor);
            PC.SpottingMarker.bHidden = false;
        }
    }
}

// Called when a menu is popped off of the top of the stack
function OnPop()
{
    local DHPlayer PC;

    if (bUsesSpottingMarker)
    {
        PC = GetPlayerController();

        if (PC != none && PC.SpottingMarker != none && !PC.SpottingMarker.bHidden)
        {
            PC.SpottingMarker.bHidden = true;
        }
    }
}

function bool IsOptionDisabled(int OptionIndex);
function bool ShouldHideMenu();
function bool IsOptionHidden(int OptionIndex) { return false; } // This will only get run once when the menu is pushed onto the stack.

function OnActive();                    // Called when a menu becomes the topmost menu on the stack
function OnPassive();                   // Called when a menu is no longer the topmost menu on the stack
function OnHoverIn(int OptionIndex);    // Called when a menu option is hovered over
function OnHoverOut(int OptionIndex);   // Called when a menu option is no longer being hovered over
function OnSelect(int OptionIndex, vector Location);

function Tick();                        // Called every frame if bShouldTick is true and the menu is at the top of the stack

defaultproperties
{
    SpottingMarkerDisabledColor=(B=0,G=0,R=255,A=255)
    SpottingMarkerEnabledColor=(B=0,G=255,R=0,A=255)
    bShouldTick=false
}

