//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHArtillerySpottingScope extends Object
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

var UUnits.EAngleUnit PitchAngleUnit, YawAngleUnit;

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
var     int                 PitchIndicatorLength;       // [px], should be a multiple of number of visible pitch ticks
var     int                 YawIndicatorLength;         // [px], should be a multiple of number of visible yaw ticks
var     int                 StrikeThroughThickness;     // [px]

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

var     texture             GradientOverlayX;           // used for dimming the dials
var     texture             GradientOverlayY;           // used for dimming the dials

// Those two fields determine what part of the dial's span will be used
// to display the dial's scale. The span is equal to (0.5-SPAN/2, 0.5+SPAN/2) [rads].
// E.g. YawDialSpan=1 will project the yaw dial on a half-circle.
var     float               YawDialSpan;    // [rad]
var     float               PitchDialSpan;  // [rad]

var     array<float>                    YawTicksShading;  // used by target ticks on yaw dials

var     array<float>                    YawTicksCurvature;
var     array<float>                    PitchTicksCurvature;

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
var     string              NoTargetsHint;

function CreateRenderTable(Canvas C)
{
    local int i;

    if (RenderTable != none)
    {
        return;
    }

    RenderTable = new class'DHDataTable';

    RenderTable.Font = C.MedFont;
    RenderTable.Columns.Insert(0, 2);

    RenderTable.Columns[0].Header = RangeHeaderString @  "(" $ DistanceUnit $ ")";
    RenderTable.Columns[0].TextColor = class'UColor'.default.White;
    RenderTable.Columns[0].Width = 80;
    RenderTable.Columns[0].HeaderJustification = 2;
    RenderTable.Columns[0].RowJustification = 2;
    RenderTable.Columns[1].Header = PitchHeaderString @ "(" $ class'UUnits'.static.GetAngleUnitString(PitchAngleUnit) $ ")";
    RenderTable.Columns[1].TextColor = class'UColor'.default.White;
    RenderTable.Columns[1].Width = 80;
    RenderTable.Columns[1].HeaderJustification = 0;
    RenderTable.Columns[1].RowJustification = 0;

    RenderTable.Rows.Insert(0, RangeTable.Length);

    for (i = 0; i < RangeTable.Length; ++i)
    {
        RenderTable.Rows[i].Columns.Insert(0, 2);
        RenderTable.Rows[i].Columns[0].Value = string(RangeTable[i].Range);
        RenderTable.Rows[i].Columns[0].TextColor = class'UColor'.default.Green;
        RenderTable.Rows[i].Columns[1].Value = class'UFloat'.static.Format(RangeTable[i].Pitch, PitchDecimalsTable);
        RenderTable.Rows[i].Columns[1].TextColor = class'UColor'.default.White;
    }
}

function CalculateShadingAndCurvature()
{
    local int i;
    local int VisibleYawSegmentsNumber, VisiblePitchSegmentsNumber;

    VisibleYawSegmentsNumber = NumberOfYawSegments * YawSegmentSchema.Length;
    VisiblePitchSegmentsNumber = NumberOfPitchSegments * PitchSegmentSchema.Length;

    // Calculate curvature & shading coefficients for ticks on artillery scope's dial
    for (i = 0; i < VisibleYawSegmentsNumber; ++i)
    {
        YawTicksCurvature[i] = class'UInterp'.static.DialRounding(float(i) / VisibleYawSegmentsNumber, YawDialSpan);
        YawTicksShading[i] = 1 - 2 * Abs(YawTicksCurvature[i] - 0.5);
    }

    for (i = 0; i < VisiblePitchSegmentsNumber; ++i)
    {
        PitchTicksCurvature[i] = class'UInterp'.static.DialRounding(float(i) / VisiblePitchSegmentsNumber, PitchDialSpan);
    }
}

function DrawSpottingScopeOverlay(Canvas C)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight;

    if (SpottingScopeOverlay != none)
    {
        TextureSize = float(SpottingScopeOverlay.MaterialUSize());
        TilePixelWidth = TextureSize / 0.4 * 0.955;
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX);
        TileStartPosU = (TextureSize - TilePixelWidth) * 0.5;
        TileStartPosV = (TextureSize - TilePixelHeight) * 0.5;
        C.SetPos(0.0, 0.0);

        C.DrawColor = class'UColor'.default.White;
        C.DrawTile(SpottingScopeOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
    }
}

function UpdateTable(Canvas C, float ActiveLowerBoundPitch, float ActiveUpperBoundPitch)
{
    if (!bIsTableInitialized)
    {
        CreateRenderTable(C);
        CalculateShadingAndCurvature();

        bIsTableInitialized = true;
    }
}

