//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShadowProjector extends ShadowProjector;

var     float       ShadowZOffset; // vertical position offset for shadow, replacing literal value that's hard-coded into UpdateShadow() in ShadowProjector parent class
                                   // allows a vehicle shadow position to be adjusted to suit the vehicle to produce a good shadow

// Modified to set shadow rotation initially, as it never changes so we no longer update it every tick in UpdateShadow()
function InitShadow()
{
    super.InitShadow();

    SetRotation(rotator(Normal(-LightDirection)));
}

// Modified to use ShadowZOffset for the vertical position offset for shadow, instead of a hard-coded literal (was +5)
// Allows vehicles to be tuned for a good shadow position, as hull mesh origin position affects vehicle actor location relative to the ground, affecting shadow location
// Also removed a couple of things for efficiency, as this is called every tick:
// No longer update shadow rotation, as it never changes, so we now do it once in InitShadow(), & removed the RootMotion block as it's never true
function UpdateShadow()
{
    local vector ShadowLocation;

    DetachProjector(true);

    if (ShadowActor != none && !ShadowActor.bHidden && (Level.TimeSeconds - ShadowActor.LastRenderTime) < 4.0 && ShadowTexture != none && bShadowActive)
    {
        if (ShadowTexture.Invalid)
        {
            Destroy();
        }
        else
        {
            // Update shadow location, now using ShadowZOffset
            ShadowLocation = ShadowActor.Location;
            ShadowLocation.Z += ShadowZOffset;
            SetLocation(ShadowLocation);

            ShadowTexture.Dirty = true;

            AttachProjector();
        }
    }
}

defaultproperties
{
    ShadowZOffset=5.0 // the literal value that was hard-coded into UpdateShadow() in the ShadowProjector parent class (vehicle's can override this)
}
