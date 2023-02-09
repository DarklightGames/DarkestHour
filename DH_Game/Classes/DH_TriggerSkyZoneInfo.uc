//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TriggerSkyZoneInfo extends SkyZoneInfo;

var()   color   OnColor;          // color when light is on
var()   color   OffColor;         // color when light is off
var()   float   ChangeTime;       // time light takes to change from on to off
var()   bool    bInitiallyOn;     // whether it's initially on
var()   bool    bInitiallyFading; // whether it's initially fading up or down

var     float   TimeSinceTriggered;
var     bool    bIsOn;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    // Work out the starting light color
    bIsOn = bInitiallyOn;

    if (ROLE < ROLE_Authority && bClientTrigger) // if we're on the client side, start in the right mode based on its trigger
    {
        bIsOn = !bIsOn;
    }

    if (bIsOn)
    {
        DistanceFogColor = OnColor;
    }
    else
    {
        DistanceFogColor = OffColor;
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

simulated function Tick(float DeltaTime)
{
    local float Percent;

    TimeSinceTriggered += DeltaTime;
    Percent = TimeSinceTriggered / ChangeTime;

    // If we're done with the fade, set to final color & leave
    if (Percent >= 1.0)
    {
        Disable('Tick');

        if (bIsOn)
        {
            DistanceFogColor.R = OnColor.R;
            DistanceFogColor.G = OnColor.G;
            DistanceFogColor.B = OnColor.B;
        }
        else
        {
            DistanceFogColor.R = OffColor.R;
            DistanceFogColor.G = OffColor.G;
            DistanceFogColor.B = OffColor.B;
        }

        return;
    }

    // Just fade to the right level
    if (bIsOn)
    {
        DistanceFogColor.R = (Percent * OnColor.R) + ((1.0 - Percent) * OffColor.R);
        DistanceFogColor.G = (Percent * OnColor.G) + ((1.0 - Percent) * OffColor.G);
        DistanceFogColor.B = (Percent * OnColor.B) + ((1.0 - Percent) * OffColor.B);
    }
    else
    {
        DistanceFogColor.R = (Percent * OffColor.R) + ((1.0 - Percent) * OnColor.R);
        DistanceFogColor.G = (Percent * OffColor.G) + ((1.0 - Percent) * OnColor.G);
        DistanceFogColor.B = (Percent * OffColor.B) + ((1.0 - Percent) * OnColor.B);
    }
}

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Enable('Tick');
    TimeSinceTriggered = 0.0;
    bIsOn = !bIsOn;
    bClientTrigger = !bClientTrigger;
}

// This is called client-side when triggered server-side, because in Trigger() we updated bClientTrigger
simulated event ClientTrigger()
{
    Enable('Tick');
    TimeSinceTriggered = 0.0;
    bIsOn = !bIsOn;
}

simulated function Reset() // TODO: fix
{
    super.Reset();
}

defaultproperties
{
    OnColor=(B=16,G=88,R=112,A=255)
    OffColor=(B=48,G=24,R=16,A=255)
    ChangeTime=10.0
    bStatic=false
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=false
    bGameRelevant=true
}
