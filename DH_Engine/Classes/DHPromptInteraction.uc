//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
var color KeyTextColor;

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
        OptionStrings[OptionStrings.Length] = class'GameInfo'.static.MakeColorCode(KeyTextColor) $
        "[" $ GetFriendlyName(Options[i].Key) $ "]" $ class'GameInfo'.static.MakeColorCode(class'UColor'.default.White) @ Options[i].Text;
    }

    OptionsText = class'UString'.static.Join(" ", OptionStrings);
}

simulated function PostRender(Canvas C)
{
    local string MyPromptText;
    local float X, Y, XL, YL;

    X = 8;

    super.PostRender(C);

    C.DrawColor = class'UColor'.default.White;
    C.Font = class'DHHud'.static.GetConsoleFont(C);

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

