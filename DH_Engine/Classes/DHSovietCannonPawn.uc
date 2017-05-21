//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHSovietCannonPawn extends DHVehicleCannonPawn
    abstract;

var     float   ScopeCenterPositionX; // horizontal positioning of CannonScopeCenter overlay for aiming reticle or moving range indicator (0 to 1, from left of gunsight texture)
var     float   ScopeCenterScaleX;    // width & height scaling of CannonScopeCenter overlay
var     float   ScopeCenterScaleY;

// Modified to include different handling for Soviet optical range adjustment (from RO's RussianTankCannonPawn)
// Some cannons have optical (not mechanically linked) range setting, so range adjustment moves vertical position of reticle to facilitate aiming for range
// Or on some mechanically linked sights the optical adjustment can just be an additional moving range indicator bar
simulated function DrawGunsightOverlay(Canvas C)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight, Scale, PosX, PosY;

    if (GunsightOverlay != none)
    {
        // Draw the gunsight overlay
        TextureSize = float(GunsightOverlay.USize);
        TilePixelWidth = TextureSize / GunsightSize * 0.955;
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX);
        TileStartPosU = ((TextureSize - TilePixelWidth) / 2.0) - OverlayCorrectionX;
        TileStartPosV = ((TextureSize - TilePixelHeight) / 2.0) - OverlayCorrectionY;
        C.SetPos(0.0, 0.0);

        C.DrawTile(GunsightOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);

        // Draw the gunsight aiming reticle or moving range indicator (different from DHVehicleCannonPawn)
        if (CannonScopeCenter != none && Gun != none && Gun.ProjectileClass != none)
        {
            Scale = float(C.SizeY) / TilePixelHeight; // how much the tile has been scaled to fit the screen
            PosX = ((ScopeCenterPositionX * TextureSize) - TileStartPosU) * Scale;
            PosY = ((Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * TextureSize) - TileStartPosV) * Scale; // vertical adjustment of reticle or range indicator position
            C.SetPos(PosX, PosY);
            Scale *= TextureSize / 1200.0; // 'mover' texture is sized for a 1200 pixel screen height, so finally adjust draw scale to suit actual screen height

            C.DrawTileScaled(CannonScopeCenter, Scale * ScopeCenterScaleX, Scale * ScopeCenterScaleY);
        }
    }
}

defaultproperties
{
    RangeText="meters"
    RangePositionX=0.1
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.Allied.PERISCOPE_overlay_Allied'
    BinocsOverlay=texture'DH_VehicleOptics_tex.Soviet.AB_BINOC_overlay_7x50Sov'
    GunsightSize=0.5371875
    ScopeCenterPositionX=0.215
    ScopeCenterScaleX=1.35
    ScopeCenterScaleY=1.35
    AltAmmoReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.DT_ammo_reload' // TODO: make a proper version of this, this texture is just a quick hack job (Oct 2016)
}
