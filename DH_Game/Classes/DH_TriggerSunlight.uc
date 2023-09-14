//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TriggerSunlight extends Sunlight
    hidecategories(Emitter,Force,Karma,Corona);

var()   color   OnColor;          // color when sunlight is on
var()   color   OffColor;         // color when light is off
var()   float   ChangeTime;       // time light takes to change from on to off
var()   float   ChangeTimeTwo;
var()   bool    bInitiallyOn;     // whether it's initially on
var()   bool    bInitiallyFading; // whether it's initially fading up or down

var     color   CurrentColor;
var     float   TimeSinceTriggered;
var     float   SwapTime;
var     bool    bIsOn;

event PostBeginPlay()
{
    super.PostBeginPlay();

    // Work out the starting light color
    bIsOn = bInitiallyOn;

    if (bIsOn)
    {
        RGBSetColor(OnColor);
    }
    else
    {
        RGBSetColor(OffColor);
    }

    // We only tick if we're fading
    if (bInitiallyFading)
    {
        Enable('Tick');
        bIsOn = !bIsOn;
    }
    else
    {
        Disable('Tick');
    }
}

function Tick(float DeltaTime)
{
    local float Percent;

    TimeSinceTriggered += DeltaTime;
    Percent = TimeSinceTriggered / SwapTime;

    // If we're done with the fade, set to final color & leave
    if (Percent >= 1.0)
    {
        Disable('Tick');

        if (bIsOn)
        {
            CurrentColor.R = OnColor.R;
            CurrentColor.G = OnColor.G;
            CurrentColor.B = OnColor.B;
        }
        else
        {
            CurrentColor.R = OffColor.R;
            CurrentColor.G = OffColor.G;
            CurrentColor.B = OffColor.B;
        }

        return;
    }

    // Just fade to the right level
    if (bIsOn)
    {
        CurrentColor.R = (Percent * OnColor.R) + ((1.0 - Percent) * OffColor.R);
        CurrentColor.G = (Percent * OnColor.G) + ((1.0 - Percent) * OffColor.G);
        CurrentColor.B = (Percent * OnColor.B) + ((1.0 - Percent) * OffColor.B);
    }
    else
    {
        CurrentColor.R = (Percent * OffColor.R) + ((1.0 - Percent) * OnColor.R);
        CurrentColor.G = (Percent * OffColor.G) + ((1.0 - Percent) * OnColor.G);
        CurrentColor.B = (Percent * OffColor.B) + ((1.0 - Percent) * OnColor.B);
    }

    // Convert the current color from RGB to HSL
    RGBSetColor(CurrentColor);
}

simulated function RGBSetColor(color inRGB)
{
    local vector RGB, HLS;

    RGB.X = inRGB.R / 255.0;
    RGB.Y = inRGB.G / 255.0;
    RGB.Z = inRGB.B / 255.0;
    HLS = ColourMap(RGB);

    LightHue = HLS.X;
    LightBrightness = HLS.Y;
    LightSaturation = HLS.Z;
}

// Function ColorMap - code courtesy of DWeather by Mazerium, from the file DWParent.uc
simulated function vector ColourMap(vector RGB)
{
    local float  Min, Max, R, G, B, H, L, S;
    local vector HLS;

    RGB.X = FClamp(RGB.X, 0.0, 1.0);
    RGB.Y = FClamp(RGB.Y, 0.0, 1.0);
    RGB.Z = FClamp(RGB.Z, 0.0, 1.0);

    R = RGB.X;
    G = RGB.Y;
    B = RGB.Z;

    Max = FMax(FMax(R, G), B);
    Min = FMin(FMin(R, G), B);

    L = (Max + Min) / 2.0;

    if (Max == Min)
    {
        S = 0.0;
        H = 0.0;
    }
    else
    {
        if (L < 0.5)
        {
            S = (Max - Min) / (Max + Min);
        }

        if (L >= 0.5)
        {
            S = (Max - Min) / (2.0 - Max - Min);
        }
    }

    if (R == Max)
    {
        H  = (G - B) / (Max - Min);
    }

    if (G == Max)
    {
        H = 2.0 + ((B - R) / (Max - Min));
    }

    if (B == Max)
    {
        H = 4.0 + ((R - G) / (Max - Min));
    }

    HLS.X = H / 6.0 * 255.0;
    HLS.Y = L * 255.0;
    HLS.Z = 255.0 - (S * 255.0);

    return(HLS);
}

function Trigger(Actor Other, Pawn EventInstigator)
{
    Enable('Tick');
    TimeSinceTriggered = 0.0;
    bIsOn = !bIsOn;

    if (bIsOn)
    {
        SwapTime = ChangeTime;
    }
    else
    {
        SwapTime = ChangeTimeTwo;
    }
}

simulated function Reset() // TODO: fix
{
    super.Reset();
}

defaultproperties
{
    OnColor=(B=16,G=88,R=112,A=255)
    OffColor=(B=48,G=24,R=16,A=255)
    ChangeTime=60.0
    ChangeTimeTwo=0.001
    SwapTime=0.001
    bStatic=false
    bDynamicLight=true
    bAlwaysRelevant=true
}
