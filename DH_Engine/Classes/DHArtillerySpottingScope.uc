//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHArtillerySpottingScope extends ROVehicle
    abstract;

// Range table
struct SRangeTableRecord
{
    var float  Pitch;                                     // in degrees or milliradians
    var int    Range;                                     // in meters
    var string PitchString;                               // calculated on first use!
};
var array<SRangeTableRecord>    RangeTable;

var int PitchDecimals;

struct STargetInfo
{
    var int                               Distance;       // distance between the player and the target
    var int                               YawCorrection;  // how many ticks on the dial is the target deflected from current aiming direction
    var string                            SquadName;      // name of the squad that requests fire support
    var class<DHMapMarker>                Type;           // Fire_Support or Ruler
};

var     localized string    RangeString;
var     localized string    ElevationString;
var     texture             SpottingScopeOverlay;       // periscope overlay texture

var     float               YawScaleStep;               // how quickly yaw indicator should traverse
var     float               PitchScaleStep;             // how quickly pitch indicator should traverse
var     float               PitchIndicatorLength;
var     float               YawIndicatorLength;
var     int                 StrikeThroughThickness;
var     string              AngleUnit;

var     int                 WidgetsPanelX;
var     int                 WidgetsPanelY;
var     int                 WidgetsPanelEntryHeight;

var     int                 VisiblePitchSegmentsNumber;
var     int                 VisibleYawSegmentsNumber;

simulated static function DrawSpottingScopeOverlay(Canvas C)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight;

    if (default.SpottingScopeOverlay != none)
    {
        TextureSize = float(default.SpottingScopeOverlay.MaterialUSize());
        TilePixelWidth = TextureSize / 0.4 * 0.955;
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX);
        TileStartPosU = ((TextureSize - TilePixelWidth) / 2.0);
        TileStartPosV = ((TextureSize - TilePixelHeight) / 2.0);
        C.SetPos(0.0, 0.0);

        C.DrawTile(default.SpottingScopeOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
    }
}

simulated static function CreatePitchStrings()
{
    local int i;

    if (default.RangeTable.Length == 0 || default.RangeTable[0].PitchString != "")
    {
        return;
    }

    for (i = 0; i < default.RangeTable.Length; ++i)
    {
        default.RangeTable[i].PitchString = GetPitchString(default.RangeTable[i].Pitch);
    }
}

simulated static function string GetPitchString(float Pitch)
{
    return class'UFloat'.static.Format(Pitch, default.PitchDecimals);
}

simulated static function DrawRangeTable(Canvas C, float ActiveLowerBoundPitch, float ActiveUpperBoundPitch)
{
    local int i;
    local float X, Y;
    local float XL, YL;
    local float TableHeight;
    const FirstColumn = 0;
    const SecondColumn = 45;

    if (default.RangeTable.Length == 0)
    {
        return;
    }

    CreatePitchStrings();

    C.Font = C.TinyFont;
    C.TextSize("A", XL, YL);
    TableHeight = (default.RangeTable.Length + 3) * YL;     // plus 3 because of table header and to have pretty spacing

    Y = (C.SizeY - TableHeight) / 2;
    X = C.SizeX * 0.85;

    // draw table rows
    for (i = 0; i < default.RangeTable.Length; ++i)
    {
        Y += YL;

        if(default.RangeTable[i].Pitch >= ActiveLowerBoundPitch && default.RangeTable[i].Pitch <= ActiveUpperBoundPitch)
        {
            C.SetDrawColor(0, 128, 64, 255);
        }
        else
        {
            C.SetDrawColor(0, 80, 32, 255);
        }

        C.SetPos(X + FirstColumn, Y);
        C.DrawText(string(default.RangeTable[i].Range) $ "m");
        C.SetPos(X + SecondColumn, Y);
        C.SetDrawColor(255, 255, 255, 255);
        C.DrawText("| " $ default.RangeTable[i].PitchString $ default.AngleUnit);
    }
}

