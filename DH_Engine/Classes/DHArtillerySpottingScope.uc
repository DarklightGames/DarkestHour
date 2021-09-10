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
};
var array<SRangeTableRecord>    RangeTable;

var int PitchDecimalsTable;
var int PitchDecimalsDial;

struct STargetInfo
{
    var int                              Distance;       // distance between the player and the target
    var int                              YawCorrection;  // how many ticks on the dial is the target deflected from current aiming direction
    var string                           SquadName;      // name of the squad that requests fire support
    var DHGameReplicationInfo.MapMarker  Marker;           // Fire_Support or Ruler
};

enum EShapePrimitive
{
    ShortTick,
    MediumLengthTick,
    LongTick
};
var EShapePrimitive                      MiddleTick;
var EShapePrimitive                      CurrentValueIndicator;

struct SSegmentTick
{
    var EShapePrimitive                   Shape;
    var bool                              bShouldDrawLabel;
};

var array<SSegmentTick>                   SegmentSchema;
var int                                   NumberOfYawSegments;
var int                                   NumberOfPitchSegments;

var     localized string    RangeString;
var     localized string    ElevationString;
var     texture             SpottingScopeOverlay;       // periscope overlay texture

var     float               YawScaleStep;               // how quickly yaw indicator should traverse
var     float               PitchScaleStep;             // how quickly pitch indicator should traverse
var     float               PitchIndicatorLength;
var     float               YawIndicatorLength;
var     int                 StrikeThroughThickness;

var     string              AngleUnit;
var     string              DistanceUnit;

var     int                 WidgetsPanelX;
var     int                 WidgetsPanelY;
var     int                 WidgetsPanelEntryHeight;

var     float               SmallSizeTickLength;
var     float               MiddleSizeTickLength;
var     float               LargeSizeTickLength;
var     float               LabelOffset;
var     float               IndicatorMiddleTickOffset;
var     int                 TargetTickLength;

var     bool                bIsTableInitialized;
var     DHDataTable         RenderTable;

var     localized string    RangeHeaderString;
var     localized string    PitchHeaderString;

var     color               Green;
var     color               White;
var     color               Orange;

var     int                 TargetWidgetFirstLineOffset;
var     int                 TargetWidgetSecondLineOffset;
var     int                 TargetWidgetThirdLineOffset;
var     int                 TargetWidgetFourthLineOffset;

simulated static function CreateRenderTable(Canvas C)
{
    local int i;

    if (default.RenderTable != none)
    {
        return;
    }

    default.RenderTable = new class'DHDataTable';

    default.RenderTable.Font = C.MedFont;
    default.RenderTable.Columns.Insert(0, 2);

    default.RenderTable.Columns[0].Header = default.RangeHeaderString @  "(" $ default.DistanceUnit $ ")";
    default.RenderTable.Columns[0].TextColor = class'UColor'.default.White;
    default.RenderTable.Columns[0].Width = 80;
    default.RenderTable.Columns[0].HeaderJustification = 2;
    default.RenderTable.Columns[0].RowJustification = 2;
    default.RenderTable.Columns[1].Header = default.PitchHeaderString @ "(" $ default.AngleUnit $ ")";
    default.RenderTable.Columns[1].TextColor = class'UColor'.default.White;
    default.RenderTable.Columns[1].Width = 80;
    default.RenderTable.Columns[1].HeaderJustification = 0;
    default.RenderTable.Columns[1].RowJustification = 0;

    default.RenderTable.Rows.Insert(0, default.RangeTable.Length);

    for (i = 0; i < default.RangeTable.Length; ++i)
    {
        default.RenderTable.Rows[i].Columns.Insert(0, 2);
        default.RenderTable.Rows[i].Columns[0].Value = string(default.RangeTable[i].Range);
        default.RenderTable.Rows[i].Columns[0].TextColor = class'UColor'.default.Green;
        default.RenderTable.Rows[i].Columns[1].Value = class'UFloat'.static.Format(default.RangeTable[i].Pitch, default.PitchDecimalsTable);
        default.RenderTable.Rows[i].Columns[1].TextColor = class'UColor'.default.White;
    }
}

simulated static function DrawSpottingScopeOverlay(Canvas C)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight;

    if (default.SpottingScopeOverlay != none)
    {
        TextureSize = float(default.SpottingScopeOverlay.MaterialUSize());
        TilePixelWidth = TextureSize / 0.4 * 0.955;
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX);
        TileStartPosU = ((TextureSize - TilePixelWidth) * 0.5);
        TileStartPosV = ((TextureSize - TilePixelHeight) * 0.5);
        C.SetPos(0.0, 0.0);

        C.DrawColor = class'UColor'.default.White;
        C.DrawTile(default.SpottingScopeOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
    }
}

