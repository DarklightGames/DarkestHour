//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanMountedMGPawn extends DHVehicleMGPawn;

// Modified so player's view rotation isn't matched to the MG's aiming direction, as he's aiming it through his periscope
// Note we could easily make it so periscope view is allowed to yaw with the MG, while preventing any view pitch, which would also be plausible
// But no need as fixed periscope view covers full firing range of MG, & anyway if co-driver is firing MG he can't realistically adjust his periscope
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

// Modified to draw pericope texture over the mesh gun overlay
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local vector           GunOffset;
    local float            SavedOpacity;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (!bMultiPosition || (DriverPositions[DriverPositionIndex].bDrawOverlays && (!IsInState('ViewTransition') || DriverPositions[LastPositionIndex].bDrawOverlays)))
        {
            // Draw any gun HUD overlay
            if (HUDOverlay != none && DriverPositionIndex != BinocPositionIndex)
            {
                if (!Level.IsSoftwareRendering())
                {
                    GunOffset = HUDOverlayOffset + (PC.ShakeOffset * FirstPersonGunShakeScale);

                    // This makes the first person gun appear lower if player raises his head above the gun
                    if (FirstPersonGunRefBone != '' && Gun != none)
                    {
                        GunOffset.Z += (Gun.GetBoneCoords(FirstPersonGunRefBone).Origin.Z - PC.CalcViewLocation.Z) * FirstPersonOffsetZScale;
                    }

                    HUDOverlay.SetLocation(PC.CalcViewLocation);
                    C.DrawBoundActor(HUDOverlay, false, true, HUDOverlayFOV, PC.CalcViewRotation, PC.ShakeRot * FirstPersonGunShakeScale, -GunOffset);
                }
            }

            // Draw any texture overlay
            if (!PC.bBehindView)
            {
                // Save current HUD opacity & then set up for drawing overlays
                SavedOpacity = C.ColorModulate.W;
                C.ColorModulate.W = 1.0;
                C.DrawColor.A = 255;
                C.Style = ERenderStyle.STY_Alpha;

                if (DriverPositionIndex == BinocPositionIndex)
                {
                    DrawBinocsOverlay(C);
                }
                else
                {
                    DrawGunsightOverlay(C);
                }

                C.ColorModulate.W = SavedOpacity; // reset HUD opacity to original value
            }
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, VehicleBase, self);
        }
    }
}

// Modified to use this function to draw the co-driver's periscope overlay, through which this MG is aimed
simulated function DrawGunsightOverlay(Canvas C)
{
    local float ScreenRatio;

    ScreenRatio = float(C.SizeY) / float(C.SizeX);
    C.SetPos(0.0, 0.0);

    C.DrawTile(GunsightOverlay, C.SizeX, C.SizeY,                                // screen drawing area (to fill screen)
        0.0, (1.0 - ScreenRatio) * float(GunsightOverlay.MaterialVSize()) / 2.0, // position in texture to begin drawing tile (from left edge, with vertical position to suit screen aspect ratio)
        GunsightOverlay.MaterialUSize(), float(GunsightOverlay.MaterialVSize()) * ScreenRatio); // width & height of tile within texture
}

defaultproperties
{
    //This class is for M4A1 Shermans; need to create custom views for each type of Sherman and Stuart -- one size does not fit all!
    GunClass=class'DH_Vehicles.DH_ShermanMountedMG'

    WeaponFOV=72.0
    GunsightOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_Allied' // not actually a gunsight, but this MG is aimed using co-driver's periscope
    GunsightSize=0.75 //size of texture overlay

//  This bow MG did not have a sight or even a peephole to aim through, & was instead aimed using co-driver's overhead periscope
//  Looking through that view (or while unbuttoned but that's not modelled in game), co-driver had to aim by walking tracers or round impacts onto target
//  Note that the first person camera position (set by FPCamPos) is not quite positioned where the co-driver's overhead periscope is
//  It's deliberately lowered slightly so the player can just see the MG barrel if he waggles it up
//  This is a small compromise so the player can check roughly which way his MG is facing before he begins to fire
//  Otherwise he has to open fire not knowing which way the gun is aimed, & only then can he correct the aim (so he may hit friendlies)
//  In real life he would know where the MG was pointing because he would be holding it in his hands
//  So this camera adjustment is just an effective form of substitute feedback about where the gun is pointing
    FPCamPos=(X=-10.0,Y=0.0,Z=8.0)
    //CameraBone="T34_mg"
    //HUDOverlayClass=class'DH_Vehicles.DH_30Cal_VehHUDOverlay'
    //HUDOverlayOffset=(X=20,Y=0,Z=-20) //distance from your face
    //HUDOverlayFOV=45 //size of MG mesh in your face
}
