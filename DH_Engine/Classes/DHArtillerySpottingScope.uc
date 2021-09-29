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
    var int                              Timeout;           // time to expiry [s]
    var int                              MarkerIndex;       // index in the array of fire requests sorted by squad index
    var int                              MarkersTotal;      // how many on-map fire support requests are there
    var int                              Distance;          // distance between the player and the target
    var int                              YawCorrection;     // how many ticks on the dial is the target deflected from current aiming direction
    var string                           SquadName;         // name of the squad that requests fire support
    var DHGameReplicationInfo.MapMarker  Marker;            // Fire_Support or Ruler
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

var array<SSegmentTick>                   PitchSegmentSchema;
var array<SSegmentTick>                   YawSegmentSchema;
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

var     int                 WidgetsPanelTopLeftX;
var     int                 WidgetsPanelTopLeftY;
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
var     color               Red;

// Where does the curvature on the yaw dial start, 0 <= YawDialRoundingConstant <= 0.5
// Relative to the yaw dial's length
// Should be smaller (eg. 0.05) for dials with short traverse range and bigger otherwise (eg. 0.1)
var     float               YawDialRoundingConstant;

// Where does the curvature on the pitch dial start, 0 <= PitchDialRoundingConstant <= 0.5
// Relative to the pitch dial's length
// Should be smaller (eg. 0.05) for dials with short traverse range and bigger otherwise (eg. 0.1)
var     float               PitchDialRoundingConstant;

enum ETargetWidgetLineType
{
    TWLT_Header,
    TWLT_MarkerType,
    TWLT_ExpiryTime,
    TWLT_Distance,
    TWLT_Correction
};

struct STargetWidgetLayout
{
    var                       int LineHeight;     // [px]
    var                       int HeaderOffsetX;  // [px]
    var                       int IconOffsetX;    // [px]
    var                       int IconOffsetY;    // [px]
    var ETargetWidgetLineType LineConfig[5];      // add more lines?
};

var     STargetWidgetLayout TargetWidgetLayout;

