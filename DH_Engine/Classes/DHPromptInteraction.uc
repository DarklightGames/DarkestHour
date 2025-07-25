//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// An interaction that prompts the player for a response.
//==============================================================================

class DHPromptInteraction extends DHInteraction
    abstract;

// Prompt
var localized string PromptText;

// Options
struct Option
{
    var EInputKey Key;
    var localized string Text;
};
var array<Option> Options;
var string OptionsText;
var Color KeyTextColor;

function OnOptionSelected(int Index)
{
    Master.RemoveInteraction(self);
}

function Initialize()
{
    local int i;
    local array<string> OptionStrings;

    super.Initialize();

    for (i = 0; i < Options.Length; ++i)
    {
        OptionStrings[OptionStrings.Length] = Class'GameInfo'.static.MakeColorCode(KeyTextColor) $
        "[" $ GetFriendlyName(Options[i].Key) $ "]" $ Class'GameInfo'.static.MakeColorCode(Class'UColor'.default.White) @ Options[i].Text;
    }

    OptionsText = Class'UString'.static.Join(" ", OptionStrings);
}

// The interaction system is doesn't actually properly flag state, so we have to
// poll for focus directly.
simulated function bool IsFocused()
{
    local int i;

    if (ViewportOwner == none && ViewportOwner.Actor == none && ViewportOwner.Actor.Player == none)
    {
        return false;
    }

    // Find the first DHPromptInteraction and check if it's this interaction.
    // If so, we're in focus.
    for (i = 0; i < ViewportOwner.Actor.Player.LocalInteractions.Length; ++i)
    {
        if (ViewportOwner.Actor.Player.LocalInteractions[i].IsA('DHPromptInteraction'))
        {
            return ViewportOwner.Actor.Player.LocalInteractions[i] == self;
        }
    }

    return false;
}

simulated function PostRender(Canvas C)
{
    local string MyPromptText;
    local float X, Y, XL, YL;

    if (!IsFocused())
    {
        // Don't display this prompt unless it's actually receiving input.
        return;
    }

    X = 8;

    super.PostRender(C);

    C.DrawColor = Class'UColor'.default.White;
    C.Font = Class'DHHud'.static.GetConsoleFont(C);

    // Prompt Text
    MyPromptText = GetPromptText();
    C.TextSize(MyPromptText, XL, YL);
    Y = (C.ClipY * 0.5) - (YL / 2);
    C.SetPos(X, Y);
    C.DrawText(MyPromptText, true);

    // Options Text
    C.TextSize(OptionsText, XL, YL);
    Y = (C.ClipY * 0.5) - (YL / 2) + YL;
    C.SetPos(X, Y);
    C.DrawText(OptionsText, true);
}

function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
{
    local int i;

    if (Action == IST_Press)
    {
        for (i = 0; i < Options.Length; ++i)
        {
            if (Options[i].Key == Key)
            {
                OnOptionSelected(i);
                return true;
            }
        }
    }

    return false;
}

// Override for a more dynamic prompt text (this is called every frame)
function string GetPromptText()
{
    return PromptText;
}

function NotifyLevelChange()
{
    super.NotifyLevelChange();

    Master.RemoveInteraction(self);
}

defaultproperties
{
    bActive=true
    bVisible=true
    KeyTextColor=(R=255,G=255,B=0,A=255)
}

