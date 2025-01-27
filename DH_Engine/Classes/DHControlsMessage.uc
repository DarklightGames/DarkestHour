//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHControlsMessage extends LocalMessage
    abstract;

struct Control
{
    var array<string> Keys;
    var localized string Text;
};

var Color KeyColor;

var localized string HeaderText;
var Color HeaderColor;

var array<Control> Controls;

// Override these functions to customize the message based on the context.
static function string GetHeaderString(
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2, 
    optional Object OptionalObject
    )
{
    return default.HeaderText;
}

// Override in subclasses to hide controls based on the context.
static function bool ShouldShowControl(int Index, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return true;
}

static function RenderComplexMessage(Canvas Canvas,
                              out float XL,
                              out float YL,
                              optional string MessageString,
                              optional int Switch,
                              optional PlayerReplicationInfo RelatedPRI_1,
                              optional PlayerReplicationInfo RelatedPRI_2,
                              optional Object OptionalObject)
{
    local PlayerController PC;
    local float X, Y;
    local string S;
    local int i, j;
    local array<string> Keys;

    PC = DHPlayer(RelatedPRI_1.Level.GetLocalPlayerController());

    X = Canvas.ClipX * default.PosX;
    Y = Canvas.ClipY * default.PosY;

    // TODO: based the Y-size on the number of controls.

    // Draw the header.
    S = GetHeaderString(RelatedPRI_1, RelatedPRI_2, OptionalObject);

    if (S != "")
    {
        Canvas.TextSize(S, XL, YL);
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.DrawTextJustified(S, 1, 0, Y, Canvas.ClipX, Y + YL);
        Y += YL;
    }

    // Draw the controls.
    for (i = 0; i < default.Controls.Length; ++i)
    {
        if (!ShouldShowControl(i, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject))
        {
            continue;
        }

        Keys.Length = 0;

        for (j = 0; j < default.Controls[i].Keys.Length; ++j)
        {
            Keys[Keys.Length] = class'GameInfo'.static.MakeColorCode(default.KeyColor) $
                                "[" $ class'ROTeamGame'.static.ParseLoadingHintNoColor("%" $ default.Controls[i].Keys[j] $ "%", PC) $ "]" $
                                class'GameInfo'.static.MakeColorCode(class'UColor'.default.White);
        }

        S = class'UString'.static.Join(" / ", Keys) @ default.Controls[i].Text;

        Canvas.TextSize(S, XL, YL);
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.DrawTextJustified(S, 1, 0, Y, Canvas.ClipX, Y + YL);
        Y += YL;
    }
}

defaultproperties
{
    PosY=0.8
    bComplexString=true
    bIsConsoleMessage=false
    bIsUnique=true
    bFadeMessage=false
    Lifetime=0.25
    FontSize=0
    KeyColor=(R=192,G=192,B=192,A=255)
}

