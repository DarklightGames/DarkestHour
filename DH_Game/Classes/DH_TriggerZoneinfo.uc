//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TriggerZoneInfo extends ZoneInfo;

var() color OnColor;       // Color when light is on
var() color OffColor;      // Color when light is off

var() float ChangeTime;        // Time light takes to change from on to off.
var() bool  bInitiallyOn;      // Whether it's initially on.
var() bool  bInitiallyFading;  //    "     "   initially fading up or down.

var float     TimeSinceTriggered;
var bool      bIsOn;

var() float ChangeTimeTwo;
var float SwapTime;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    // Work out the starting light color:
    bIsOn = bInitiallyOn;

    // If we're on the client side, start in
    // the right mode based on its trigger:
    if (ROLE != ROLE_Authority && bClientTrigger)
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

simulated function Tick(float DeltaTime)
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

    // Just fade to the right level:
    if (bIsOn)
    {
            DistanceFogColor.R = percent * OnColor.R + (1-percent) * OffColor.R;
            DistanceFogColor.G = percent * OnColor.G + (1-percent) * OffColor.G;
            DistanceFogColor.B = percent * OnColor.B + (1-percent) * OffColor.B;
    }
    else
    {
            DistanceFogColor.R = percent * OffColor.R + (1-percent) * OnColor.R;
            DistanceFogColor.G = percent * OffColor.G + (1-percent) * OnColor.G;
            DistanceFogColor.B = percent * OffColor.B + (1-percent) * OnColor.B;
    }

}

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Log("ZoneInfo Triggered");
    Enable('Tick');
    TimeSinceTriggered = 0;
    bIsOn = !bIsOn;
    bClientTrigger = !bClientTrigger;

    if (bIsOn)
    {
        SwapTime = ChangeTime;
    }
    else
    {
        SwapTime = ChangeTimeTwo;
    }

}

simulated event ClientTrigger()
{
    // This is called client-side when triggered server-side
    // because in Trigger() we updated bClientTrigger.
    Log("Client ZoneInfo Triggered");
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
    ChangeTime=60.0
    ChangeTimeTwo=0.001
    SwapTime=0.001
    bStatic=false
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=false
    RemoteRole=ROLE_SimulatedProxy
    bGameRelevant=true
}