var     string              TargetToggleHint;
var     string              SelectTargetHint;

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
simulated static function DrawTargetWidget(DHPlayer PC, DHPlayerReplicationInfo PRI, Canvas C, float X, float Y, STargetInfo TargetInfo, float CurrentYaw, int MinimumGunYaw, int MaximumGunYaw)
{
    local string Labels[2];
    local int Deflection;
    local color IconColor, LabelColors[2];
    local float XL, YL;
    local int LabelIndex, LineIndex, MaxLines, LineOffsetX, i;

    CurrentYaw = int(class'UMath'.static.Floor(CurrentYaw, default.YawScaleStep));

    C.SetDrawColor(default.White.R, default.White.G, default.White.B, default.White.A);
    C.Font = C.MedFont;

    MaxLines = arraycount(default.TargetWidgetLayout.LineConfig);

    while (i < MaxLines)
    {
        LabelColors[0] = default.White;
        Labels[0] = "";
        Labels[1] = "";
        LabelColors[0] = default.White;
        LabelColors[1] = default.White;
        LineOffsetX = 0;

        // Calculate what to draw
        switch (default.TargetWidgetLayout.LineConfig[i])
        {
            case TWLT_Header:
                switch (TargetInfo.Marker.MapMarkerClass.default.Type)
                {
                    case MT_OnMapArtilleryRequest:
                        Labels[0] = "SELECTED TARGET";

                        if (TargetInfo.MarkersTotal > 1)
                        {
                            Labels[1] = "[" $ TargetInfo.MarkerIndex $ " / " $ TargetInfo.MarkersTotal $ "]";
                            LabelColors[1] = default.Green;
                        }
                        break;
                    case MT_Measurement:
                        Labels[0] = "MEASUREMENT TOOL";
                        break;
                    case MT_Measurement:
                        break;
                }
                LineOffsetX = default.TargetWidgetLayout.HeaderOffsetX;
                break;
            case TWLT_MarkerType:
                switch (TargetInfo.Marker.MapMarkerClass.default.Type)
                {
                    case MT_OnMapArtilleryRequest:
                        Labels[0] = "Squad: ";
                        Labels[1] = TargetInfo.SquadName @ "-" @ TargetInfo.Marker.MapMarkerClass.default.MarkerName;
                        LabelColors[1] = default.Green;
                        break;
                    case MT_Measurement:
                        Labels[0] = "Ruler marker";
                        break;
                    default:
                        break;
                }
                break;
            case TWLT_ExpiryTime:
                if (TargetInfo.Timeout != -1)
                {
                    Labels[0] = class'TimeSpan'.static.ToString(TargetInfo.Timeout);

                    if (TargetInfo.Timeout > 10)
                    {
                        LabelColors[0] = default.Green;
                    }
                    else if (TargetInfo.Timeout > 0)
                    {
                        LabelColors[0] = default.Orange;
                    }
                    else
                    {
                        LabelColors[0] = default.Red;
                    }
                }
                LineOffsetX = default.TargetWidgetLayout.IconOffsetX;
                break;
            case TWLT_Correction:
                Deflection = TargetInfo.YawCorrection * default.YawScaleStep + CurrentYaw;
                Labels[0] = "Correction: ";

                if (Deflection > 0)
                {
                    Labels[1] = Deflection $ "mils left";

                    if (CurrentYaw - Deflection < MinimumGunYaw)
                    {
                        // the target is outside of the upper traverse limit
                        LabelColors[1] = default.Red;
                    }
                    else
                    {
                        // the target is within the traverse range
                        LabelColors[1] = default.Orange;
                    }
                }
                else if (Deflection == 0)
                {
                    Labels[1] = "0mils";
                    LabelColors[1] = default.Green;
                }
                else
                {
                    Labels[1] = -Deflection $ "mils right";

                    if (CurrentYaw - Deflection > MaximumGunYaw)
                    {
                        // the target is outside of the lower traverse limit
                        LabelColors[1] = default.Red;
                    }
                    else
                    {
                        // the target is within the traverse range
                        LabelColors[1] = default.Orange;
                    }
                }

                break;
            case TWLT_Distance:
                C.SetDrawColor(default.White.R, default.White.G, default.White.B, default.White.A);
                Labels[0] = "Distance: ";
                Labels[1] = TargetInfo.Marker.MapMarkerClass.static.GetDistanceString(PC, TargetInfo.Marker);
                LabelColors[1] = default.Green;
                break;
        }

        if (Labels[0] != "")
        {
            // Draw whatever there is to be drawn or skip the line
            XL = 0.0;

            for (LabelIndex = 0; LabelIndex < arraycount(Labels); ++LabelIndex)
            {
                if (Labels[LabelIndex] != "")
                {
                    C.CurX = X - LineOffsetX;
                    C.CurY = Y + LineIndex * default.TargetWidgetLayout.LineHeight;
                    C.SetDrawColor(LabelColors[LabelIndex].R, LabelColors[LabelIndex].G, LabelColors[LabelIndex].B, LabelColors[LabelIndex].A);
                    C.DrawText(Labels[LabelIndex]);
                    C.TextSize(Labels[LabelIndex], XL, YL);
                    LineOffsetX = LineOffsetX - XL;
                }
            }

            ++LineIndex;
        }

        ++i;
    }

    // Draw the widget icon on the left of the text but below the header
    C.CurX = X - default.TargetWidgetLayout.IconOffsetX;
    C.CurY = Y + default.TargetWidgetLayout.IconOffsetY;
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
}

