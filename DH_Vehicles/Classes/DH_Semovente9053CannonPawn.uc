//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Semovente9053CannonPawn extends DHAssaultGunCannonPawn;

// TODO: This sucks, but will suffice for now.
// We really ought to have a separate gunsight object and have the cannon pawn reference it.
// There it can override the gunsight drawing function and do whatever it wants.
simulated function DrawGunsightOverlay(Canvas C)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight, PosX, PosY;
    local float GunsightWidthPixels;

    if (GunsightOverlay != none)
    {
        // Draw the gunsight overlay.
        TextureSize = float(GunsightOverlay.MaterialUSize());
        TilePixelWidth = TextureSize / GunsightSize;
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX);
        TileStartPosU = ((TextureSize - TilePixelWidth) / 2.0) - OverlayCorrectionX;
        TileStartPosV = ((TextureSize - TilePixelHeight) / 2.0) - OverlayCorrectionY;

        C.SetPos(0.0, 0.0);
        C.DrawTile(GunsightOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);

        // Draw the gunsight aiming reticle or moving range indicator (different from DHVehicleCannonPawn)
        if (CannonScopeCenter != none && Gun != none && Gun.ProjectileClass != none)
        {
            PosY = 0.5 - Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange());
            GunsightWidthPixels = C.SizeX * GunsightSize;
            // GunsightHeightPixels = C.SizeY * GunsightSize;
            PosY = GunsightWidthPixels * PosY;

            C.SetPos(0, PosY);
            C.DrawTile(CannonScopeCenter, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
        }

        DrawGunsightRangeSetting(C);
    }
}

// New debug execs to adjust OpticalRanges values
exec function SetOpticalRange(float NewValue)
{
    Log(Cannon.ProjectileClass @ "OpticalRanges[" $ Cannon.CurrentRangeIndex $ "]=" @ NewValue @
        "(was" @ class<DHCannonShell>(Cannon.ProjectileClass).default.OpticalRanges[Cannon.CurrentRangeIndex].RangeValue $ ")");

    class<DHCannonShell>(Cannon.ProjectileClass).default.OpticalRanges[Cannon.CurrentRangeIndex].RangeValue = NewValue;
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Semovente9053Cannon'
    DriverPositions(0)=(ViewLocation=(X=30.0,Y=-26.0,Z=1.0),ViewFOV=28.33,PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_turret_ext',ViewPitchUpLimit=2367,ViewPitchDownLimit=64625,ViewPositiveYawLimit=3822,ViewNegativeYawLimit=-3822,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="semo9053_com_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="semo9053_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_turret_ext',DriverTransitionAnim="semo9053_com_binocs",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    RaisedPositionIndex=2
    DriveRot=(Yaw=32768)
    DrivePos=(Z=58)
    DriveAnim="semo9053_com_idle_close"
    bHasAltFire=false
    // Figure out what gunsight to use (also maybe refactor to have the gunsights be a separate class that can just be referenced and reused by multiple vehicles)
    GunsightOverlay=Texture'DH_Semovente9053_tex.Interface.semovente9053_sight_background'
    GunsightSize=0.4
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    FireImpulse=(X=-110000)
    CameraBone="CAMERA_GUN"

    CannonScopeCenter=Texture'DH_Semovente9053_tex.interface.semovente9053_sight_mover'
}
