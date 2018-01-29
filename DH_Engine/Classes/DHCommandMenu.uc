//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCommandMenu extends Object
    abstract;

struct OptionRenderInfo
{
    var string      OptionName;
    var string      InfoText;
    var Material    InfoIcon;
    var color       InfoColor;
};

struct Option
{
    var localized string ActionText;
    var localized string SubjectText;
    var Material ActionIcon;
    var Material Material;
    var Object OptionalObject;
};

var array<Option> Options;

var DHCommandInteraction    Interaction;
var DHCommandMenu           NextMenu;
var DHCommandMenu           PreviousMenu;
var Object                  MenuObject;
var int                     SlotCount;
var int                     SlotCountOverride;  // If non-zero, the amount of slots will always be at least this many.

// Called before pushed onto the stack
function Setup()
{
    SlotCount = Max(Options.Length, SlotCountOverride);
}

function int GetOptionIndexFromSlotIndex(int SlotIndex)
{
    local int i;

    SlotIndex = SlotIndex % SlotCount;

    for (i = 0; i < Options.Length; ++i)
    {
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
    ORI.InfoText = Options[OptionIndex].SubjectText;
    ORI.InfoColor = class'UColor'.default.White;
}

function bool IsOptionDisabled(int OptionIndex);
function bool ShouldHideMenu();

function OnPush();                      // Called when the menu is pushed to the top of the stack
function OnPop();                       // Called when a menu is popped off of the top of the stack
function OnActive();                    // Called when a menu becomes the topmost menu on the stack
function OnPassive();                   // Called when a menu is no longer the topmost menu on the stack
function OnHoverIn(int OptionIndex);    // Called when a menu option is hovered over
function OnHoverOut(int OptionIndex);   // Called when a menu option is no longer being hovered over
function OnSelect(int OptionIndex, vector Location);

