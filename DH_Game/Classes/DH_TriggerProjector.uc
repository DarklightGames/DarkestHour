//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_TriggerProjector extends Projector;

var(Projector) Color ProjColorOn;       // The light color if the projector is on.
var(Projector) Color ProjColorOff;      //  "    "     "   if the projector is off.
var(Projector) Color ProjTintOn;        // These colors are overlaid over the projection
var(Projector) Color ProjTintOff;       // alpha.  Grey will have no effect, white
                                        // brightens and black darkens.
var(Projector) float ChangeTime;        // Time light takes to change from on to off.
var(Projector) bool  bInitiallyOn;      // Whether it's initially on.
var(Projector) bool  bInitiallyFading;  //    "     "   initially fading up or down.

var float     TimeSinceTriggered;
var Color     CurrentColor;
var Color     CurrentTint;
var bool      bIsOn;
var protected ScriptedTexture ScriptTexture;
var Material  MaskTexture;

var(Projector) float ChangeTimeTwo;
var float SwapTime;

replication
{
    reliable if (ROLE == ROLE_Authority)
                ScriptTexture;
}

simulated event PostBeginPlay()
{
    local Color startColor;
    local Color startTint;
    local Texture theProjTexture;

    super.PostBeginPlay();

    // Allocate a new scripted texture from the pool
    // and have it call us for updates.
    ScriptTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
    ScriptTexture.SetSize(ProjTexture.MaterialUSize(), ProjTexture.MaterialVSize());
    ScriptTexture.Client = self;

    // Set the scripted texture properties to
    // match those of the ProjTexture:
    theProjTexture = Texture(ProjTexture);
    if (theProjTexture != none)
    {
            ScriptTexture.UClampMode = theProjTexture.UClampMode;
            ScriptTexture.VClampMode = theProjTexture.VClampMode;
    }

    // Remember the given texture to use as a mask:
    MaskTexture = ProjTexture;

    // Attach the texture to the displayed projector texture:
    ProjTexture = ScriptTexture;

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
            startColor = ProjColorOn;
            startTint = ProjTintOn;
    }
    else
    {
            startColor = ProjColorOff;
            startTint = ProjTintOff;
    }
    startColor.A = 255;
    startTint.A = 255;

    // Set the color:
    SetColors(startColor, startTint);

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

simulated event Destroyed()
{
    // You should disconnect the object
    // pool texture from everything you've
    // assigned it to.
    ProjTexture = none;

    // Clean up else you will leak resources.
    assert(ScriptTexture != none);
    Level.ObjectPool.FreeObject(ScriptTexture);
    ScriptTexture = none;

    super.Destroyed();
}

simulated function SetColors(Color NewColor, Color NewTint)
{
    // Check to see if it's a new color:
    if ((CurrentColor == NewColor) && (CurrentTint == NewTint))
            return;

    // Change the color and force an update
    // of the scripted texture on the next
    // frame that it's visible.
    CurrentColor = NewColor;
    CurrentTint = NewTint;
    assert(ScriptedTexture(ProjTexture) != none);
    ++ScriptedTexture(ProjTexture).Revision;

}

simulated event RenderTexture(ScriptedTexture Tex)
{
    assert(Tex == ProjTexture);

    Tex.DrawTile(0,0,Tex.USize,Tex.VSize,0,0,Tex.USize,Tex.VSize,none,CurrentColor);
    Tex.DrawTile(0,0,Tex.USize,Tex.VSize,0,0,Tex.USize,Tex.VSize,MaskTexture,CurrentTint);
}

simulated function Tick(float DeltaTime)
{
    local float percent;
    local Color newColor;
    local Color newTint;

    TimeSinceTriggered += DeltaTime;
    percent = TimeSinceTriggered / SwapTime;

    // If we're done with the fade, set to final color and leave:
    if (percent >= 1)
    {
            Disable('Tick');
            if (bIsOn)
        {
                SetColors(ProjColorOn, ProjTintOn);
        }
            else
        {
                SetColors(ProjColorOff, ProjTintOff);
        }

            return;
    }

    // Just fade to the right level:
    if (bIsOn)
    {
            newColor.R = percent * ProjColorOn.R + (1-percent) * ProjColorOff.R;
            newColor.G = percent * ProjColorOn.G + (1-percent) * ProjColorOff.G;
            newColor.B = percent * ProjColorOn.B + (1-percent) * ProjColorOff.B;

            newTint.R = percent * ProjTintOn.R + (1-percent) * ProjTintOff.R;
            newTint.G = percent * ProjTintOn.G + (1-percent) * ProjTintOff.G;
            newTint.B = percent * ProjTintOn.B + (1-percent) * ProjTintOff.B;
    }
    else
    {
            newColor.R = percent * ProjColorOff.R + (1-percent) * ProjColorOn.R;
            newColor.G = percent * ProjColorOff.G + (1-percent) * ProjColorOn.G;
            newColor.B = percent * ProjColorOff.B + (1-percent) * ProjColorOn.B;

            newTint.R = percent * ProjTintOff.R + (1-percent) * ProjTintOn.R;
            newTint.G = percent * ProjTintOff.G + (1-percent) * ProjTintOn.G;
            newTint.B = percent * ProjTintOff.B + (1-percent) * ProjTintOn.B;
    }
    newColor.A = 255;
    newTint.A = 255;

    SetColors(newColor,newTint);
}

simulated function Trigger(Actor Other, Pawn EventInstigator)
{

    if (bIsOn)
    {
        SwapTime = ChangeTime;
    }
    else
    {
        SwapTime = ChangeTimeTwo;
    }

    Log("Projector Triggered");
    Enable('Tick');
    TimeSinceTriggered = 0;
    bIsOn = !bIsOn;
    bClientTrigger = !bClientTrigger;
}

simulated event ClientTrigger()
{

    if (bIsOn)
    {
        SwapTime = ChangeTime;
    }
    else
    {
        SwapTime = ChangeTimeTwo;
    }

    // This is called client-side when triggered server-side
    // because in Trigger() we updated bClientTrigger.
    Log("Client Projector Triggered");
    Enable('Tick');
    TimeSinceTriggered = 0;
    bIsOn = !bIsOn;
}

simulated function Reset()
{
    super.Reset();

    //TODO: Fix.
}

defaultproperties
{
     ProjColorOn=(B=255,G=255,R=255,A=255)
     ProjColorOff=(A=255)
     ProjTintOn=(B=128,G=128,R=128,A=255)
     ProjTintOff=(B=128,G=128,R=128,A=255)
     ChangeTime=60.000000
     ChangeTimeTwo=0.001000
     SwapTime=0.001000
     bClipBSP=true
     bStatic=false
     bNoDelete=true
     bAlwaysRelevant=true
     RemoteRole=ROLE_SimulatedProxy
     bGameRelevant=true
}