// A helper function to draw a single widget on the left panel in spotting scope view
simulated static function DrawTargetWidget(Canvas C, float X, float Y, STargetInfo TargetInfo, float CurrentYaw)
{
    local string CorrectionString;
    local int Deflection;

    CurrentYaw = int(class'UMath'.static.Floor(CurrentYaw, default.YawScaleStep));

    C.SetDrawColor(0, 255, 128, 255);

    if (class<DHMapMarker_FireSupport>(TargetInfo.Type) != none)
    {
        C.CurX = X;
        C.CurY = Y;
        C.DrawText("Squad:" @ TargetInfo.SquadName @ "(" $ class<DHMapMarker_FireSupport>(TargetInfo.Type).default.TypeName $ ")");
    }
    else if (class<DHMapMarker_Ruler>(TargetInfo.Type) != none)
    {
        C.CurX = X;
        C.CurY = Y;
        C.DrawText("Your marker");
    }
    else
    {
        Log("This code shouldn't be reached :(");
    }

    C.SetDrawColor(255, 255, 255, 255);
    C.CurY = Y + 10;
    C.CurX = X;
    C.DrawText("Distance:" @ (TargetInfo.Distance / 5) * 5 $ "m");
    C.CurY = Y + 20;
    C.CurX = X;

    Deflection = TargetInfo.YawCorrection * default.YawScaleStep + CurrentYaw;

    if (Deflection > 0)
    {
        CorrectionString = Deflection $ "mils left";
    }
    else if (Deflection == 0)
    {
        CorrectionString = "0mils";
    }
    else
    {
        CorrectionString = -Deflection $ "mils right";
    }

    C.DrawText("Correction:" @ CorrectionString);
    C.CurX = X - 40;
    C.CurY = Y;
    C.SetDrawColor(TargetInfo.Type.default.IconColor.R, TargetInfo.Type.default.IconColor.G, TargetInfo.Type.default.IconColor.B, TargetInfo.Type.default.IconColor.A);
    C.DrawTile(TargetInfo.Type.default.IconMaterial, 32.0, 32.0, 0.0, 0.0, TargetInfo.Type.default.IconMaterial.MaterialUSize(), TargetInfo.Type.default.IconMaterial.MaterialVSize());
}

