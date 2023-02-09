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

var array<Control> Controls;

static function RenderComplexMessage(Canvas Canvas,
                              out float XL,
                              out float YL,
                              optional string
                              MessageString,
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

    PC = PlayerController(OptionalObject);

    X = Canvas.ClipX * default.PosX;
    Y = Canvas.ClipY * default.PosY;

    for (i = 0; i < default.Controls.Length; ++i)
    {
        Keys.Length = 0;

        for (j = 0; j < default.Controls[i].Keys.Length; ++j)
        {
            Keys[Keys.Length] = class'GameInfo'.static.MakeColorCode(class'Canvas'.static.MakeColor(200, 200, 200)) $
                                "[" $ class'ROTeamGame'.static.ParseLoadingHintNoColor("%" $ default.Controls[i].Keys[j] $ "%", PC) $ "]" $
                                class'GameInfo'.static.MakeColorCode(class'UColor'.default.White);
        }

        S = class'UString'.static.Join(" / ", Keys) @ default.Controls[i].Text;

        Canvas.TextSize(S, XL, YL);
        Canvas.SetDrawColor(0, 0, 0);
        Canvas.DrawTextJustified(class'UString'.static.StripColor(S), 1, 1, Y + 1, Canvas.ClipX + 1, Y + YL + 1);
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
    FontSize=-2
}