simulated static function UpdateTable(Canvas C, float ActiveLowerBoundPitch, float ActiveUpperBoundPitch)
{
    if (!default.bIsTableInitialized)
    {
        CreateRenderTable(C);
        default.bIsTableInitialized = true;
    }

    // TODO: update colors of table values
}

simulated static function DrawRangeTable(Canvas C, float ActiveLowerBoundPitch, float ActiveUpperBoundPitch)
{
    local float X, Y;

    UpdateTable(C, ActiveLowerBoundPitch, ActiveUpperBoundPitch);

    Y = (C.ClipY - default.RenderTable.GetHeight(C)) * 0.5;
    X = (C.ClipX * 0.85) - (default.RenderTable.GetWidth() * 0.5);

    default.RenderTable.DrawTable(C, X, Y);
}

// A helper function to draw a single widget on the left panel in spotting scope view
simulated static function DrawTargetWidget(DHPlayerReplicationInfo PRI, Canvas C, float X, float Y, STargetInfo TargetInfo, float CurrentYaw)
{
    local string CorrectionString;
    local int Deflection;
    local color IconColor;
    local float XL, YL;

    CurrentYaw = int(class'UMath'.static.Floor(CurrentYaw, default.YawScaleStep));

    C.SetDrawColor(default.White.R, default.White.G, default.White.B, default.White.A);
    C.Font = C.MedFont;

    if (class<DHMapMarker_FireSupport>(TargetInfo.Marker.MapMarkerClass) != none)
    {
        // Draw first line (artillery support)
        C.CurX = X - 40;
        C.CurY = Y + default.TargetWidgetFirstLineOffset;
        C.DrawText("SELECTED TARGET");

        // Draw second line
        C.CurX = X;
        C.CurY = Y + default.TargetWidgetSecondLineOffset;
        C.DrawText("Squad: ");
        C.TextSize("Squad: ", XL, YL);
        C.CurX = X + XL;
        C.CurY = Y + default.TargetWidgetSecondLineOffset;
        C.SetDrawColor(default.Green.R, default.Green.G, default.Green.B, default.Green.A);
        C.DrawText(TargetInfo.SquadName @ "(" $ class<DHMapMarker_FireSupport>(TargetInfo.Marker.MapMarkerClass).default.TypeName $ ")");
        C.SetDrawColor(default.White.R, default.White.G, default.White.B, default.White.A);
    }
    else if (class<DHMapMarker_Ruler>(TargetInfo.Marker.MapMarkerClass) != none)
    {
        // Draw first line (ruler)
        C.Font = C.MedFont;
        C.CurX = X - 40;
        C.CurY = Y + default.TargetWidgetFirstLineOffset;
        C.DrawText("MEASUREMENT TOOL:");

        // Draw second line
        C.CurX = X;
        C.CurY = Y + default.TargetWidgetSecondLineOffset;
        C.DrawText("Ruler marker");
    }
    else

    {
        Warn("This code shouldn't be reached :(");
    }

    // Draw third line
    C.CurX = X;
    C.CurY = Y + default.TargetWidgetThirdLineOffset;
    C.SetDrawColor(default.White.R, default.White.G, default.White.B, default.White.A);
    C.DrawText("Distance: ");
    C.TextSize("Distance: ", XL, YL);
    C.CurX = X + XL;
    C.CurY = Y + default.TargetWidgetThirdLineOffset;
    C.SetDrawColor(default.Green.R, default.Green.G, default.Green.B, default.Green.A);
    C.DrawText("" $ (TargetInfo.Distance / 5) * 5 $ "m");

    // Draw fourth line
    C.SetDrawColor(default.White.R, default.White.G, default.White.B, default.White.A);
    C.CurX = X;
    C.CurY = Y + default.TargetWidgetFourthLineOffset;
    C.DrawText("Correction: ");
    C.TextSize("Correction: ", XL, YL);

    Deflection = TargetInfo.YawCorrection * default.YawScaleStep + CurrentYaw;
    if (Deflection > 0)
    {
        CorrectionString = Deflection $ "mils left";
        C.SetDrawColor(default.Orange.R, default.Orange.G, default.Orange.B, default.Orange.A);
    }
    else if (Deflection == 0)
    {
        CorrectionString = "0mils";
        C.SetDrawColor(default.Green.R, default.Green.G, default.Green.B, default.Green.A);
    }
    else
    {
        CorrectionString = -Deflection $ "mils right";
        C.SetDrawColor(default.Orange.R, default.Orange.G, default.Orange.B, default.Orange.A);
    }
    C.CurX = X + XL;
    C.CurY = Y + default.TargetWidgetFourthLineOffset;
    C.DrawText(CorrectionString);

    // Draw icon on the left of the text but below the first line
    C.CurX = X - 40;
    C.CurY = Y + default.TargetWidgetFourthLineOffset/2;
    IconColor = TargetInfo.Marker.MapMarkerClass.static.GetIconColor(PRI, TargetInfo.Marker);
    C.SetDrawColor(IconColor.R, IconColor.G, IconColor.B, IconColor.A);
    C.DrawTile(
      TargetInfo.Marker.MapMarkerClass.default.IconMaterial,
      32.0,
      32.0,
      TargetInfo.Marker.MapMarkerClass.default.IconCoords.X1,
      TargetInfo.Marker.MapMarkerClass.default.IconCoords.Y1,
      TargetInfo.Marker.MapMarkerClass.default.IconCoords.X2,
      TargetInfo.Marker.MapMarkerClass.default.IconCoords.Y2);

    C.Font = C.TinyFont;
}