simulated static function DrawTargets(DHPlayerReplicationInfo PRI, Canvas C, float CurrentYaw, float GunYawMin, float GunYawMax, array<STargetInfo> Targets)
{
    local int i;
    local DHPlayer PC;
    local DHGameReplicationInfo GRI;
    local float GunYawMaxTruncated, GunYawMinTruncated;
    local array<DHGameReplicationInfo.MapMarker> ArtilleryMarkers;
    local bool bSelectedMarkerNotAvailable;
    local string Label;

    PC = DHPlayer(PRI.Owner);
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (PC == none || GRI == none)
    {
        Log("OUT");

        return;
    }

    Log("DrawTargets" @ Targets.Length);

    GunYawMaxTruncated = class'UMath'.static.Floor(GunYawMax, default.YawScaleStep);
    GunYawMinTruncated = class'UMath'.static.Floor(GunYawMin, default.YawScaleStep);

    for (i = 0; i < Targets.Length; ++i)
    {
        DrawTargetWidget(PC, PRI, C, default.WidgetsPanelTopLeftX, default.WidgetsPanelTopLeftY + default.WidgetsPanelEntryHeight * i, Targets[i], CurrentYaw, GunYawMinTruncated, GunYawMaxTruncated);
    }

    GRI.GetGlobalArtilleryMapMarkers(PC, ArtilleryMarkers, PC.GetTeamNum());

    // check if the player has selected any marker
    bSelectedMarkerNotAvailable = PC.ArtillerySupportSquadIndex != 255 && ArtilleryMarkers.Length > 0;

    if (bSelectedMarkerNotAvailable)
    {
        // The player selected some marker
        // Let's check if that marker is still available
        for (i = 0; i < ArtilleryMarkers.Length; ++i)
        {
            if (ArtilleryMarkers[i].SquadIndex == PC.ArtillerySupportSquadIndex)
            {
                bSelectedMarkerNotAvailable = false;
                break;
            }
        }
    }

    if (ArtilleryMarkers.Length > 0 && (bSelectedMarkerNotAvailable || PC.ArtillerySupportSquadIndex == 255))
    {
        // The player hasn't chosen anything from the available requests
        Label = Repl(default.SelectTargetHint, "{ArtilleryMarkersLength}", ArtilleryMarkers.Length);
    }
    else if (!bSelectedMarkerNotAvailable && ArtilleryMarkers.Length > 1 && PC.ArtillerySupportSquadIndex != 255)
    {
        // The player has selected an avilable marker
        // but there are more to toggle between
        Label = Repl(default.TargetToggleHint, "{ArtilleryMarkersLength}", ArtilleryMarkers.Length);
    }

    Label = class'ROTeamGame'.static.ParseLoadingHintNoColor(Label, PC);

    C.CurX = default.WidgetsPanelTopLeftX - 40;
    C.CurY = default.WidgetsPanelTopLeftY - 30;
    C.SetDrawColor(default.Green.R, default.Green.G, default.Green.B, default.Green.A);
    C.DrawText(Label);
}

