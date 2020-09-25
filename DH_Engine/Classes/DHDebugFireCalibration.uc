//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================
// This actor used for calibrating artillery guns, etc.

class DHDebugFireCalibration extends Actor;

enum EUnits
{
    UNIT_Mil,
    UNIT_Degree,
};

struct SProjectileInfo
{
    var DHBallisticProjectile Projectile;
    var float                 Pitch;
    var bool                  bRecorded;
};

struct SDataPoint
{
    var float Range;
    var float Pitch;
};

var array<SProjectileInfo>       ProjectileInfos;
var array<SDataPoint>            RangeData;
var InterpCurve                  LowArcCurve;
var InterpCurve                  HighArcCurve;
var vector                       StartingLocation;
var bool                         bDataCollectionComplete;
var bool                         bVerbose;

// TODO:
// Diffence in elevation between start and hit locations can throw off the
// calibration. We can set threshold to get rid of faulty points.
// Normally starting location will be slightly elevated above the ground.
var float              ElevationErrorThreshold;
var int                ErrorCount;

// Range table output
var float              RangeStep; // In unreal units.
var float              PitchStep; // Step of the gun tranverse, pitch values
                                  // will be rounded to this value (important
                                  // for mortars).
var EUnits             PitchUnit;

function PostBeginPlay()
{
    SetTimer(10, false);
}

event Timer()
{
    local int i;

    // TODO:
    // Periodically check for rounds that might have flew over the level edge.
    for (i = 0; i < ProjectileInfos.Length; ++i)
    {
        if (!ProjectileInfos[i].bRecorded &&
            ProjectileInfos[i].Projectile != none &&
            ProjectileInfos[i].Projectile.Location.Z + 6035 < StartingLocation.Z &&
            RangeData.Length + ++ErrorCount >= ProjectileInfos.Length &&
            BuildCurve())
        {
            PrintRangeTable();
            return;
        }
    }
}

function AddProjectile(DHBallisticProjectile Projectile, float Pitch)
{
    local SProjectileInfo PI;

    PI.Projectile = Projectile;
    PI.Pitch = Pitch;

    ProjectileInfos[ProjectileInfos.Length] = PI;
}

function RecordDataPoint(DHBallisticProjectile Projectile)
{
    local vector V;

    if (bDataCollectionComplete ||
        Projectile == none ||
        Projectile.DebugIndex < 0 ||
        Projectile.DebugIndex >= ProjectileInfos.Length)
    {
        return;
    }

    V = Projectile.Location - StartingLocation;

    // Throw away a faulty data point
    if (ElevationErrorThreshold > 0 &&
        V.Z >= ElevationErrorThreshold)
    {
        ++ErrorCount;
        return;
    }

    V.Z = 0.0;

    RangeData.Insert(RangeData.Length, 1);
    RangeData[RangeData.Length - 1].Range = VSize(V);
    RangeData[RangeData.Length - 1].Pitch = ProjectileInfos[Projectile.DebugIndex].Pitch;

    ProjectileInfos[Projectile.DebugIndex].bRecorded = true;

    // Did we get all of them?
    if (RangeData.Length + ErrorCount >= ProjectileInfos.Length &&
        BuildCurve())
    {
        PrintRangeTable();
    }
}

function bool BuildCurve()
{
    local int i, HighestRangeIndex;
    local InterpCurvePoint ICPoint;
    local bool bIncludeHighestRange;

    if (RangeData.Length <= 0)
    {
        Log("No data to build the curve from");
        return false;
    }

    Log("DATA POINTS:" @ RangeData.Length);

    // Find maximum point
    for (i = 1; i < RangeData.Length; ++i)
    {
        if (RangeData[i].Range > RangeData[HighestRangeIndex].Range)
        {
            HighestRangeIndex = i;
        }
    }

    Log("EXTREME:" @ HighestRangeIndex);

    // Low arc
    if (HighestRangeIndex > 0)
    {
        for (i = 0; i <= HighestRangeIndex; ++i)
        {
            if (i > 0 && RangeData[i].Range <= RangeData[i-1].Range)
            {
                ++ErrorCount;
                continue;
            }

            ICPoint.InVal = RangeData[i].Range;
            ICPoint.OutVal = RangeData[i].Pitch;
            LowArcCurve.Points[LowArcCurve.Points.Length] = ICPoint;
        }

        Log("LOW ARC DATA POINTS:" @ LowArcCurve.Points.Length);
    }
    else
    {
        bIncludeHighestRange = true;
    }

    // High arc
    for (i = RangeData.Length - 1; i + int(bIncludeHighestRange) > HighestRangeIndex; --i)
    {
        if (i < RangeData.Length - 1 && RangeData[i].Range <= RangeData[i+1].Range)
        {
            ++ErrorCount;
            continue;
        }

        ICPoint.InVal = RangeData[i].Range;
        ICPoint.OutVal = RangeData[i].Pitch;
        HighArcCurve.Points[HighArcCurve.Points.Length] = ICPoint;
    }

    Log("HIGH ARC DATA POINTS:" @ HighArcCurve.Points.Length);

    return true;
}

function float GetHumanReadableAngle(float UnrealValue)
{
    switch (PitchUnit)
    {
        case UNIT_Degree:
            return class'UUnits'.static.UnrealToDegrees(UnrealValue);
        deafult:
            return class'DHUnits'.static.UnrealToMilliradians(UnrealValue);
    }
}