simulated static function DrawYaw(DHPlayerReplicationInfo PRI, Canvas C, float CurrentYaw, float GunYawMin, float GunYawMax, array<STargetInfo> Targets)
{
    local float IndicatorTopLeftCornerX, IndicatorTopLeftCornerY, YawUpperBound, YawLowerBound, IndicatorStep, Shade, TextWidth, TextHeight;
    local int i, Yaw, Quotient, Index, SegmentSchemaIndex, VisibleYawSegmentsNumber;
    local int TargetTickCountLeft, TargetTickCountRight;
    local string Label;
    local color Color;
    local array<int> TickBuckets;
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;
    local array<DHGameReplicationInfo.MapMarker> ArtilleryMarkers;

    if(PRI == none)
    {
        return;
    }

    IndicatorTopLeftCornerX = C.SizeX * 0.5 - default.YawIndicatorLength * 0.5;
    IndicatorTopLeftCornerY = C.SizeY * 0.95;

    VisibleYawSegmentsNumber = default.NumberOfYawSegments * default.SegmentSchema.Length;
    CurrentYaw = int(class'UMath'.static.Floor(CurrentYaw, default.YawScaleStep));
    YawLowerBound = CurrentYaw - default.YawScaleStep * VisibleYawSegmentsNumber * 0.5;
    YawUpperBound = CurrentYaw + default.YawScaleStep * VisibleYawSegmentsNumber * 0.5;
    IndicatorStep = default.YawIndicatorLength / VisibleYawSegmentsNumber;

    C.Font = C.TinyFont;

    // Draw a long horizontal bar that imitates edge of the indicator
    C.CurX = IndicatorTopLeftCornerX;
    C.CurY = IndicatorTopLeftCornerY;
    C.DrawHorizontal(IndicatorTopLeftCornerY, default.YawIndicatorLength);

    // Prepare buckets for ticks so ticks don't get drawn on top of each other
    TickBuckets.Insert(0, VisibleYawSegmentsNumber);

    // Display hints about selected artillery target
    PC = DHPlayer(PRI.Owner);
    
    if(PC != none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
        GRI.GetArtilleryMapMarkers(PC, ArtilleryMarkers, PC.GetTeamNum());
        if(GRI != none)
        {
            if(ArtilleryMarkers.Length > 0)
            {
                C.CurX = default.WidgetsPanelX - 40;
                C.CurY = default.WidgetsPanelY - 40;
                C.SetDrawColor(default.Green.R, default.Green.G, default.Green.B, default.Green.A);
                Label = class'ROTeamGame'.static.ParseLoadingHintNoColor("Toggle artillery target using [%TOGGLESELECTEDARTILLERYTARGET%]. Number of fire support requests:" @ ArtilleryMarkers.Length $ ".", PC);
                C.DrawText(Label);
                C.CurX = default.WidgetsPanelX - 40;
                C.CurY = default.WidgetsPanelY - 20;
                C.SetDrawColor(default.Green.R, default.Green.G, default.Green.B, default.Green.A);
                Label = "You cannot use your own markers.";
                C.DrawText(Label);
            }
        }
        else
        {
            Warn("DHGameReplicationInfo is null, hints for artillery operators won't work.");
        }
    }
    else
    {
        Warn("DHPlayer is null, hints for artillery operators won't work.");
    }

    // Draw target widgets & target ticks
    for (i = 0; i < Targets.Length; ++i)
    {
        // Always draw a target widget on the left panel
        DrawTargetWidget(PRI, C, default.WidgetsPanelX, default.WidgetsPanelY + default.WidgetsPanelEntryHeight * i, Targets[i], CurrentYaw);

        // Which tick on the dial does this target correspond to
        Index = (VisibleYawSegmentsNumber * 0.5) - Targets[i].YawCorrection - int(CurrentYaw / default.YawScaleStep);

        Shade = class'UInterp'.static.Mimi(FClamp(Index / VisibleYawSegmentsNumber, 0.25, 0.75));

        Color = Targets[i].Marker.MapMarkerClass.static.GetIconColor(PRI, Targets[i].Marker);
        Color.R = Max(1, int(Color.R) * Shade);
        Color.G = Max(1, int(Color.G) * Shade);
        Color.B = Max(1, int(Color.B) * Shade);
        C.SetDrawColor(Color.R, Color.G, Color.B, 255);

        // Draw a tick on the yaw dial only if the target is within bounds of the yaw indicator
        if (Index < VisibleYawSegmentsNumber && Index >= 0)
        {
            C.CurY = IndicatorTopLeftCornerY + 5.0 + 5 * TickBuckets[Index];
            C.CurX = IndicatorTopLeftCornerX;
            TickBuckets[Index] = TickBuckets[Index] + 1;

            // Draw a target tick on the yaw indicator

            C.DrawVertical(IndicatorTopLeftCornerX + Index * IndicatorStep, default.TargetTickLength);
        }
        else
        {
            // Draw stacking horizontal target markers that are off of the dial
            if (Index < 0)
            {
                // Left side
                C.SetPos(IndicatorTopLeftCornerX - 10, IndicatorTopLeftCornerY);
                C.DrawHorizontal(IndicatorTopLeftCornerY + TargetTickCountLeft * 4, default.TargetTickLength);

                ++TargetTickCountLeft;
            }
            else
            {
                // Right side
                C.SetPos(IndicatorTopLeftCornerX + default.YawIndicatorLength + 2, IndicatorTopLeftCornerY);
                C.DrawHorizontal(IndicatorTopLeftCornerY + TargetTickCountRight * 4, default.TargetTickLength);

                ++TargetTickCountRight;
            }
        }
    }

    // Start drawing scale ticks
    C.CurY = IndicatorTopLeftCornerY - 5.0;
    for (Yaw = YawLowerBound; Yaw <= YawUpperBound; Yaw += default.YawScaleStep)
    {
        // Calculate index of the tick in the indicator reference frame
        Index = (Yaw - YawLowerBound) / default.YawScaleStep;

        // Calculate color of the current indicator tick
        Shade = Max(1, 255 * class'UInterp'.static.Mimi(float(Index) / VisibleYawSegmentsNumber));

        // Calculate index of the current readout value on the mortar yaw span
        Quotient = int(class'UMath'.static.FlooredDivision(Yaw, default.YawScaleStep));

        // Changing alpha chanel works fine until the value gets lower than ~127 - from this point
        // text labels completly disappear. I propose to change the color instead of alpha channel
        // because the background is black anyway. - mimi~
        C.SetDrawColor(Shade, Shade, Shade, 255);

        Label = string(int(class'UMath'.static.Floor(Yaw, default.YawScaleStep)));

        // Get the label's length
        C.StrLen(Label, TextWidth, TextHeight);

        C.CurY = IndicatorTopLeftCornerY - 5.0;
        C.CurX = IndicatorTopLeftCornerX + Index * default.YawIndicatorLength / VisibleYawSegmentsNumber;

        SegmentSchemaIndex = abs(Quotient) % default.SegmentSchema.Length;
        switch (default.SegmentSchema[SegmentSchemaIndex].Shape)
        {
            case ShortTick:
                C.DrawVertical(IndicatorTopLeftCornerX + (Index * IndicatorStep), -default.SmallSizeTickLength);
                break;
            case MediumLengthTick:
                C.DrawVertical(IndicatorTopLeftCornerX + (Index * IndicatorStep), -default.MiddleSizeTickLength);
                break;
            case LongTick:
                C.DrawVertical(IndicatorTopLeftCornerX + (Index * IndicatorStep), -default.LargeSizeTickLength);
                break;
        }
        if (default.SegmentSchema[SegmentSchemaIndex].bShouldDrawLabel)
        {
            switch (default.SegmentSchema[SegmentSchemaIndex].Shape)
            {
                case ShortTick:
                    C.CurY = C.CurY - default.SmallSizeTickLength - TextHeight - default.LabelOffset;
                    break;
                case MediumLengthTick:
                    C.CurY = C.CurY - default.MiddleSizeTickLength - TextHeight - default.LabelOffset;
                    break;
                case LongTick:
                    C.CurY = C.CurY - default.LargeSizeTickLength - TextHeight - default.LabelOffset;
                    break;
            }
            C.CurX = C.CurX - TextWidth * 0.5 + 2;
            C.DrawText(Label);
        }

        // Draw a strike-through if this segment is beyond the lower or upper limits.
        C.CurY = IndicatorTopLeftCornerY - default.SmallSizeTickLength;

        if (Yaw < int(class'UMath'.static.Floor(GunYawMin, default.YawScaleStep)))
        {
            C.CurX = IndicatorTopLeftCornerX + Index * default.YawIndicatorLength / VisibleYawSegmentsNumber;
            C.DrawRect(Texture'WhiteSquareTexture', IndicatorStep, default.StrikeThroughThickness);
        }

        if (Yaw > int(class'UMath'.static.Floor(GunYawMax, default.YawScaleStep)))
        {
            C.CurX = IndicatorTopLeftCornerX + Index * default.YawIndicatorLength / VisibleYawSegmentsNumber;
            C.DrawRect(Texture'WhiteSquareTexture', -IndicatorStep, default.StrikeThroughThickness);
        }
    }
    // Draw current value indicator (middle tick)
    C.SetDrawColor(255, 255, 255, 255);
    C.CurY = IndicatorTopLeftCornerY + default.IndicatorMiddleTickOffset;
    C.DrawVertical(IndicatorTopLeftCornerX + (default.YawIndicatorLength * 0.5), default.SmallSizeTickLength);
}

