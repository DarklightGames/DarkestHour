//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanMountedMGPawn extends DHVehicleMGPawn;

// Modified so player's view rotation isn't matched to the MG's aiming direction, as he's aiming it through his periscope
// Note we could easily make it so periscope view is allowed to yaw with the MG, while preventing any view pitch, which would also be plausible
// But no need as fixed periscope view covers full firing range of MG, & anyway if co-driver is firing NG he can't realistically adjust his periscope
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    ViewActor = self;

    if (PC != none && Gun != none)
    {
        // Camera location simply offset from MG's location (where it is attached), plus any shake
        // Doesn't use a camera bone in MG mesh as relative camera rotation is fixed & matched to vehicle's facing direction
        CameraLocation = Gun.Location + ((FPCamPos + PC.ShakeOffset) >> Gun.Rotation);

        // Camera rotation simply matched to vehicle's facing direction (note Gun.Rotation is same as vehicle base), plus any shake
        CameraRotation = Normalize(Gun.Rotation + PC.ShakeRot);
    }
}

// Modified to use this function to draw the co-driver's periscope overlay, through which this MG is aimed
simulated function DrawGunsightOverlay(Canvas C)
{
    local float ScreenRatio;

    ScreenRatio = float(C.SizeY) / float(C.SizeX);
    C.SetPos(0.0, 0.0);

    C.DrawTile(GunsightOverlay, C.SizeX, C.SizeY,                           // screen drawing area (to fill screen)
        0.0, (1.0 - ScreenRatio) * float(GunsightOverlay.VSize) / 2.0,      // position in texture to begin drawing tile (from left edge, with vertical position to suit screen aspect ratio)
        GunsightOverlay.USize, float(GunsightOverlay.VSize) * ScreenRatio); // width & height of tile within texture
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_ShermanMountedMG'
    GunsightOverlay=texture'DH_VehicleOptics_tex.Allied.PERISCOPE_overlay_Allied' // not actually a gunsight, but this MG is aimed using co-driver's periscope
    WeaponFOV=90.0

//  This bow MG did not have a sight or even a peephole to aim through, & was instead aimed using co-driver's overhead periscope
//  Looking through that view (or while unbuttoned but that's not modelled in game), co-driver had to aim by walking tracers or round impacts onto target
//  Note that the first person camera position (set by FPCamPos) is not quite positioned where the co-driver's overhead periscope is
//  It's deliberately lowered slightly so the player can just see the MG barrel if he waggles it up
//  This is a small compromise so the player can check roughly which way his MG is facing before he begins to fire
//  Otherwise he has to open fire not knowing which way the gun is aimed, & only then can he correct the aim (so he may hit friendlies)
//  In real life he would know where the MG was pointing because he would be holding it in his hands
//  So this camera adjustment is just an effective form of substitute feedback about where the gun is pointing
    FPCamPos=(X=-5.0,Y=0.0,Z=9.0)
}
