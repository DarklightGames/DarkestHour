//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LocustGunsightOverlay extends VehicleHUDOverlay;

var     ScriptedTexture TelescopeScriptedTexture;  // a scripted texture that the magnified telescope view is drawn onto
var     int             TelescopeFOV;              // the FOV of the telescope 'portal' to create a magnified telescope view

// Implemented to set up the scripted texture & combiner for drawing the magnified telescope 'portal' view, & to set the overlay's size
simulated function PostBeginPlay()
{
    local DHVehicleCannonPawn CannonPawn;

    CannonPawn = DHVehicleCannonPawn(Owner);

    if (CannonPawn != none && CannonPawn.IsLocallyControlled() && CannonPawn.IsHumanControlled())
    {
        // Match overlay's DrawScale to match cannon pawn's GunsightSize
        SetDrawScale(CannonPawn.GunsightSize);

        // Make a scripted texture, which will display a zoomed 'portal' view for the telescope mounted within the Locust's persicopic gunsight
        TelescopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
        TelescopeScriptedTexture.SetSize(CannonPawn.GunsightOverlay.MaterialUSize(), CannonPawn.GunsightOverlay.MaterialVSize());
        TelescopeScriptedTexture.Client = self; // means this actor receives RenderTexture() events from the scripted texture

        // Now combine the scripted texture for the portal view with the gunsight texture, & set that as our telescope skin
        Skins[0] = CannonPawn.GunsightOverlay;
        Combiner(Skins[0]).Material2 = TelescopeScriptedTexture;
     }
}

// Implemented to clean up objects that have been created
simulated function Destroyed()
{
    Combiner(Skins[0]).Material2 = none;

    if (TelescopeScriptedTexture != none)
    {
        TelescopeScriptedTexture.Client = none;
        Level.ObjectPool.FreeObject(TelescopeScriptedTexture);
        TelescopeScriptedTexture = none;
    }

    super.Destroyed();
}

// Implemented to make the scripted texture update the telescope view every frame, by incrementing its Revision counter
// This function is called from the cannon pawn's DrawHUD() function
// Note this doesn't have to be done in this function, but it's just convenient as it's an Actor function, so the cannon pawn can call it without casting
simulated function RenderOverlays(Canvas C)
{
    if (TelescopeScriptedTexture != none)
    {
        TelescopeScriptedTexture.Client = self; // need to set here (every frame, not just once) because this can get corrupted - as per Ramm in ROSniperWeapon class
        TelescopeScriptedTexture.Revision++;
    }
}

// Implemented to draw the updated scripted texture showing the telescope 'portal' view
// This functions is called natively by the scripted texture each frame it updates the view
// It's caused by incrementing the texture's Revision counter & this function gets called on the actor that is set as the texture's Client
simulated function RenderTexture(ScriptedTexture Tex)
{
    if (Owner != none && Tex != none)
    {
        Tex.DrawPortal(0, 0, Tex.USize, Tex.VSize, Owner, Location, Rotation, TelescopeFOV);
    }
}

// New function to update the telescope 'portal' with the damaged sight texture, if the gunsight gets damaged
simulated function DamageGunsightOverlay(Texture DestroyedGunsightOverlay)
{
    if (DestroyedGunsightOverlay != none)
    {
        Combiner(Skins[0]).Material1 = DestroyedGunsightOverlay;
        Combiner(Skins[0]).FallbackMaterial = DestroyedGunsightOverlay;
    }
}

defaultproperties
{
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_allies_vehicles_stc2.Locust.Locust_GunsightOverlay'
    Skins(1)=Texture'DH_Locust_tex.Locust_int'
    TelescopeFOV=9 // by experimentation & screen measurement, gives desired 1.8x magnification in telescope portal combined with visible screen size of overlay mesh
}
