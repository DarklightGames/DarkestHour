//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_45mmM1937GunCannonPawn extends DHATGunCannonPawn; // all overrides from DHSovietCannonPawn class // TODO: merge functionality

var     float   ScopeCenterPositionX; // horizontal positioning of CannonScopeCenter overlay for aiming reticle or moving range indicator
var     float   ScopeCenterScaleX;    // width & height scaling of CannonScopeCenter overlay
var     float   ScopeCenterScaleY;

simulated function DrawGunsightOverlay(Canvas C)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight, Scale, PosX, PosY;

    if (GunsightOverlay != none)
    {
        // Draw the gunsight overlay
        TextureSize = float(GunsightOverlay.MaterialUSize());
        TilePixelWidth = TextureSize / GunsightSize * 0.955;
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX);
        TileStartPosU = ((TextureSize - TilePixelWidth) / 2.0) - OverlayCorrectionX;
        TileStartPosV = ((TextureSize - TilePixelHeight) / 2.0) - OverlayCorrectionY;
        C.SetPos(0.0, 0.0);

        C.DrawTile(GunsightOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);

        // Draw the gunsight aiming reticle or moving range indicator (different from DHVehicleCannonPawn)
        if (CannonScopeCenter != none && Gun != none && Gun.ProjectileClass != none)
        {
            Scale = float(C.SizeY) / TilePixelHeight;
            PosX = ((ScopeCenterPositionX * TextureSize) - TileStartPosU) * Scale;
            PosY = ((Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * TextureSize) - TileStartPosV) * Scale;
            C.SetPos(PosX, PosY);
            Scale *= TextureSize / 1200.0;

            C.DrawTileScaled(CannonScopeCenter, Scale * ScopeCenterScaleX, Scale * ScopeCenterScaleY);
        }
    }
}

defaultproperties
{
    //Gun Class
    GunClass=Class'DH_45mmM1937GunCannon'

    //Driver's position and animations
    DriverPositions(0)=(ViewFOV=25.0,TransitionUpAnim="overlay_out",ViewPitchUpLimit=4005,ViewPitchDownLimit=64623,ViewPositiveYawLimit=5825,ViewNegativeYawLimit=-5825,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(TransitionDownAnim="overlay_in",TransitionUpAnim="raise",DriverTransitionAnim="45mm_gunner_lower",ViewPitchUpLimit=6000,ViewPitchDownLimit=49152,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(TransitionDownAnim="lower",DriverTransitionAnim="45mm_gunner_raise",ViewPitchUpLimit=6000,ViewPitchDownLimit=49152,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,DriverTransitionAnim="45mm_gunner_binocs",ViewPitchUpLimit=6000,ViewPitchDownLimit=49152,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    BinocPositionIndex=3
    DrivePos=(Z=58)
    DriveAnim="45mm_gunner_idle"

    //Gunsight
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Soviet.45mmATGun_sight_background' // TODO: not sure this AHZ overlay is correct; it could be the telescopic sight used in tanks with the 45mm gun?
    GunsightSize=0.441 // 15 degrees visible FOV at 2.5x magnification (PP-1 sight)
    CannonScopeCenter=Texture'Vehicle_Optic.Scopes.T3476_sight_mover'
    ScopeCenterPositionX=0.035
    ScopeCenterScaleX=2.2
    ScopeCenterScaleY=2.0
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed' // matches size of gunsight

    //HUD
    AmmoShellTexture=Texture'InterfaceArt_ahz_tex.Tank_Hud.45mmShell' // TODO: get new ammo icons made so the "X" text matches the position of the ammo count
    AmmoShellReloadTexture=Texture'InterfaceArt_ahz_tex.Tank_Hud.45mmShell_reload'

    CameraBone="GUNSIGHT_CAMERA"
}