simulated static function float GetPitchLowerBound(float CurrentPitch)
{
    return CurrentPitch - default.PitchScaleStep * default.NumberOfPitchSegments * default.SegmentSchema.Length * 0.5;
}

simulated static function float  GetPitchUpperBound(float CurrentPitch)
{
    return CurrentPitch + default.PitchScaleStep * default.NumberOfPitchSegments * default.SegmentSchema.Length * 0.5;
}

simulated static function DrawPitch(Canvas C, float CurrentPitch, float GunPitchMin, float GunPitchMax, optional float GunPitchOffset)
{
    local float Pitch, IndicatorTopLeftCornerX, IndicatorTopLeftCornerY, PitchUpperBound, PitchLowerBound, IndicatorStep, TextWidth, TextHeight;
    local int Shade, Quotient, Index, VisiblePitchSegmentsNumber, SegmentSchemaIndex;
    local string Label;

    IndicatorTopLeftCornerX = C.SizeX * 0.25;
    IndicatorTopLeftCornerY = C.SizeY * 0.5 - default.PitchIndicatorLength * 0.5;

    CurrentPitch += GunPitchOffset;
    VisiblePitchSegmentsNumber = default.NumberOfPitchSegments * default.SegmentSchema.Length;

    CurrentPitch = class'UMath'.static.Floor(CurrentPitch, default.PitchScaleStep);
    PitchLowerBound = GetPitchLowerBound(CurrentPitch);
    PitchUpperBound = GetPitchUpperBound(CurrentPitch);
    IndicatorStep = default.PitchIndicatorLength / VisiblePitchSegmentsNumber;

    C.Font = C.TinyFont;

    // Start drawing scale ticks
    for (Pitch = PitchLowerBound; Pitch <= PitchUpperBound; Pitch += default.PitchScaleStep)
    {
        // Calculate index of the tick in the indicator reference frame
        Index = VisiblePitchSegmentsNumber - (Pitch - PitchLowerBound) / default.PitchScaleStep;

        // Calculate color of the current indicator tick
        Shade = Max(1, 255 * class'UInterp'.static.Mimi(float(Index) / VisiblePitchSegmentsNumber));

        // Calculate index of the current readout value on the mortar pitch span
        Quotient = class'UMath'.static.FlooredDivision(Pitch, default.PitchScaleStep);

        // Changing alpha chanel works fine until the value gets lower than ~127 - from this point
        // text labels completly disappear. I propose to change the color instead of alpha channel
        // because the background is black anyway. - mimi~
        C.SetDrawColor(Shade, Shade, Shade, 255);

        Label = class'UFloat'.static.Format(Pitch, default.PitchDecimalsDial);

        // Get the label's length
        C.StrLen(Label, TextWidth, TextHeight);

        C.CurX = IndicatorTopLeftCornerX - 5.0;
        C.CurY = IndicatorTopLeftCornerY + Index * default.PitchIndicatorLength / VisiblePitchSegmentsNumber;

        SegmentSchemaIndex = abs(Quotient) % default.SegmentSchema.Length;
        switch (default.SegmentSchema[SegmentSchemaIndex].Shape)
        {
            case ShortTick:
                C.DrawHorizontal(IndicatorTopLeftCornerY + (Index * IndicatorStep), -default.SmallSizeTickLength);
                break;
            case MediumLengthTick:
                C.DrawHorizontal(IndicatorTopLeftCornerY + (Index * IndicatorStep), -default.MiddleSizeTickLength);
                break;
            case LongTick:
                C.DrawHorizontal(IndicatorTopLeftCornerY + (Index * IndicatorStep), -default.LargeSizeTickLength);
                break;
        }
        if (default.SegmentSchema[SegmentSchemaIndex].bShouldDrawLabel)
        {
            switch (default.SegmentSchema[SegmentSchemaIndex].Shape)
            {
                case ShortTick:
                    C.CurX = C.CurX - default.SmallSizeTickLength - TextWidth - default.LabelOffset;
                    break;
                case MediumLengthTick:
                    C.CurX = C.CurX - default.MiddleSizeTickLength - TextWidth - default.LabelOffset;
                    break;
                case LongTick:
                    C.CurX = C.CurX - default.LargeSizeTickLength - TextWidth - default.LabelOffset;
                    break;
            }
            C.CurY = C.CurY - TextHeight * 0.5;
            C.DrawText(Label);
        }

        // Draw a strike-through if this segment is below the lower limit.
        C.CurX = IndicatorTopLeftCornerX - default.SmallSizeTickLength;

        if (Pitch < int(class'UMath'.static.Floor(GunPitchMin + GunPitchOffset, default.PitchScaleStep)))
        {
            C.CurY = IndicatorTopLeftCornerY + Index * default.PitchIndicatorLength / VisiblePitchSegmentsNumber;
            C.DrawRect(Texture'WhiteSquareTexture', default.StrikeThroughThickness, -IndicatorStep);
        }

        // Draw a strike-through if this segment is above the upper limit.
        if (Pitch > int(class'UMath'.static.Floor(GunPitchMax + GunPitchOffset, default.PitchScaleStep)))
        {
            C.CurY = IndicatorTopLeftCornerY + Index * default.PitchIndicatorLength / VisiblePitchSegmentsNumber;
            C.DrawRect(Texture'WhiteSquareTexture', default.StrikeThroughThickness, IndicatorStep);
        }
    }

    // Draw a long horizontal bar that imitates edge of the indicator
    C.SetDrawColor(255, 255, 255, 255);
    C.CurY = IndicatorTopLeftCornerY;
    C.DrawVertical(IndicatorTopLeftCornerX, default.PitchIndicatorLength);

    // Draw current value indicator (middle tick)
    C.SetDrawColor(255, 255, 255, 255);
    C.CurX = IndicatorTopLeftCornerX + default.IndicatorMiddleTickOffset;
    C.DrawHorizontal(IndicatorTopLeftCornerY + (default.PitchIndicatorLength * 0.5), default.SmallSizeTickLength);
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
    DistanceUnit="m"

    WidgetsPanelX=50
    WidgetsPanelY=100
    WidgetsPanelEntryHeight=80

    RangeHeaderString="Range"
    PitchHeaderString="Pitch"

    LargeSizeTickLength = 30.0
    MiddleSizeTickLength = 15.0
    SmallSizeTickLength = 10.0
    LabelOffset = 10.0
    IndicatorMiddleTickOffset = 20.0
    NumberOfYawSegments = 6;
    NumberOfPitchSegments = 6;
    TargetTickLength=3

    Green=(R=0,G=128,B=0,A=255)
    White=(R=255,G=255,B=255,A=255)
    Orange=(R=255,G=165,B=0,A=255)

    TargetWidgetFirstLineOffset=0
    TargetWidgetSecondLineOffset=20
    TargetWidgetThirdLineOffset=35
    TargetWidgetFourthLineOffset=50
}
