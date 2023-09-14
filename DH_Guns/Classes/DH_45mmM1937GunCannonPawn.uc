//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    GunClass=class'DH_Guns.DH_45mmM1937GunCannon'
    DriverPositions(0)=(ViewLocation=(X=-2.0,Y=-18.0,Z=19.5),ViewFOV=34.0,TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idle_binoc",ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true) // view limits only relevant during transition down, to avoid snap to front at start
    DriverPositions(1)=(TransitionDownAnim="com_close",DriverTransitionAnim="crouch_idlehold_bayo",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,DriverTransitionAnim="crouch_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=-22.0,Y=-1.0,Z=0.0)
    DriveAnim="crouch_idle_binoc"
    GunsightOverlay=Texture'DH_VehicleOptics_tex.Soviet.45mmATGun_sight_background' // TODO: not sure this AHZ overlay is correct; it could be the telescopic sight used in tanks with the 45mm gun?
    GunsightSize=0.441 // 15 degrees visible FOV at 2.5x magnification (PP-1 sight)
    CannonScopeCenter=Texture'Vehicle_Optic.Scopes.T3476_sight_mover'
    ScopeCenterPositionX=0.035
    ScopeCenterScaleX=2.2
    ScopeCenterScaleY=2.0
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed' // matches size of gunsight
    AmmoShellTexture=Texture'InterfaceArt_ahz_tex.Tank_Hud.45mmShell' // TODO: get new ammo icons made so the "X" text matches the position of the ammo count
    AmmoShellReloadTexture=Texture'InterfaceArt_ahz_tex.Tank_Hud.45mmShell_reload'
}