simulated static function DrawYaw(DHPlayerReplicationInfo PRI, Canvas C, float CurrentYaw, float GunYawMin, float GunYawMax, array<STargetInfo> Targets)
{
    local float IndicatorTopLeftCornerX, IndicatorTopLeftCornerY, YawUpperBound, YawLowerBound, IndicatorStep, Shade, TextWidth, TextHeight;
    local int i, Yaw, Quotient, Index, YawSegmentSchemaIndex, VisibleYawSegmentsNumber;
    local int TargetTickCountLeft, TargetTickCountRight;
    local string Label;
    local color Color;
    local array<int> TickBuckets;
    local float StrikeThroughEndIndex, StrikeThroughLength, RelativeTickPostion, TickPosition;
    local float GunYawMaxTruncated, GunYawMinTruncated;
    local float RealIndicatorStartPosition,  RealIndicatorEndPosition;

    if (PRI == none || C == none)
    {
        return;
    }

    IndicatorTopLeftCornerX = C.SizeX * 0.5 - default.YawIndicatorLength * 0.5;
    IndicatorTopLeftCornerY = C.SizeY * 0.95;

    VisibleYawSegmentsNumber = default.NumberOfYawSegments * default.YawSegmentSchema.Length;
    CurrentYaw = int(class'UMath'.static.Floor(CurrentYaw, default.YawScaleStep));
    YawLowerBound = CurrentYaw - default.YawScaleStep * VisibleYawSegmentsNumber * 0.5;
    YawUpperBound = CurrentYaw + default.YawScaleStep * VisibleYawSegmentsNumber * 0.5;
    IndicatorStep = default.YawIndicatorLength / VisibleYawSegmentsNumber;
    GunYawMaxTruncated = class'UMath'.static.Floor(GunYawMax, default.YawScaleStep);
    GunYawMinTruncated = class'UMath'.static.Floor(GunYawMin, default.YawScaleStep);

    C.Font = C.TinyFont;

    RealIndicatorStartPosition = IndicatorTopLeftCornerX + default.YawIndicatorLength * default.YawDialRoundingConstant / 2;
    RealIndicatorEndPosition = RealIndicatorStartPosition + default.YawIndicatorLength * (1 - default.YawDialRoundingConstant);

    // Draw a long horizontal bar that imitates edge of the indicator
    C.CurX = RealIndicatorStartPosition;
    C.CurY = IndicatorTopLeftCornerY;
    C.DrawHorizontal(IndicatorTopLeftCornerY, RealIndicatorEndPosition - RealIndicatorStartPosition);

    // Prepare buckets for ticks so ticks don't get drawn on top of each other
    TickBuckets.Insert(0, VisibleYawSegmentsNumber);

    // Draw target widgets & target ticks
    for (i = 0; i < Targets.Length; ++i)
    {
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
            // Offset of the tick relative to the dial's length
            RelativeTickPostion = (Index * IndicatorStep) / default.YawIndicatorLength;

            // The new tick position on the "curved" surface of the dial
            TickPosition = IndicatorTopLeftCornerX + class'UInterp'.static.DialRounding(RelativeTickPostion, default.YawDialRoundingConstant) * default.YawIndicatorLength;

            C.CurY = IndicatorTopLeftCornerY + 5.0 + 5 * TickBuckets[Index];
            C.CurX = IndicatorTopLeftCornerX;
            TickBuckets[Index] = TickBuckets[Index] + 1;

            // Draw a target tick on the yaw indicator

            C.DrawVertical(TickPosition, default.TargetTickLength);
        }
        else
        {
            // Draw stacking horizontal target markers that are off of the dial
            if (Index < 0)
            {
                // Left side
                C.SetPos(RealIndicatorStartPosition - 1.5 * default.TargetTickLength, IndicatorTopLeftCornerY);
                C.DrawHorizontal(IndicatorTopLeftCornerY + TargetTickCountLeft * 4, default.TargetTickLength);

                ++TargetTickCountLeft;
            }
            else
            {
                // Right side
                C.SetPos(RealIndicatorEndPosition + 0.5 * default.TargetTickLength, IndicatorTopLeftCornerY);
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

        YawSegmentSchemaIndex = abs(Quotient) % default.YawSegmentSchema.Length;

        // Offset of the tick relative to the dial's length
        RelativeTickPostion = (Index * IndicatorStep) / default.YawIndicatorLength;

        // The new tick position on the "curved" surface of the dial
        TickPosition = IndicatorTopLeftCornerX + class'UInterp'.static.DialRounding(RelativeTickPostion, default.YawDialRoundingConstant) * default.YawIndicatorLength;

        C.CurY = IndicatorTopLeftCornerY - 5.0;
        C.CurX = TickPosition;

        switch (default.YawSegmentSchema[YawSegmentSchemaIndex].Shape)
        {
            case ShortTick:
                C.DrawVertical(TickPosition, -default.SmallSizeTickLength);
                break;
            case MediumLengthTick:
                C.DrawVertical(TickPosition, -default.MiddleSizeTickLength);
                break;
            case LongTick:
                C.DrawVertical(TickPosition, -default.LargeSizeTickLength);
                break;
        }

        if (default.YawSegmentSchema[YawSegmentSchemaIndex].bShouldDrawLabel)
        {
            switch (default.YawSegmentSchema[YawSegmentSchemaIndex].Shape)
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

            C.CurX = TickPosition - TextWidth * 0.5 + 2;
            C.DrawText(Label);
        }
    }

    // Draw a strike-through for values outside of the traverse range
    C.CurY = IndicatorTopLeftCornerY - default.SmallSizeTickLength;

    if (YawLowerBound <= GunYawMinTruncated)
    {
        StrikeThroughEndIndex = (GunYawMinTruncated - YawLowerBound) / default.YawScaleStep;
        StrikeThroughLength = class'UInterp'.static.DialRounding(StrikeThroughEndIndex / VisibleYawSegmentsNumber, default.YawDialRoundingConstant) * default.YawIndicatorLength;

        for (i = default.YawDialRoundingConstant * default.YawIndicatorLength; i <= StrikeThroughLength + 1; ++i)
        {
            Shade = Max(1, 255 * class'UInterp'.static.Mimi(float(i) / default.YawIndicatorLength));
            C.SetDrawColor(Shade, Shade, Shade, 255);
            C.CurX = IndicatorTopLeftCornerX + i;
            C.DrawRect(Texture'WhiteSquareTexture', -1, default.StrikeThroughThickness);
        }
    }

    if (YawUpperBound >= GunYawMaxTruncated)
    {
        StrikeThroughEndIndex = (GunYawMaxTruncated - YawLowerBound) / default.YawScaleStep;
        StrikeThroughLength = (1 - class'UInterp'.static.DialRounding(StrikeThroughEndIndex / VisibleYawSegmentsNumber, default.YawDialRoundingConstant)) * default.YawIndicatorLength;

        for (i = default.YawIndicatorLength - StrikeThroughLength - 1; i < (1 - default.YawDialRoundingConstant) * default.YawIndicatorLength; ++i)
        {
            Shade = Max(1, 255 * class'UInterp'.static.Mimi(float(i) / default.YawIndicatorLength));
            C.SetDrawColor(Shade, Shade, Shade, 255);
            C.CurX = IndicatorTopLeftCornerX + i;
            C.DrawRect(Texture'WhiteSquareTexture', 1, default.StrikeThroughThickness);
        }
    }

    // Draw current value indicator (middle tick)
    C.SetDrawColor(255, 255, 255, 255);
    C.CurY = IndicatorTopLeftCornerY + default.IndicatorMiddleTickOffset;
    C.DrawVertical(IndicatorTopLeftCornerX + (default.YawIndicatorLength * 0.5), default.SmallSizeTickLength);
}

simulated static function float GetPitchLowerBound(float CurrentPitch)
{
    return CurrentPitch - default.PitchScaleStep * default.NumberOfPitchSegments * default.PitchSegmentSchema.Length * 0.5;
}

simulated static function float  GetPitchUpperBound(float CurrentPitch)
{
    return CurrentPitch + default.PitchScaleStep * default.NumberOfPitchSegments * default.PitchSegmentSchema.Length * 0.5;
}

simulated static function DrawPitch(Canvas C, float CurrentPitch, float GunPitchMin, float GunPitchMax, optional float GunPitchOffset)
{
    local float Pitch, IndicatorTopLeftCornerX, IndicatorTopLeftCornerY, PitchUpperBound, PitchLowerBound, IndicatorStep, TextWidth, TextHeight;
    local int Shade, Quotient, Index, VisiblePitchSegmentsNumber, PitchSegmentSchemaIndex, i;
    local string Label;

    IndicatorTopLeftCornerX = C.SizeX * 0.25;
    IndicatorTopLeftCornerY = C.SizeY * 0.5 - default.PitchIndicatorLength * 0.5;

    CurrentPitch += GunPitchOffset;
    VisiblePitchSegmentsNumber = default.NumberOfPitchSegments * default.PitchSegmentSchema.Length;

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

        PitchSegmentSchemaIndex = Abs(Quotient) % default.PitchSegmentSchema.Length;

        switch (default.PitchSegmentSchema[PitchSegmentSchemaIndex].Shape)
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

        if (default.PitchSegmentSchema[PitchSegmentSchemaIndex].bShouldDrawLabel)
        {
            switch (default.PitchSegmentSchema[PitchSegmentSchemaIndex].Shape)
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
            for (i = 0; i < IndicatorStep; ++i)
            {
                // Smooth out the strike-through by splitting it into small portions
                // For each small portion of the strike-through its color is calculated
                Shade = Max(1, 255 * class'UInterp'.static.Mimi(float(Index) / VisiblePitchSegmentsNumber - float(i)/default.PitchIndicatorLength));
                C.SetDrawColor(Shade, Shade, Shade, 255);

                C.CurX = IndicatorTopLeftCornerX - default.SmallSizeTickLength;
                C.CurY = (-i) + IndicatorTopLeftCornerY + Index * default.PitchIndicatorLength / VisiblePitchSegmentsNumber;
                C.DrawRect(Texture'WhiteSquareTexture', default.StrikeThroughThickness, 1);
            }
        }

        // Draw a strike-through if this segment is above the upper limit.
        if (Pitch > int(class'UMath'.static.Floor(GunPitchMax + GunPitchOffset, default.PitchScaleStep)))
        {
            for (i = 0; i < IndicatorStep; ++i)
            {
                // Smooth out the strike-through by splitting it into small portions
                // For each small portion of the strike-through its color is calculated
                Shade = Max(1, 255 * class'UInterp'.static.Mimi(float(Index) / VisiblePitchSegmentsNumber + float(i)/default.PitchIndicatorLength));
                C.SetDrawColor(Shade, Shade, Shade, 255);

                C.CurX = IndicatorTopLeftCornerX - default.SmallSizeTickLength;
                C.CurY = i + IndicatorTopLeftCornerY + Index * default.PitchIndicatorLength / VisiblePitchSegmentsNumber;
                C.DrawRect(Texture'WhiteSquareTexture', default.StrikeThroughThickness, -1);
            }
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

    WidgetsPanelTopLeftX=60
    WidgetsPanelTopLeftY=100
    WidgetsPanelEntryHeight=100

    RangeHeaderString="Range"
    PitchHeaderString="Pitch"

    LargeSizeTickLength=30.0
    MiddleSizeTickLength=15.0
    SmallSizeTickLength=10.0
    LabelOffset=10.0
    IndicatorMiddleTickOffset=20.0
    NumberOfYawSegments=6
    NumberOfPitchSegments=6
    TargetTickLength=3

    Green=(R=0,G=128,B=0,A=255)
    White=(R=255,G=255,B=255,A=255)
    Orange=(R=255,G=165,B=0,A=255)
    Red=(R=255,G=0,B=0,A=255)

    TargetWidgetLayout=(LineHeight=15,HeaderOffsetX=50,IconOffsetX=45,IconOffsetY=20,LineConfig[0]=TWLT_Header,LineConfig[1]=TWLT_MarkerType,LineConfig[2]=TWLT_Correction,LineConfig[3]=TWLT_Distance,LineConfig[4]=TWLT_ExpiryTime)
    TargetToggleHint="Use [%TOGGLESELECTEDARTILLERYTARGET%] to toggle between artillery targets."
    SelectTargetHint="Use [%TOGGLESELECTEDARTILLERYTARGET%] to select an artillery target."

    YawDialRoundingConstant=0.1
    PitchDialRoundingConstant=0.1
}