function PrintRangeCurve()
{
    local int i;

    bDataCollectionComplete = true;

    Log("==== LOW ARC INTERPCURVE BEGIN ====");

    for (i = 0; i < LowArcCurve.Points.Length; ++i)
    {
        Log("InVal=" $ LowArcCurve.Points[i].InVal @ ", OutVal=" $ LowArcCurve.Points[i].OutVal);
    }

    Log("==== LOW ARC INTERPCURVE END  ====");
    Log("==== HIGH ARC INTERPCURVE BEGIN ====");

    for (i = 0; i < HighArcCurve.Points.Length; ++i)
    {
        Log("InVal=" $ HighArcCurve.Points[i].InVal @ ", OutVal=" $ HighArcCurve.Points[i].OutVal);
    }

    Log("==== HIGH ARC INTERPCURVE END  ====");
}

function PrintRangeTable()
{
    local float Range, MinRange, MaxRange, HumanLowArcPitch, HumanHighArcPitch, HumanPitchStep, HighArcMinRange;
    local string PitchUnitString;
    local array<SDataPoint> LowArcTable, HighArcTable;

    if (LowArcCurve.Points.Length <= 0 &&
        HighArcCurve.Points.Length <= 0)
    {
        return;
    }

    if (bVerbose)
    {
        PrintRangeCurve();
    }

    if (LowArcCurve.Points.Length > 0)
    {
        MaxRange = LowArcCurve.Points[LowArcCurve.Points.Length - 1].InVal;
        MinRange = LowArcCurve.Points[0].InVal + RangeStep - LowArcCurve.Points[0].InVal % RangeStep;
    }

    if (HighArcCurve.Points.Length > 0)
    {
        if (LowArcCurve.Points.Length <= 0 ||
            MaxRange < HighArcCurve.Points[HighArcCurve.Points.Length - 1].InVal)
        {
            MaxRange = HighArcCurve.Points[HighArcCurve.Points.Length - 1].InVal;
        }

        HighArcMinRange = HighArcCurve.Points[0].InVal + RangeStep - HighArcCurve.Points[0].InVal % RangeStep;

        if (LowArcCurve.Points.Length <= 0 || MinRange > HighArcMinRange)
        {
            MinRange = HighArcMinRange;
        }
    }

    switch (PitchUnit)
    {
        case UNIT_Degree:
            PitchUnitString = "Degrees";
            break;
        default:
            PitchUnitString = "Mils";
    }

    Log("RANGE:" @
        class'DHUnits'.static.UnrealToMeters(MinRange) $
        "-" $
        class'DHUnits'.static.UnrealToMeters(MaxRange - MaxRange % RangeStep) @
        "@" @
        class'DHUnits'.static.UnrealToMeters(RangeStep) @
        "Meters");

    HumanPitchStep = GetHumanReadableAngle(PitchStep);

    Log("PITCH UNIT:" @ PitchUnitString);
    Log("ROUND PITCH TO:" @ HumanPitchStep);

    if (ErrorCount > 0)
    {
        Log("ERRORS:" @ ErrorCount);
        Log("ELEVATION ERROR THRESHOLD:" @ ElevationErrorThreshold);
    }

    for (Range = MinRange; Range <= MaxRange; Range += RangeStep)
    {
        HumanLowArcPitch = GetHumanReadableAngle(InterpCurveEval(LowArcCurve, Range));
        Log(Range @ "@" @ HumanLowArcPitch);
        HumanHighArcPitch = GetHumanReadableAngle(InterpCurveEval(HighArcCurve, Range));

        if (HumanPitchStep != 0.0)
        {
            // Round up to the nearest step.
            if (HumanLowArcPitch != 0.0)
            {
                HumanLowArcPitch = Round(HumanLowArcPitch / HumanPitchStep) * HumanPitchStep;
            }

            if (HumanHighArcPitch != 0.0)
            {
                HumanHighArcPitch = Round(HumanHighArcPitch / HumanPitchStep) * HumanPitchStep;
            }
        }

        LowArcTable.Insert(LowArcTable.Length, 1);
        LowArcTable[LowArcTable.Length - 1].Range = class'DHUnits'.static.UnrealToMeters(Range);
        LowArcTable[LowArcTable.Length - 1].Pitch = HumanLowArcPitch;

        HighArcTable.Insert(HighArcTable.Length, 1);
        HighArcTable[HighArcTable.Length - 1].Range = class'DHUnits'.static.UnrealToMeters(Range);
        HighArcTable[HighArcTable.Length - 1].Pitch = HumanHighArcPitch;
    }

    if (LowArcTable.Length > 0)
    {
        Log("==== LOW ARC FIRING TABLE BEGIN ====");
        LogOutputTable(LowArcTable);
        Log("==== LOW ARC FIRING TABLE END   ====");
    }

    if (HighArcTable.Length > 0)
    {
        Log("==== HIGH ARC FIRING TABLE BEGIN ====");
        LogOutputTable(HighArcTable);
        Log("==== HIGH ARC FIRING TABLE END   ====");
    }

    Destroy();
}

function LogOutputTable(out array<SDataPoint> A)
{
    local int i;

    for (i = 0; i < A.Length; ++i)
    {
        Log("RangeTable(" $
            i $
            ")=(Range=" $
            A[i].Range $
            ",Pitch=" $
            A[i].Pitch $
            ")");
    }
}

defaultproperties
{
    bHidden=true
}
