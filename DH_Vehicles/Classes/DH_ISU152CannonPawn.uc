//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// NOTES:
//
// Commander seat is fitted with TPK-1 periscope.
// TPK-2 can pitch from -8 to +15 degrees according to its manual. Couldn't find
// exact values for TPK-1 but they shouldn't differ much, if at all.
//

class DH_ISU152CannonPawn extends DHSovietCannonPawn;

const            SECONDARY_PERISCOPE_INDEX = 2;
var     Material SecondaryPeriscopeOverlay;

var     float    PeriscopeVisibleFOV[2]; // the visible FOV when using the two periscope views (1st is unmagnified, 2nd is 5x magnification)

// Modified to add a little hack so various other functionality recognises an extra periscope position, without having to override lots of other stuff
// We just flip the PeriscopePositionIndex to match the player's current position whenever he's in either of the two periscope positions
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        super.HandleTransition();

        if (DriverPositionIndex == default.PeriscopePositionIndex || DriverPositionIndex == SECONDARY_PERISCOPE_INDEX)
        {
            PeriscopePositionIndex = DriverPositionIndex;
        }
    }
}

// Modified to scale the periscope size on screen, the same way a gunsight is scaled using the GunsightSize setting
simulated function DrawPeriscopeOverlay(Canvas C)
{
    local float ScreenWidthProportion, TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight;

    if (DriverPositionIndex == SECONDARY_PERISCOPE_INDEX)
    {
        ScreenWidthProportion = PeriscopeVisibleFOV[DriverPositionIndex - 1] / DriverPositions[PeriscopePositionIndex].ViewFOV;
        TextureSize = float(SecondaryPeriscopeOverlay.MaterialUSize());
        TilePixelWidth = TextureSize / ScreenWidthProportion;
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX);
        TileStartPosU = (TextureSize - TilePixelWidth) / 2.0;
        TileStartPosV = (TextureSize - TilePixelHeight) / 2.0;
        C.SetPos(0.0, 0.0);

        C.DrawTile(SecondaryPeriscopeOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
    }
    else
    {
        super.DrawPeriscopeOverlay(C);
    }

}

defaultproperties
{
    GunClass=Class'DH_ISU152Cannon'
    DriverPositions(0)=(ViewFOV=42.5,ViewLocation=(X=30.0,Y=-10.5,Z=8.0),PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-turret_int',bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=85.0,ViewLocation=(X=7.0,Y=0.0,Z=11.5),PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-turret_int',ViewPitchUpLimit=2731,ViewPitchDownLimit=64080,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=17.0,ViewLocation=(X=7.0,Y=0.0,Z=11.5),PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-turret_int',TransitionUpAnim="com_open",ViewPitchUpLimit=2731,ViewPitchDownLimit=64080,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=14500,ViewPitchDownLimit=64550,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-60000,bExposed=true)
    DriverPositions(4)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_ISU152_anm.ISU152-turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=14500,ViewPitchDownLimit=64550,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=3
    BinocPositionIndex=4
    PeriscopeVisibleFOV(0)=17.5 // 17.5 degrees visible FOV in the unmagnified view
    PeriscopeVisibleFOV(1)=7.5  // 7.5 degrees visible FOV in the 5x magnified view
    bManualTraverseOnly=true
    ManualMinRotateThreshold=0.5
    ManualMaxRotateThreshold=3.0
    DrivePos=(X=5.0,Y=2.0,Z=-16.0)
    DriveAnim="stand_idlehip_binoc"
    bLockCameraDuringTransition=true // stops player looking sideways & seeing through the vehicle
    bHasAltFire=false
    GunsightOverlay=Texture'DH_VehicleOptics_tex.isu152_sight_background'
    CannonScopeCenter=Texture'Vehicle_Optic.T3476_sight_mover'
    GunsightSize=0.424 // 18 degrees visible FOV at 2x magnification (ST-10 sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.PZ4_sight_destroyed' // matches size of gunsight
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.PERISCOPE_overlay_Allied
    SecondaryPeriscopeOverlay=Texture'DH_VehicleOptics_tex.Soviet.TNK-1_periscope'
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.ISU152_shell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.ISU152_shell_reload'
    ManualRotateSound=Sound'Vehicle_Weapons.manual_gun_traverse'
    ManualRotateAndPitchSound=Sound'Vehicle_Weapons.manual_gun_traverse'
    FireImpulse=(X=-200000.0)
}
