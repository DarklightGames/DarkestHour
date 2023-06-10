//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TriggerProjector extends Projector;

var(Projector)  color   ProjColorOn;      // the light color if the projector is on
var(Projector)  color   ProjColorOff;     // the light color if the projector is off
var(Projector)  color   ProjTintOn;       // these colors are overlaid over the projection
var(Projector)  color   ProjTintOff;      // alpha - grey will have no effect, white brightens & black darkens
var(Projector)  float   ChangeTime;       // time light takes to change from on to off
var(Projector)  bool    bInitiallyOn;     // whether it's initially on
var(Projector)  bool    bInitiallyFading; // whether it's initially fading up or down
var(Projector)  float   ChangeTimeTwo;

var protected ScriptedTexture ScriptTexture;
var     material    MaskTexture;
var     float       TimeSinceTriggered;
var     float       SwapTime;
var     color       CurrentColor;
var     color       CurrentTint;
var     bool        bIsOn;

replication
{
    // Variables the server will replicate to all clients
    reliable if (ROLE == ROLE_Authority)
        ScriptTexture;
}

simulated event PostBeginPlay()
{
    local texture TheProjTexture;
    local color   StartColor, StartTint;

    super.PostBeginPlay();

    // Allocate a new scripted texture from the pool & and have it call us for updates
    ScriptTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'Scriptedtexture'));
    ScriptTexture.SetSize(ProjTexture.MaterialUSize(), ProjTexture.MaterialVSize());
    ScriptTexture.Client = self;

    // Set the scripted texture properties to match those of the ProjTexture
    TheProjTexture = texture(ProjTexture);

    if (TheProjTexture != none)
    {
        ScriptTexture.UClampMode = TheProjTexture.UClampMode;
        ScriptTexture.VClampMode = TheProjTexture.VClampMode;
    }

    // Remember the given texture to use as a mask
    MaskTexture = ProjTexture;

    // Attach the texture to the displayed projector texture
    ProjTexture = ScriptTexture;

    // Work out the starting light color
    bIsOn = bInitiallyOn;

    // If we're on the client side, start in the right mode based on its trigger
    if (ROLE < ROLE_Authority && bClientTrigger)
    {
        bIsOn = !bIsOn;
    }

    if (bIsOn)
    {
        StartColor = ProjColorOn;
        StartTint = ProjTintOn;
    }
    else
    {
        StartColor = ProjColorOff;
        StartTint = ProjTintOff;
    }

    StartColor.A = 255;
    StartTint.A = 255;

    // Set the color
    SetColors(StartColor, StartTint);

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

simulated event Destroyed()
{
    // You should disconnect the object pool texture from everything you've assigned it to
    ProjTexture = none;

    // Clean up else you will leak resources
    assert(ScriptTexture != none);
    Level.ObjectPool.FreeObject(ScriptTexture);
    ScriptTexture = none;

    super.Destroyed();
}

simulated function SetColors(color NewColor, color NewTint)
{
    // Check to see if it's a new color
    if (CurrentColor != NewColor || CurrentTint != NewTint)
    {
        // Change the color & force an update of the scripted texture on the next frame that it's visible
        CurrentColor = NewColor;
        CurrentTint = NewTint;
        assert(ScriptedTexture(ProjTexture) != none);
        ++ScriptedTexture(ProjTexture).Revision;
    }
}

simulated event RenderTexture(ScriptedTexture Tex)
{
    assert(Tex == ProjTexture);

    Tex.DrawTile(0, 0, Tex.USize, Tex.VSize, 0, 0, Tex.USize, Tex.VSize, none, CurrentColor);
    Tex.DrawTile(0, 0, Tex.USize, Tex.VSize, 0, 0, Tex.USize, Tex.VSize, MaskTexture, CurrentTint);
}

simulated function Tick(float DeltaTime)
{
    local float Percent;
    local color NewColor, NewTint;

    TimeSinceTriggered += DeltaTime;
    Percent = TimeSinceTriggered / SwapTime;

    // If we're done with the fade, set to final color & leave
    if (Percent >= 1.0)
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
        NewColor.R = (Percent * ProjColorOn.R) + ((1.0 - Percent) * ProjColorOff.R);
        NewColor.G = (Percent * ProjColorOn.G) + ((1.0 - Percent) * ProjColorOff.G);
        NewColor.B = (Percent * ProjColorOn.B) + ((1.0 - Percent) * ProjColorOff.B);

        NewTint.R = (Percent * ProjTintOn.R) + ((1.0 - Percent) * ProjTintOff.R);
        NewTint.G = (Percent * ProjTintOn.G) + ((1.0 - Percent) * ProjTintOff.G);
        NewTint.B = (Percent * ProjTintOn.B) + ((1.0 - Percent) * ProjTintOff.B);
    }
    else
    {
        NewColor.R = (Percent * ProjColorOff.R) + ((1.0 - Percent) * ProjColorOn.R);
        NewColor.G = (Percent * ProjColorOff.G) + ((1.0 - Percent) * ProjColorOn.G);
        NewColor.B = (Percent * ProjColorOff.B) + ((1.0 - Percent) * ProjColorOn.B);

        NewTint.R = (Percent * ProjTintOff.R) + ((1.0 - Percent) * ProjTintOn.R);
        NewTint.G = (Percent * ProjTintOff.G) + ((1.0 - Percent) * ProjTintOn.G);
        NewTint.B = (Percent * ProjTintOff.B) + ((1.0 - Percent) * ProjTintOn.B);
    }

    NewColor.A = 255;
    NewTint.A = 255;

    SetColors(NewColor,NewTint);
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

    Enable('Tick');
    TimeSinceTriggered = 0.0;
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

    // This is called client-side when triggered server-side, because in Trigger() we updated bClientTrigger
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
    ProjColorOn=(B=255,G=255,R=255,A=255)
    ProjColorOff=(A=255)
    ProjTintOn=(B=128,G=128,R=128,A=255)
    ProjTintOff=(B=128,G=128,R=128,A=255)
    ChangeTime=60.0
    ChangeTimeTwo=0.001
    SwapTime=0.001
    bClipBSP=true
    bStatic=false
    bNoDelete=true
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bGameRelevant=true
}
