//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWeaponRangeMessage extends LocalMessage
    dependson(DHUnits)
    abstract;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local int Range, Unit;
    class'UInteger'.static.ToShorts(Switch, Range, Unit);
    return string(Range) $ class'DHUnits'.static.GetDistanceUnitSymbol(EDistanceUnit(Unit));
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
    local float X, Y;

    X = Canvas.ClipX * default.PosX;
    Y = Canvas.ClipY * default.PosY;

    MessageString = GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    const MESSAGE_MARGIN = 8;

    Canvas.Font = class'DHHud'.static.GetConsoleFont(Canvas);

    Canvas.TextSize(MessageString, XL, YL);
    Canvas.SetPos(X - (XL / 2) - MESSAGE_MARGIN, Y - (YL / 2) - MESSAGE_MARGIN);
    Canvas.DrawTile(Texture'Engine.BlackTexture', (MESSAGE_MARGIN * 2) + XL, (MESSAGE_MARGIN * 2) + YL, 0, 0, 1, 1);
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawScreenText(MessageString, default.PosX, default.PosY, DP_MiddleMiddle);
}

defaultproperties
{
    PosX=0.4
    PosY=0.55
    bComplexString=true
    bIsConsoleMessage=false
    bIsUnique=true
    bFadeMessage=true
    Lifetime=1.5
    FontSize=0
}
