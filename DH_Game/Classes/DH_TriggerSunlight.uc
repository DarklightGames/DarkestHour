//=============================================================================
// class TriggerSunlight
// A dynamic Sunlight that can be triggered to fade between two levels.
//=============================================================================

class DH_TriggerSunlight extends Sunlight
	hidecategories(Emitter,Force,Karma,Corona);

//-----------------------------------------------------------------------------
// Variables.
var() color OnColor;       // Color when sunlight is on
var() color OffColor;      // Color when light is off

var() float ChangeTime;        // Time light takes to change from on to off.
var() bool  bInitiallyOn;      // Whether it's initially on.
var() bool  bInitiallyFading;  //    "     "   initially fading up or down.

var color   CurrentColor;
var float   TimeSinceTriggered;
var bool    bIsOn;

var() float ChangeTimeTwo;
var float SwapTime;

//-----------------------------------------------------------------------------
// Methods.

event PostBeginPlay()
{
   	Super.PostBeginPlay();

   	// Work out the starting light color:
   	bIsOn = bInitiallyOn;
   	if (bIsOn)
	{
      		RGBSetColor(OnColor);
	}
	else
	{
      		RGBSetColor(OffColor);
   	}

   	// If we're fading, we tick:
   	if (bInitiallyFading)
	{
      		Enable('Tick');
      		bIsOn = !bIsOn;
   	}
   	// Otherwise we don't tick:
   	else
	{
      		Disable('Tick');
   	}
}

function Tick( float DeltaTime )
{
   	local float percent;

   	TimeSinceTriggered += DeltaTime;
   	percent = TimeSinceTriggered / SwapTime;

   	// If we're done with the fade, set to final color and leave:
   	if (percent >= 1)
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

   	// Just fade to the right level:
   	if (bIsOn)
	{
      		CurrentColor.R = percent * OnColor.R + (1-percent) * OffColor.R;
      		CurrentColor.G = percent * OnColor.G + (1-percent) * OffColor.G;
      		CurrentColor.B = percent * OnColor.B + (1-percent) * OffColor.B;
   	}
   	else
	{
      		CurrentColor.R = percent * OffColor.R + (1-percent) * OnColor.R;
      		CurrentColor.G = percent * OffColor.G + (1-percent) * OnColor.G;
      		CurrentColor.B = percent * OffColor.B + (1-percent) * OnColor.B;
   	}

   	// Convert the current color from RGB to HSL:
   	RGBSetColor( CurrentColor );
}

simulated function RGBSetColor(color inRGB)
{
    local vector RGB, HLS;

    RGB.X = inRGB.R / 255.0;
    RGB.Y = inRGB.G / 255.0;
    RGB.Z = inRGB.B / 255.0;
    HLS = colourmap(RGB);

    LightHue = HLS.X;
    LightBrightness = HLS.Y;
    LightSaturation = HLS.Z;
}

// Function ColorMap - code courtesy of DWeather by
// Mazerium, from the file: DWParent.uc
simulated function vector ColourMap ( vector rgb)
 {
  local float min;
  local float max;
  local vector hls;
  local float r,g,b,h,l,s;

  rgb.x= Fclamp(rgb.x,0,1);
  rgb.y= Fclamp(rgb.y,0,1);
  rgb.z= Fclamp(rgb.z,0,1);

  r=rgb.x;
  g=rgb.y;
  b=rgb.z;

  max = Fmax(fmax(r,g),b);
  min = Fmin(Fmin(r,g),b);

  l = (max+min)/2;

  if (max==min)
   {
     s = 0;
     h = 0;
   }
  else
   {
    if (l < 0.5)  s =(max-min)/(max+min);
    If (l >=0.5)  s =(max-min)/(2.0-max-min);
   }

  If (R == max)  h  = (G-B)/(max-min);
  If (G == max) h = 2.0 + (B-R)/(max-min);
  If (B == max)    h = 4.0 + (R-G)/(max-min);

  hls.x=(h/6)*255;
  hls.y=(l*255);
  hls.z=(255-s*255);

  return( hls);
}

function Trigger( Actor Other, Pawn EventInstigator )
{
   	Enable('Tick');
   	TimeSinceTriggered = 0;
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

simulated function Reset()
{
	super.Reset();

	//TODO: Fix.
}

defaultproperties
{
     OnColor=(B=16,G=88,R=112,A=255)
     OffColor=(B=48,G=24,R=16,A=255)
     ChangeTime=60.000000
     ChangeTimeTwo=0.001000
     SwapTime=0.001000
     bStatic=False
     bDynamicLight=True
     bAlwaysRelevant=True
}