simulated static function DrawYaw(Canvas C, float CurrentYaw, float GunYawMin, float GunYawMax, array<STargetInfo> Targets)
{
    local float X, Y, YawUpperBound, YawLowerBound, SegmentCount, IndicatorStep, Shade;
    local int i, Yaw, Quotient, Index;
    local string Label;
    local color Color;

    X = C.SizeX * 0.5 - default.YawIndicatorLength * 0.5;
    Y = C.SizeY * 0.93;

    //CurrentYaw = class'DHUnits'.static.UnrealToMilliradians(GetGunYaw());
    CurrentYaw = int(class'UMath'.static.Floor(CurrentYaw, default.YawScaleStep));
    YawLowerBound = CurrentYaw - default.YawScaleStep * default.VisibleYawSegmentsNumber/2;
    YawUpperBound = CurrentYaw + default.YawScaleStep * default.VisibleYawSegmentsNumber/2;
    SegmentCount = (YawUpperBound - YawLowerBound) / default.YawScaleStep;
    IndicatorStep = default.YawIndicatorLength / default.VisibleYawSegmentsNumber;

    C.Font = C.TinyFont;

    // Draw a long horizontal bar that imitates edge of the indicator
    C.CurX = X;
    C.CurY = Y;
    C.DrawHorizontal(Y, default.YawIndicatorLength);

    // Draw target widgets & target ticks
    for (i = 0; i < Targets.Length; ++i)
    {
        // Always draw a target widget on the left panel
        DrawTargetWidget(C, default.WidgetsPanelX, default.WidgetsPanelY + default.WidgetsPanelEntryHeight * i, Targets[i], CurrentYaw);

        // Which tick on the dial does this target correspond to
        Index = default.VisibleYawSegmentsNumber/2 - Targets[i].YawCorrection - int(CurrentYaw/default.YawScaleStep);

        // Draw a tick on the yaw dial only if the target is within bounds of the yaw indicator
        if (Index < default.VisibleYawSegmentsNumber && Index >= 0)
        {
            C.CurY = Y + 5.0;
            C.CurX = X;

            Shade = class'UInterp'.static.Mimi((Index) / default.VisibleYawSegmentsNumber);

            Color = Targets[i].Type.default.IconColor;
            Color.R = Max(1, int(Color.R) * Shade);
            Color.G = Max(1, int(Color.G) * Shade);
            Color.B = Max(1, int(Color.B) * Shade);
            C.SetDrawColor(Color.R, Color.G, Color.B, 255);

            // Draw a target tick on the yaw indicator
            C.DrawVertical(X + Index * IndicatorStep, 5.0);
        }
    }

    // Start drawing scale ticks
    C.CurY = Y - 5.0;
    for (Yaw = YawLowerBound; Yaw <= YawUpperBound; Yaw += default.YawScaleStep)
    {
        // Calculate index of the tick in the indicator reference frame
        Index = (Yaw - YawLowerBound) / default.YawScaleStep;

        // Calculate color of the current indicator tick
        Shade = Max(1, 255 * class'UInterp'.static.Mimi(float(Index) / default.VisibleYawSegmentsNumber));

        // Calculate index of the current readout value on the mortar yaw span
        Quotient = int(class'UMath'.static.FlooredDivision(Yaw, default.YawScaleStep));

        // Changing alpha chanel works fine until the value gets lower than ~127 - from this point
        // text labels completly disappear. I propose to change the color instead of alpha channel
        // because the background is black anyway. - mimi~
        C.SetDrawColor(Shade, Shade, Shade, 255);

        C.CurY = Y - 5.0;
        // 3 is a rough factor to compensate X position of the label with respect to number of letters
        C.CurX = X + Index * default.YawIndicatorLength / SegmentCount - Len(Label) * 3;

        if (Quotient % 10 == 0)
        {
            Label = string(int(class'UMath'.static.Floor(Yaw, default.YawScaleStep)));

            // Draw long vertical tick & label it
            C.DrawVertical(X + (Index * IndicatorStep), -50.0);
            C.CurY = Y - 70.0;
            C.DrawText(Label);
        }
        else if (Quotient % 5 == 0)
        {
            Label = string(int(class'UMath'.static.Floor(Yaw, default.YawScaleStep)));

            // Draw middle-sized vertical tick & label it
            C.DrawVertical(X + (Index * IndicatorStep), -30.0);
            C.CurY = Y - 50.0;
            C.DrawText(Label);
        }
        else
        {
            // Smallest granularity - draw short vertical tick (no label)
            C.DrawVertical(X + (Index * IndicatorStep), -20.0);
        }

        // Draw a strike-through if this segment is beyond the lower or upper limits.
        C.CurY = Y - 20;

        if (Yaw < int(class'UMath'.static.Floor(GunYawMin, default.YawScaleStep)))
        {
            C.CurX = X + Index * default.YawIndicatorLength / SegmentCount;
            C.DrawRect(Texture'WhiteSquareTexture', IndicatorStep, default.StrikeThroughThickness);
        }

        if (Yaw > int(class'UMath'.static.Floor(GunYawMax, default.YawScaleStep)))
        {
            C.CurX = X + Index * default.YawIndicatorLength / SegmentCount;
            C.DrawRect(Texture'WhiteSquareTexture', -IndicatorStep, default.StrikeThroughThickness);
        }
    }

    // Draw current value indicator (middle tick)
    C.SetDrawColor(255, 255, 255, 255);
    C.CurY = Y + 15.0;
    C.DrawVertical(X + (default.YawIndicatorLength / 2), 20.0);
}

simulated static function float GetPitchLowerBound(float CurrentPitch)
{
    return CurrentPitch - default.PitchScaleStep * default.VisiblePitchSegmentsNumber / 2;
}

simulated static function float  GetPitchUpperBound(float CurrentPitch)
{
    return CurrentPitch + default.PitchScaleStep * default.VisiblePitchSegmentsNumber / 2;
}

