//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_Sdkfz2341CannonPawn extends DHGermanCannonPawn;

// Modified to include extra collision meshes for the turret covers
exec function ShowColMesh()
{
    local DHCollisionMeshActor LeftCover, RightCover;

    if (VehWep != none && VehWep.CollisionMeshActor != none && IsDebugModeAllowed() && Level.NetMode != NM_DedicatedServer)
    {
        if (VehWep.IsA('DH_Sdkfz2341Cannon'))
        {
            LeftCover = DH_Sdkfz2341Cannon(VehWep).TurretCoverColMeshLeft;
            RightCover = DH_Sdkfz2341Cannon(VehWep).TurretCoverColMeshRight;
        }

        // If in normal mode, with CSM hidden, we toggle the CSM to be visible
        if (VehWep.CollisionMeshActor.DrawType == DT_None)
        {
            VehWep.CollisionMeshActor.ToggleVisible();

            if (LeftCover != none && RightCover != none)
            {
                LeftCover.ToggleVisible();
                RightCover.ToggleVisible();
            }
        }
        // Or if CSM has already been made visible & so is the weapon, we next toggle the weapon to be hidden
        else if (VehWep.Skins[0] != Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha')
        {
            VehWep.CollisionMeshActor.HideOwner(true); // can't simply make weapon DrawType=none or bHidden, as that also hides all attached actors, including col mesh & player

            if (LeftCover != none && RightCover != none)
            {
                LeftCover.HideOwner(true);
                RightCover.HideOwner(true);
            }
        }
        // Or if CSM has already been made visible & the weapon has been hidden, we now go back to normal mode, by toggling weapon back to visible & CSM to hidden
        else
        {
            VehWep.CollisionMeshActor.HideOwner(false);
            VehWep.CollisionMeshActor.ToggleVisible();

            if (LeftCover != none && RightCover != none)
            {
                LeftCover.HideOwner(false);
                LeftCover.ToggleVisible();
                RightCover.HideOwner(false);
                RightCover.ToggleVisible();
            }
        }
    }
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Sdkfz2341Cannon'
    DriverPositions(0)=(ViewLocation=(X=40.0,Y=12.0,Z=3.0),ViewFOV=34.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',ViewPitchUpLimit=12743,ViewPitchDownLimit=64443,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',TransitionUpAnim="com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=9.0,Y=1.0,Z=-6.0)
    DriveAnim="stand_idlehip_binoc"
    bManualTraverseOnly=true
    CannonScopeCenter=Texture'DH_VehicleOptics_tex.German.tiger_sight_graticule'
    GunsightSize=0.5 // 17 degrees visible FOV at 2.5x magnification (TZF3a sight)
    RangeRingRotator=TexRotator'DH_VehicleOptics_tex.German.20mmFlak_sight_center'
    RangeRingRotationFactor=2048
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
    FireImpulse=(X=-15000.0)
}
