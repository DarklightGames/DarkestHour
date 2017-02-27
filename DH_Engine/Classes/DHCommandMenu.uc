//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHCommandMenu extends Object
    abstract;

struct Option
{
    var localized string ActionText;
    var localized string SubjectText;
    var Material Material;
};

var array<Option> Options;

var DHCommandInteraction    Interaction;
var DHCommandMenu           NextMenu;
var DHCommandMenu           PreviousMenu;
var Object                  MenuObject;

function GetOptionText(int OptionIndex, out string ActionText, out string SubjectText)
{
    if (OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    ActionText = Options[OptionIndex].ActionText;
    SubjectText = Options[OptionIndex].SubjectText;
}

function bool ShouldHideMenu();
function OnPush();              // Called when the menu is pushed to the top of the stack
function OnPop();               // Called when a menu is popped off of the top of the stack
function OnActive();            // Called when a menu becomes the topmost menu on the stack
function OnPassive();           // Called when a menu is no longer the topmost menu on the stack
function bool OnSelect(DHCommandInteraction Interaction, int Index, vector Location);