function array<STargetInfo> PrepareTargetInfo(DHPlayer PC, VehicleWeapon VW)
{
    local vector                                        Delta;
    local float                                         Deflection;
    local int                                           Distance, MarkerTimeout, MarkerIndex, MarkersTotal, i, j;
    local array<STargetInfo>                            Targets;
    local STargetInfo                                   TargetInfo;
    local string                                        SquadName;
    local DHGameReplicationInfo.MapMarker               MapMarker;
    local DHGameReplicationInfo                         GRI;
    local array<DHGameReplicationInfo.MapMarker>        TargetMapMarkers, GlobalArtilleryRequests, PersonalMapMarkers;
    local rotator WeaponRotation;
    local vector WeaponLocation;

    if (PC == none || PC.SquadReplicationInfo == none || VW == none)
    {
        return Targets;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (GRI == none)
    {
        return Targets;
    }

    WeaponLocation = VW.Location;
    WeaponLocation.Z = 0.0;

    WeaponRotation = VW.Rotation;
    WeaponRotation.Roll = 0;
    WeaponRotation.Pitch = 0;

    // Get all global fire support markers excluding player's own
    GRI.GetGlobalArtilleryMapMarkers(PC, GlobalArtilleryRequests);

    // Get personal markers
    PersonalMapMarkers = PC.GetPersonalMarkers();

    // From all global markers leave only the one selected by the player
    for (i = 0; i < GlobalArtilleryRequests.Length; ++i)
    {
        if (GlobalArtilleryRequests[i].SquadIndex == PC.ArtillerySupportSquadIndex)
        {
            TargetMapMarkers[TargetMapMarkers.Length] = GlobalArtilleryRequests[i];
        }
    }

    // Add measurement markers
    for (i = 0; i < PersonalMapMarkers.Length; ++i)
    {
        if (PersonalMapMarkers[i].MapMarkerClass.default.Type == MT_Measurement)
        {
            TargetMapMarkers[TargetMapMarkers.Length] = PersonalMapMarkers[i];
        }
    }

    // Prepare target information for each marker
    for (i = 0; i < TargetMapMarkers.Length; ++i)
    {
        MapMarker = TargetMapMarkers[i];

        Delta = MapMarker.WorldLocation - WeaponLocation;
        Delta.Z = 0;
        // calculate deflection between target's shift (Delta) and weapon's direction (VehicleRotation)
        Deflection = class'UVector'.static.SignedAngle(vector(rotator(Normal(Delta))), vector(WeaponRotation), vect(0, 0, 1));
        Deflection = class'UUnits'.static.ConvertAngleUnit(Deflection, AU_Radians, AU_Milliradians);

        SquadName = PC.SquadReplicationInfo.GetSquadName(PC.GetTeamNum(), MapMarker.SquadIndex);
        Distance = int(class'DHUnits'.static.UnrealToMeters(VSize(Delta)));

        if (MapMarker.ExpiryTime != -1)
        {
            MarkerTimeout = MapMarker.ExpiryTime - GRI.ElapsedTime;
        }
        else
        {
            MarkerTimeout = -1;
        }

        switch (TargetMapMarkers[i].MapMarkerClass.default.Type)
        {
            case MT_OnMapArtilleryRequest:
                // calculate which index does this marker's squad have throughout global on-map artillery requests
                MarkerIndex = 0;
                for (j = 0; j < GlobalArtilleryRequests.Length; ++j)
                {
                    if (GlobalArtilleryRequests[j].SquadIndex < TargetMapMarkers[i].SquadIndex)
                    {
                        ++MarkerIndex;
                    }
                }
                ++MarkerIndex;
                MarkersTotal = GlobalArtilleryRequests.Length;
                break;
            case MT_Measurement:
                // leave neutral values for measurement markers
                MarkerIndex = -1;
                MarkersTotal = -1;
                break;
            default:
                Warn("Unknown artillery marker type in DHPlayer.PrepareTargetInfo()");
        }

        TargetInfo.Distance       = Distance;
        TargetInfo.MarkerIndex    = MarkerIndex;
        TargetInfo.MarkersTotal   = MarkersTotal;
        TargetInfo.SquadName      = SquadName;
        TargetInfo.YawCorrection  = Deflection / YawScaleStep;  // normalize deflection to yaw scale
        TargetInfo.Marker         = MapMarker;
        TargetInfo.Timeout        = MarkerTimeout;
        Targets[Targets.Length]   = TargetInfo;
    }

    return Targets;
}

function Draw(DHPlayer PC, Canvas C, DHVehicleWeaponPawn VWP)
{
    local array<STargetInfo> Targets;

    if (PC == none || C == none || VWP == none || VWP.VehWep == none)
    {
        return;
    }

    Targets = PrepareTargetInfo(PC, VWP.VehWep);

    // Draw the spotting scope overlay
    DrawSpottingScopeOverlay(C);

    if (PC.myHud != none && !PC.myHUD.bHideHUD)
    {
        DrawRangeTable(C, VWP);
        DrawPitch(C, VWP);
        DrawYaw(PC, C, VWP, Targets);
        DrawTargets(PC, C, VWP, Targets);
    }
}

function DrawRangeTable(Canvas C, DHVehicleWeaponPawn VWP)
{
    local float ActiveLowerBoundPitch, ActiveUpperBoundPitch;
    local float X, Y;

    if (C == none || VWP == none || VWP.VehicleBase == none)
    {
        return;
    }

    ActiveLowerBoundPitch = class'UUnits'.static.ConvertAngleUnit(VWP.VehicleBase.Rotation.Pitch + VWP.GetGunPitchMin(), AU_Unreal, PitchAngleUnit);
    ActiveUpperBoundPitch = class'UUnits'.static.ConvertAngleUnit(VWP.VehicleBase.Rotation.Pitch + VWP.GetGunPitchMax(), AU_Unreal, PitchAngleUnit);

    UpdateTable(C, ActiveLowerBoundPitch, ActiveUpperBoundPitch);

    Y = (C.ClipY - RenderTable.GetHeight(C)) * 0.5;
    X = (C.ClipX * 0.85) - (RenderTable.GetWidth() * 0.5);

    RenderTable.DrawTable(C, X, Y);
}

// A helper function to draw a single widget on the left panel in spotting scope view
function DrawTargetWidget(DHPlayer PC, Canvas C, float X, float Y, STargetInfo TargetInfo, float CurrentYaw, int MinimumGunYaw, int MaximumGunYaw)
{
    local string Labels[2];
    local int Deflection;
    local color IconColor, LabelColors[2];
    local float XL, YL;
    local int LabelIndex, LineIndex, MaxLines, LineOffsetX, i;

    CurrentYaw = int(class'UMath'.static.Floor(CurrentYaw, YawScaleStep));

    C.SetDrawColor(White.R, White.G, White.B, White.A);
    C.Font = C.MedFont;

    MaxLines = arraycount(TargetWidgetLayout.LineConfig);

    while (i < MaxLines)
    {
        LabelColors[0] = White;
        Labels[0] = "";
        Labels[1] = "";
        LabelColors[0] = White;
        LabelColors[1] = White;
        LineOffsetX = 0;

        // Calculate what to draw
        switch (TargetWidgetLayout.LineConfig[i])
        {
            case TWLT_Header:
                switch (TargetInfo.Marker.MapMarkerClass.default.Type)
                {
                    case MT_OnMapArtilleryRequest:
                        Labels[0] = "SELECTED TARGET";

                        if (TargetInfo.MarkersTotal > 1)
                        {
                            Labels[1] = " [" $ TargetInfo.MarkerIndex $ " / " $ TargetInfo.MarkersTotal $ "]";
                            LabelColors[1] = Green;
                        }
                        break;
                    case MT_Measurement:
                        Labels[0] = "MEASUREMENT TOOL";
                        break;
                    case MT_Measurement:
                        break;
                }
                LineOffsetX = TargetWidgetLayout.HeaderOffsetX;
                break;
            case TWLT_MarkerType:
                switch (TargetInfo.Marker.MapMarkerClass.default.Type)
                {
                    case MT_OnMapArtilleryRequest:
                        Labels[0] = "Squad: ";
                        Labels[1] = TargetInfo.SquadName @ "-" @ TargetInfo.Marker.MapMarkerClass.default.MarkerName;
                        LabelColors[1] = Green;
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
                        LabelColors[0] = Green;
                    }
                    else if (TargetInfo.Timeout > 0)
                    {
                        LabelColors[0] = Orange;
                    }
                    else
                    {
                        LabelColors[0] = Red;
                    }
                }
                LineOffsetX = TargetWidgetLayout.IconOffsetX;
                break;
            case TWLT_Correction:
                Deflection = TargetInfo.YawCorrection * YawScaleStep + CurrentYaw;
                Labels[0] = "Correction: ";

                if (TargetInfo.Marker.MapMarkerClass.static.IsMarkerActive(PC, TargetInfo.Marker))
                {
                    if (Deflection > 0)
                    {
                        Labels[1] = Deflection $ class'UUnits'.static.GetAngleUnitString(YawAngleUnit) @ "left";

                        if (CurrentYaw - Deflection < MinimumGunYaw)
                        {
                            // the target is outside of the upper traverse limit
                            LabelColors[1] = Red;
                        }
                        else
                        {
                            // the target is within the traverse range
                            LabelColors[1] = Orange;
                        }
                    }
                    else if (Deflection == 0)
                    {
                        Labels[1] = "0" $ class'UUnits'.static.GetAngleUnitString(YawAngleUnit);
                        LabelColors[1] = Green;
                    }
                    else
                    {
                        Labels[1] = -Deflection $ class'UUnits'.static.GetAngleUnitString(YawAngleUnit) @ "right";

                        if (CurrentYaw - Deflection > MaximumGunYaw)
                        {
                            // the target is outside of the lower traverse limit
                            LabelColors[1] = Red;
                        }
                        else
                        {
                            // the target is within the traverse range
                            LabelColors[1] = Orange;
                        }
                    }
                }
                else
                {
                    Labels[1] = TargetInfo.Marker.MapMarkerClass.default.CalculatingString;
                    LabelColors[1] = Orange;
                }

                break;
            case TWLT_Distance:
                C.SetDrawColor(White.R, White.G, White.B, White.A);
                Labels[0] = "Distance: ";
                if (TargetInfo.Marker.MapMarkerClass.static.IsMarkerActive(PC, TargetInfo.Marker))
                {
                    Labels[1] = TargetInfo.Marker.MapMarkerClass.static.GetDistanceString(PC, TargetInfo.Marker);
                    LabelColors[1] = Green;
                }
                else
                {
                    Labels[1] = TargetInfo.Marker.MapMarkerClass.default.CalculatingString;
                    LabelColors[1] = Orange;
                }
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
                    C.CurY = Y + LineIndex * TargetWidgetLayout.LineHeight;
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
    C.CurX = X - TargetWidgetLayout.IconOffsetX;
    C.CurY = Y + TargetWidgetLayout.IconOffsetY;
    IconColor = TargetInfo.Marker.MapMarkerClass.static.GetIconColor(PC, TargetInfo.Marker);
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

function DrawTargets(DHPlayer PC, Canvas C, DHVehicleWeaponPawn VWP, array<STargetInfo> Targets)
{
    local int i;
    local DHGameReplicationInfo GRI;
    local float GunYawMaxTruncated, GunYawMinTruncated;
    local array<DHGameReplicationInfo.MapMarker> ArtilleryMarkers;
    local bool bSelectedMarkerAvailable;
    local string Label;
    local Color LabelColor;
    local float CurrentYaw, GunYawMin, GunYawMax;

    if (PC == none || VWP == none)
    {
        return;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    CurrentYaw = class'UUnits'.static.ConvertAngleUnit(VWP.GetGunYaw(), AU_Unreal, YawAngleUnit);
    GunYawMin = class'UUnits'.static.ConvertAngleUnit(VWP.GetGunYawMin(), AU_Unreal, YawAngleUnit);
    GunYawMax = class'UUnits'.static.ConvertAngleUnit(VWP.GetGunYawMax(), AU_Unreal, YawAngleUnit);

    GunYawMaxTruncated = class'UMath'.static.Floor(GunYawMax, YawScaleStep);
    GunYawMinTruncated = class'UMath'.static.Floor(GunYawMin, YawScaleStep);

    for (i = 0; i < Targets.Length; ++i)
    {
        DrawTargetWidget(PC, C, WidgetsPanelTopLeftX, WidgetsPanelTopLeftY + WidgetsPanelEntryHeight * i, Targets[i], CurrentYaw, GunYawMinTruncated, GunYawMaxTruncated);
    }

    GRI.GetGlobalArtilleryMapMarkers(PC, ArtilleryMarkers);

    bSelectedMarkerAvailable = false;

    if (PC.ArtillerySupportSquadIndex != 255)
    {
        // The player selected some marker - let's check if that marker has not expired yet.
        // Unfortunately we have to iterate over the whole array
        // because the selection of the target is driven by squad's number
        // and not by the index of the marker in the actual array of targets.
        for (i = 0; i < ArtilleryMarkers.Length; ++i)
        {
            if (ArtilleryMarkers[i].SquadIndex == PC.ArtillerySupportSquadIndex &&
                ArtilleryMarkers[i].ExpiryTime > GRI.ElapsedTime)
            {
                bSelectedMarkerAvailable = true;
                break;
            }
        }
    }

    LabelColor = class'UColor'.default.White;

    if (ArtilleryMarkers.Length > 0 && (!bSelectedMarkerAvailable || PC.ArtillerySupportSquadIndex == 255))
    {
        // The player hasn't chosen anything from the available requests
        Label = Repl(SelectTargetHint, "{ArtilleryMarkersLength}", ArtilleryMarkers.Length);
        // Flash the label to get the player's attention
        LabelColor = class'UColor'.static.Interp((Sin(PC.Level.TimeSeconds * PI * 2) + 1) / 2, Green, White);
    }
    else if (bSelectedMarkerAvailable)
    {
        if (ArtilleryMarkers.Length > 1)
        {
            // The player has selected an available marker but there are more to toggle between
            Label = Repl(TargetToggleHint, "{ArtilleryMarkersLength}", ArtilleryMarkers.Length);
            LabelColor = class'UColor'.default.Green;
        }
        else
        {
            // The player has selected the only available marker - do not show any hints
            Label = "";
        }
    }
    else
    {
        Label = NoTargetsHint;
    }

    Label = class'ROTeamGame'.static.ParseLoadingHintNoColor(Label, PC);

    C.CurX = WidgetsPanelTopLeftX - 40;
    C.CurY = WidgetsPanelTopLeftY - 30;
    C.SetDrawColor(LabelColor.R, LabelColor.G, LabelColor.B, LabelColor.A);
    C.DrawText(Label);
}

function DrawYaw(DHPlayer PC, Canvas C, DHVehicleWeaponPawn VWP, array<STargetInfo> Targets)
{
    local float TextWidthFloat, TextHeightFloat;
    local int TextWidth, TextHeight, IndicatorTopLeftCornerX, IndicatorTopLeftCornerY, YawUpperBound, YawLowerBound;
    local int i, Yaw, Quotient, Index, YawSegmentSchemaIndex, VisibleYawSegmentsNumber, IndicatorStep;
    local int TargetTickCountLeft, TargetTickCountRight;
    local int StrikeThroughStart, StrikeThroughEnd, TickPosition;
    local int StrikeThroughEndIndex, StrikeThroughStartIndex;
    local int GunYawMaxTruncated, GunYawMinTruncated;
    local int BottomDialBound, TopDialBound;
    local int CurrentYaw, GunYawMin, GunYawMax;
    local array<int> TargetTickBuckets;
    local float CurvatureCoefficient, ShadingCoefficient;
    local string Label;
    local color Color;
    local DHGameReplicationInfo.MapMarker Marker;

    if (PC == none || C == none || VWP == none)
    {
        return;
    }

    CurrentYaw = class'UUnits'.static.ConvertAngleUnit(VWP.GetGunYaw(), AU_Unreal, YawAngleUnit);
    CurrentYaw = int(class'UMath'.static.Floor(CurrentYaw, YawScaleStep));
    GunYawMin = class'UUnits'.static.ConvertAngleUnit(VWP.GetGunYawMin(), AU_Unreal, YawAngleUnit);
    GunYawMax = class'UUnits'.static.ConvertAngleUnit(VWP.GetGunYawMax(), AU_Unreal, YawAngleUnit);

    IndicatorTopLeftCornerX = C.SizeX * 0.5 - 0.5 * YawIndicatorLength;
    IndicatorTopLeftCornerY = C.SizeY * 0.95;

    VisibleYawSegmentsNumber = NumberOfYawSegments * YawSegmentSchema.Length;
    YawLowerBound = CurrentYaw - YawScaleStep * VisibleYawSegmentsNumber * 0.5;
    YawUpperBound = CurrentYaw + YawScaleStep * VisibleYawSegmentsNumber * 0.5;
    IndicatorStep = YawIndicatorLength / VisibleYawSegmentsNumber;

    GunYawMaxTruncated = class'UMath'.static.Floor(GunYawMax, YawScaleStep);
    GunYawMinTruncated = class'UMath'.static.Floor(GunYawMin, YawScaleStep);

    BottomDialBound = class'UInterp'.static.DialCurvature(0.5 - YawDialSpan * 0.5);
    TopDialBound = class'UInterp'.static.DialCurvature(0.5 + YawDialSpan * 0.5);

    C.Font = C.TinyFont;
    C.SetDrawColor(255, 255, 255, 255);

    // Start drawing scale ticks
    C.CurY = IndicatorTopLeftCornerY - 5.0;

    for (Yaw = YawLowerBound; Yaw < YawUpperBound; Yaw += YawScaleStep)
    {
        // Calculate index of the tick in the indicator reference frame
        Index = (Yaw - YawLowerBound) / YawScaleStep;

        // Transform the "linear" coordinates to the coordinates on the curved dial
        CurvatureCoefficient = YawTicksCurvature[Index];

        // Calculate index of the current readout value on the mortar yaw span
        Quotient = int(class'UMath'.static.FlooredDivision(Yaw, YawScaleStep));

        Label = string(int(class'UMath'.static.Floor(Yaw, YawScaleStep)));

        // Get the label's length
        C.StrLen(Label, TextWidthFloat, TextHeightFloat);
        TextWidth = TextWidthFloat;
        TextHeight = TextHeightFloat;

        YawSegmentSchemaIndex = Abs(Quotient) % YawSegmentSchema.Length;

        // The new tick position on the "curved" surface of the dial
        TickPosition = IndicatorTopLeftCornerX + CurvatureCoefficient * YawIndicatorLength;

        C.CurY = IndicatorTopLeftCornerY - 5.0;
        C.CurX = TickPosition;

        switch (YawSegmentSchema[YawSegmentSchemaIndex].Shape)
        {
            case ShortTick:
                C.DrawVertical(TickPosition, -SmallSizeTickLength);
                break;
            case MediumLengthTick:
                C.DrawVertical(TickPosition, -MiddleSizeTickLength);
                break;
            case LongTick:
                C.DrawVertical(TickPosition, -LargeSizeTickLength);
                break;
        }

        if (YawSegmentSchema[YawSegmentSchemaIndex].bShouldDrawLabel)
        {
            switch (YawSegmentSchema[YawSegmentSchemaIndex].Shape)
            {
                case ShortTick:
                    C.CurY = C.CurY - SmallSizeTickLength - TextHeight - LabelOffset;
                    break;
                case MediumLengthTick:
                    C.CurY = C.CurY - MiddleSizeTickLength - TextHeight - LabelOffset;
                    break;
                case LongTick:
                    C.CurY = C.CurY - LargeSizeTickLength - TextHeight - LabelOffset;
                    break;
            }

            C.CurX = TickPosition - TextWidth * 0.5 + 2;
            C.DrawText(Label);
        }
    }

    // Draw a strike-through for values outside of the traverse range
    if (YawLowerBound < GunYawMinTruncated)
    {
        StrikeThroughStartIndex = 0;
        StrikeThroughEndIndex = (GunYawMinTruncated - YawLowerBound) / YawScaleStep;
        StrikeThroughEnd = YawIndicatorLength * YawTicksCurvature[StrikeThroughEndIndex];

        // Draw the strike-through
        C.SetPos(IndicatorTopLeftCornerX, IndicatorTopLeftCornerY - SmallSizeTickLength);
        C.DrawRect(Texture'WhiteSquareTexture', StrikeThroughEnd, StrikeThroughThickness);

        // Add the missing tick on the end of the strike-through line
        C.SetPos(IndicatorTopLeftCornerX + StrikeThroughEnd, IndicatorTopLeftCornerY - SmallSizeTickLength);
        C.DrawVertical(IndicatorTopLeftCornerX + StrikeThroughEnd, StrikeThroughThickness);
    }

    if (YawUpperBound > GunYawMaxTruncated)
    {
        StrikeThroughStartIndex = (GunYawMaxTruncated - YawLowerBound) / YawScaleStep;
        StrikeThroughStart = YawIndicatorLength * YawTicksCurvature[StrikeThroughStartIndex];
        StrikeThroughEnd = YawIndicatorLength;

        // Draw the strike-through
        C.SetPos(IndicatorTopLeftCornerX + StrikeThroughStart, IndicatorTopLeftCornerY - SmallSizeTickLength);
        C.DrawRect(Texture'WhiteSquareTexture', StrikeThroughEnd - StrikeThroughStart, StrikeThroughThickness);

        // Add the missing tick on the end of the strike-through line
        C.SetPos(IndicatorTopLeftCornerX + StrikeThroughStart, IndicatorTopLeftCornerY - SmallSizeTickLength);
        C.DrawVertical(IndicatorTopLeftCornerX + StrikeThroughStart, StrikeThroughThickness);
    }

    // Draw the gradient overlay in a slightly bigger box to also cover the readout labels that could stick out
    C.SetPos(IndicatorTopLeftCornerX - 0.5 * LargeSizeTickLength, IndicatorTopLeftCornerY - 1.5 * LargeSizeTickLength);
    C.DrawTile(GradientOverlayX, YawIndicatorLength + LargeSizeTickLength, 3 * LargeSizeTickLength, 0, 0, 256, 32);

    // Prepare buckets for ticks so ticks don't get drawn on top of each other
    TargetTickBuckets.Insert(0, VisibleYawSegmentsNumber);

    // Draw target widgets & target ticks
    for (i = 0; i < Targets.Length; ++i)
    {
        Marker = Targets[i].Marker;

        if (!Marker.MapMarkerClass.static.IsMarkerActive(PC, Marker))
        {
            // skip targets that are in the 'calculating' state
            continue;
        }

        // Which tick on the dial does this target correspond to
        Index = (VisibleYawSegmentsNumber * 0.5) - Targets[i].YawCorrection - int(CurrentYaw / YawScaleStep);

        Color = Targets[i].Marker.MapMarkerClass.static.GetIconColor(PC, Targets[i].Marker);

        // Draw a tick on the yaw dial only if the target is within bounds of the yaw indicator
        if (Index < VisibleYawSegmentsNumber && Index >= 0)
        {
            // Get the curvature value (the relative position with respect to IndicatorTopLeftCornerX & YawIndicatorLength)
            CurvatureCoefficient = YawTicksCurvature[Index];

            ShadingCoefficient = YawTicksShading[Index];
            ShadingCoefficient = FClamp(ShadingCoefficient, 0.25, 0.75);
            C.SetDrawColor(ShadingCoefficient * Color.R, ShadingCoefficient * Color.G, ShadingCoefficient * Color.B, 255);

            // The new tick position on the "curved" surface of the dial
            TickPosition = IndicatorTopLeftCornerX + CurvatureCoefficient * YawIndicatorLength;

            C.CurY = IndicatorTopLeftCornerY + 5.0 + 5 * TargetTickBuckets[Index];
            C.CurX = IndicatorTopLeftCornerX;
            TargetTickBuckets[Index] = TargetTickBuckets[Index] + 1;

            // Draw a target tick on the yaw indicator
            C.DrawVertical(TickPosition, TargetTickLength);
        }
        else
        {
            C.SetDrawColor(0.75 * Color.R, 0.75 * Color.G, 0.75 * Color.B, 255);

            // Draw stacking horizontal target markers that are off of the dial
            if (Index < 0)
            {
                // Left side
                C.SetPos(IndicatorTopLeftCornerX - 1.5 * TargetTickLength, IndicatorTopLeftCornerY);
                C.DrawHorizontal(IndicatorTopLeftCornerY + TargetTickCountLeft * 4, TargetTickLength);

                ++TargetTickCountLeft;
            }
            else
            {
                // Right side
                C.SetPos(IndicatorTopLeftCornerX + YawIndicatorLength + 0.5 * TargetTickLength, IndicatorTopLeftCornerY);
                C.DrawHorizontal(IndicatorTopLeftCornerY + TargetTickCountRight * 4, TargetTickLength);

                ++TargetTickCountRight;
            }
        }
    }

    C.SetDrawColor(255, 255, 255, 255);

    // Draw a long horizontal bar that imitates edge of the indicator
    C.SetDrawColor(255, 255, 255, 255);
    C.CurX = IndicatorTopLeftCornerX;
    C.CurY = IndicatorTopLeftCornerY;
    C.DrawHorizontal(IndicatorTopLeftCornerY, YawIndicatorLength);

    // Draw current value indicator (middle tick)
    C.CurY = IndicatorTopLeftCornerY + IndicatorMiddleTickOffset;
    CurvatureCoefficient = YawTicksCurvature[0.5 * VisibleYawSegmentsNumber];
    C.DrawVertical(IndicatorTopLeftCornerX + CurvatureCoefficient * YawIndicatorLength, SmallSizeTickLength);
}

function float GetPitchLowerBound(float CurrentPitch)
{
    return CurrentPitch - PitchScaleStep * NumberOfPitchSegments * PitchSegmentSchema.Length * 0.5;
}

function float GetPitchUpperBound(float CurrentPitch)
{
    return CurrentPitch + PitchScaleStep * NumberOfPitchSegments * PitchSegmentSchema.Length * 0.5;
}

function DrawPitch(Canvas C, DHVehicleWeaponPawn VWP)
{
    local int CurrentPitch, GunPitchOffset, GunPitchMin, GunPitchMax;
    local float TextWidthFloat, TextHeightFloat;
    local int TextWidth, TextHeight;
    local int Pitch, IndicatorTopLeftCornerX, IndicatorTopLeftCornerY, PitchUpperBound, PitchLowerBound;
    local int Quotient, Index, VisiblePitchSegmentsNumber, PitchSegmentSchemaIndex, IndicatorStep;
    local int BottomDialBound, TopDialBound;
    local int StrikeThroughStart, StrikeThroughEnd;
    local int StrikeThroughEndIndex, StrikeThroughStartIndex, TickPosition;
    local float CurvatureConstant;
    local string Label;

    if (C == none || VWP == none && VWP.VehicleBase != none)
    {
        return;
    }

    CurrentPitch = class'UUnits'.static.ConvertAngleUnit(VWP.GetGunPitch(), AU_Unreal, PitchAngleUnit);
    GunPitchOffset = class'UUnits'.static.ConvertAngleUnit(VWP.VehicleBase.Rotation.Pitch, AU_Unreal, PitchAngleUnit);
    CurrentPitch = class'UMath'.static.Floor(CurrentPitch + GunPitchOffset, PitchScaleStep);

    GunPitchMin = class'UUnits'.static.ConvertAngleUnit(VWP.GetGunPitchMin(), AU_Unreal, PitchAngleUnit) + GunPitchOffset;
    GunPitchMin = class'UMath'.static.Floor(GunPitchMin, PitchScaleStep);
    GunPitchMax = class'UUnits'.static.ConvertAngleUnit(VWP.GetGunPitchMax(), AU_Unreal, PitchAngleUnit) + GunPitchOffset;
    GunPitchMax = class'UMath'.static.Floor(GunPitchMax, PitchScaleStep);

    IndicatorTopLeftCornerX = C.SizeX * 0.25;
    IndicatorTopLeftCornerY = C.SizeY * 0.5 - 0.5 * PitchIndicatorLength;

    VisiblePitchSegmentsNumber = NumberOfPitchSegments * PitchSegmentSchema.Length;

    PitchLowerBound = GetPitchLowerBound(CurrentPitch);
    PitchUpperBound = GetPitchUpperBound(CurrentPitch);
    IndicatorStep = PitchIndicatorLength / VisiblePitchSegmentsNumber;
    BottomDialBound = class'UInterp'.static.DialCurvature(0.5 - PitchDialSpan * 0.5);
    TopDialBound = class'UInterp'.static.DialCurvature(0.5 + PitchDialSpan * 0.5);

    C.Font = C.TinyFont;
    C.SetDrawColor(255, 255, 255, 255);
    C.SetPos(IndicatorTopLeftCornerX, IndicatorTopLeftCornerY);

    // Start drawing scale ticks
    for (Pitch = PitchLowerBound; Pitch < PitchUpperBound; Pitch += PitchScaleStep)
    {
        // Calculate index of the tick in the indicator reference frame
        Index = VisiblePitchSegmentsNumber - (Pitch - PitchLowerBound) / PitchScaleStep - 1;

        // Get the cached values
        CurvatureConstant = PitchTicksCurvature[Index];

        // Calculate index of the current readout value on the mortar pitch span
        Quotient = class'UMath'.static.FlooredDivision(Pitch, PitchScaleStep);

        Label = class'UFloat'.static.Format(Pitch, PitchDecimalsDial);

        // Get the label's length
        C.StrLen(Label, TextWidthFloat, TextHeightFloat);
        TextWidth = TextWidthFloat;
        TextHeight = TextHeightFloat;

        C.CurX = IndicatorTopLeftCornerX - 5.0;
        TickPosition = IndicatorTopLeftCornerY + CurvatureConstant * PitchIndicatorLength;

        PitchSegmentSchemaIndex = Abs(Quotient) % PitchSegmentSchema.Length;

        switch (PitchSegmentSchema[PitchSegmentSchemaIndex].Shape)
        {
            case ShortTick:
                C.DrawHorizontal(TickPosition, -SmallSizeTickLength);
                break;
            case MediumLengthTick:
                C.DrawHorizontal(TickPosition, -MiddleSizeTickLength);
                break;
            case LongTick:
                C.DrawHorizontal(TickPosition, -LargeSizeTickLength);
                break;
        }

        if (PitchSegmentSchema[PitchSegmentSchemaIndex].bShouldDrawLabel)
        {
            switch (PitchSegmentSchema[PitchSegmentSchemaIndex].Shape)
            {
                case ShortTick:
                    C.CurX = C.CurX - SmallSizeTickLength - TextWidth - LabelOffset;
                    break;
                case MediumLengthTick:
                    C.CurX = C.CurX - MiddleSizeTickLength - TextWidth - LabelOffset;
                    break;
                case LongTick:
                    C.CurX = C.CurX - LargeSizeTickLength - TextWidth - LabelOffset;
                    break;
            }

            C.CurY = TickPosition - TextHeight * 0.5;
            C.DrawText(Label);
        }
    }

    // Draw a strike-through for values outside of the traverse range

    if (PitchLowerBound < GunPitchMin)
    {
        StrikeThroughStartIndex = VisiblePitchSegmentsNumber - (GunPitchMin - PitchLowerBound) / PitchScaleStep - 1;
        StrikeThroughStart = PitchTicksCurvature[StrikeThroughStartIndex] * PitchIndicatorLength;
        StrikeThroughEnd = PitchIndicatorLength;

        // Draw the strike-through
        C.SetPos(IndicatorTopLeftCornerX - SmallSizeTickLength, IndicatorTopLeftCornerY + StrikeThroughStart);
        C.DrawRect(Texture'WhiteSquareTexture', StrikeThroughThickness, StrikeThroughEnd - StrikeThroughStart);

        // Add the missing tick on the end of the strike-through line
        C.SetPos(IndicatorTopLeftCornerX - SmallSizeTickLength, IndicatorTopLeftCornerY + StrikeThroughEnd);
        C.DrawHorizontal(IndicatorTopLeftCornerY + StrikeThroughStart, StrikeThroughThickness);
    }

    // Draw a strike-through if this segment is above the upper limit.
    if (PitchUpperBound > GunPitchMax)
    {
        StrikeThroughStartIndex = 0;
        StrikeThroughEndIndex = (PitchUpperBound - GunPitchMax) / PitchScaleStep - 1;
        StrikeThroughStart = 0;
        StrikeThroughEnd = PitchTicksCurvature[StrikeThroughEndIndex] * PitchIndicatorLength;

        // Draw the strike-through
        C.SetPos(IndicatorTopLeftCornerX - SmallSizeTickLength, IndicatorTopLeftCornerY + StrikeThroughStart);
        C.DrawRect(Texture'WhiteSquareTexture', StrikeThroughThickness, StrikeThroughEnd - StrikeThroughStart);

        // Add the missing tick on the end of the strike-through line
        C.SetPos(IndicatorTopLeftCornerX - SmallSizeTickLength, IndicatorTopLeftCornerY + StrikeThroughEnd);
        C.DrawHorizontal(IndicatorTopLeftCornerY + StrikeThroughEnd, StrikeThroughThickness);
    }

    // Draw the gradient overlay in a slightly bigger box to also cover the readout labels that could stick out
    C.SetPos(IndicatorTopLeftCornerX - 3 * LargeSizeTickLength, IndicatorTopLeftCornerY - 1.5 * LargeSizeTickLength);
    C.DrawTile(GradientOverlayY, 3 * LargeSizeTickLength, PitchIndicatorLength + 3 * LargeSizeTickLength, 0, 0, 32, 256);

    // Draw a long horizontal bar that imitates edge of the indicator
    C.CurY = IndicatorTopLeftCornerY;
    C.DrawVertical(IndicatorTopLeftCornerX, PitchIndicatorLength);

    // Draw current value indicator (middle tick)
    C.CurX = IndicatorTopLeftCornerX + IndicatorMiddleTickOffset;
    CurvatureConstant = PitchTicksCurvature[0.5 * VisiblePitchSegmentsNumber - 1];
    TickPosition = IndicatorTopLeftCornerY + CurvatureConstant * PitchIndicatorLength;
    C.DrawHorizontal(TickPosition, SmallSizeTickLength);
}

defaultproperties
{
    SpottingScopeOverlay=Texture'DH_VehicleOptics_tex.German.German_sight_background'
    YawScaleStep=1.0
    PitchScaleStep=1.0

    PitchIndicatorLength=300
    YawIndicatorLength=300
    StrikeThroughThickness=10

    PitchAngleUnit=AU_Milliradians
    YawAngleUnit=AU_Milliradians
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
    TargetToggleHint="Press [%TOGGLESELECTEDARTILLERYTARGET%] to toggle between artillery targets"
    SelectTargetHint="Press [%TOGGLESELECTEDARTILLERYTARGET%] to select an artillery target"
    NoTargetsHint="No targets available"

    YawDialSpan=0.8   // 0.6rad ~= 60 degrees
    PitchDialSpan=0.5

    GradientOverlayX=Texture'DH_InterfaceArt2_tex.Artillery.dials_gradient_x'
    GradientOverlayY=Texture'DH_InterfaceArt2_tex.Artillery.dials_gradient_y'
}
