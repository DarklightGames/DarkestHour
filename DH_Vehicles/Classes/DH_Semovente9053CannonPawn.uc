//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Semovente9053CannonPawn extends DHAssaultGunCannonPawn;

// New debug execs to adjust OpticalRanges values (why is this not in a parent?)
exec function SetOpticalRange(float NewValue)
{
    Log(Cannon.ProjectileClass @ "OpticalRanges[" $ Cannon.CurrentRangeIndex $ "]=" @ NewValue @
        "(was" @ class<DHCannonShell>(Cannon.ProjectileClass).default.OpticalRanges[Cannon.CurrentRangeIndex].RangeValue $ ")");

    class<DHCannonShell>(Cannon.ProjectileClass).default.OpticalRanges[Cannon.CurrentRangeIndex].RangeValue = NewValue;
}

// Modified to send a hint to the occupant about the limited ammunition of the Semovente 90/53.
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer DHPC;

    DHPC = DHPlayer(PC);

    if (DHPC != None)
    {
        DHPC.QueueHint(65, true);
    }

    super.ClientKDriverEnter(PC);
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
    
    AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    FireImpulse=(X=-110000)
    CameraBone="CAMERA_GUN"

    GunOpticsClass=class'DH_Vehicles.DHGunOptics_Italian'
    ProjectileGunOpticRangeTableIndices(1)=1
    ProjectileGunOpticRangeTableIndices(2)=1
}