simulated static function DrawPitch(Canvas C, float CurrentPitch, float GunPitchMin, float GunPitchMax, optional float GunPitchOffset)
{
    local float Pitch, X, Y, PitchUpperBound, PitchLowerBound, SegmentCount, IndicatorStep;
    local int Shade, Quotient, t;
    local string Label;

    X = C.SizeX * 0.25;
    Y = C.SizeY * 0.5 - default.PitchIndicatorLength * 0.5;

    CurrentPitch += GunPitchOffset;

    CurrentPitch = class'UMath'.static.Floor(CurrentPitch, default.PitchScaleStep);
    PitchLowerBound = GetPitchLowerBound(CurrentPitch);
    PitchUpperBound = GetPitchUpperBound(CurrentPitch);
    SegmentCount = (PitchUpperBound - PitchLowerBound) / default.PitchScaleStep;
    IndicatorStep = default.PitchIndicatorLength / default.VisiblePitchSegmentsNumber;

    C.Font = C.TinyFont;

    // Start drawing scale ticks
    for (Pitch = PitchLowerBound; Pitch <= PitchUpperBound; Pitch += default.PitchScaleStep)
    {
        // Calculate index of the tick in the indicator reference frame
        t = default.VisiblePitchSegmentsNumber - (Pitch - PitchLowerBound) / default.PitchScaleStep;

        // Calculate color of the current indicator tick
        Shade = Max(1, 255 * class'UInterp'.static.Mimi(float(t) / default.VisiblePitchSegmentsNumber));

        // Calculate index of the current readout value on the mortar yaw span
        Quotient = class'UMath'.static.FlooredDivision(Pitch, default.PitchScaleStep);

        // Changing alpha chanel works fine until the value gets lower than ~127 - from this point
        // text labels completly disappear. I propose to change the color instead of alpha channel
        // because the background is black anyway. - mimi~
        C.SetDrawColor(Shade, Shade, Shade, 255);

        C.CurX = X - 5.0;
        C.CurY = Y + t * default.PitchIndicatorLength / SegmentCount;

        if (Quotient % 10 == 0)
        {
            Label = GetPitchString(Pitch);

            // Draw long vertical tick & label it
            C.DrawHorizontal(Y + (t * IndicatorStep), -50.0);

            // 3 is a rough factor to compensate X position of the label with respect to number of letters
            C.CurX = X - 60.0 - Len(Label) * 6;

            // Readjust label height so it is on the same level as the tick
            C.CurY = C.CurY - 5;

            C.DrawText(Label);
        }
        else if (Quotient % 5 == 0)
        {
            Label = GetPitchString(Pitch);

            // Draw middle-sized vertical tick & label it
            C.DrawHorizontal(Y + (t * IndicatorStep), -30.0);

            // 3 is a rough factor to compensate X position of the label with respect to number of letters
            C.CurX = X - 40.0 - Len(Label) * 6;

            // Readjust label height so it is on the same level as the tick
            C.CurY = C.CurY - 5;

            C.DrawText(Label);
        }
        else
        {
            // Smallest granularity - draw short vertical tick (no label)
            C.DrawHorizontal(Y + (t * IndicatorStep), -20.0);
        }

        // Draw a strike-through if this segment is below the lower limit.
        C.CurX = X - 20;

        if (Pitch < int(class'UMath'.static.Floor(GunPitchMin + GunPitchOffset, default.PitchScaleStep)))
        {
            C.CurY = Y + t * default.PitchIndicatorLength / SegmentCount;
            C.DrawRect(Texture'WhiteSquareTexture', default.StrikeThroughThickness, -IndicatorStep);
        }

        // Draw a strike-through if this segment is above the upper limit.
        if (Pitch > int(class'UMath'.static.Floor(GunPitchMax + GunPitchOffset, default.PitchScaleStep)))
        {
            C.CurY = Y + t * default.PitchIndicatorLength / SegmentCount;
            C.DrawRect(Texture'WhiteSquareTexture', default.StrikeThroughThickness, IndicatorStep);
        }
    }

    // Draw a long horizontal bar that imitates edge of the indicator
    C.SetDrawColor(255, 255, 255, 255);
    C.CurY = Y;
    C.DrawVertical(X, default.PitchIndicatorLength);

    // Draw current value indicator (middle tick)
    C.SetDrawColor(255, 255, 255, 255);
    C.CurX = X + 15.0;
    C.DrawHorizontal(Y + (default.PitchIndicatorLength / 2), 20.0);
}

defaultproperties
{
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.German.German_sight_background'
    YawScaleStep=1.0
    PitchScaleStep=1.0

    PitchIndicatorLength=300.0
    YawIndicatorLength=300.0
    StrikeThroughThickness=10
    AngleUnit="°"

    WidgetsPanelX=50
    WidgetsPanelY=30
    WidgetsPanelEntryHeight=60

    VisiblePitchSegmentsNumber = 40
    VisibleYawSegmentsNumber = 40
}
