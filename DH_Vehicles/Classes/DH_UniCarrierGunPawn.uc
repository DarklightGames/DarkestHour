//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_UniCarrierGunPawn extends DH_ROMountedTankMGPawn; // Matt: originally extended ROMountedTankMGPawn

// Overridden to give players the same momentum as their vehicle had when exiting - adds a little height kick to allow for hacked in damage system
function bool KDriverLeave(bool bForceLeave)
{
    local vector OldVel;

    if (!bForceLeave)
    {
        OldVel = VehicleBase.Velocity;
    }

    if (super(VehicleWeaponPawn).KDriverLeave(bForceLeave))
    {
        DriverPositionIndex = 0;
        LastPositionIndex = 0;

        VehicleBase.MaybeDestroyVehicle();

        if (!bForceLeave)
        {
            OldVel.Z += 50.0;
            Instigator.Velocity = OldVel;
        }

        return true;
    }

    return false;
}

simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector  x, y, z;
    local vector  VehicleZ, CamViewOffsetWorld;
    local float   CamViewOffsetZAmount;
    local rotator WeaponAimRot;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = Gun.GetBoneRotation(CameraBone);

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    CameraRotation =  WeaponAimRot;

    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

    if (CameraBone != '' && Gun != none)
    {
        CameraLocation = Gun.GetBoneCoords('Camera_com').Origin;

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0.0, 0.0, 1.0) >> WeaponAimRot;
            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }
    else
    {
        CameraLocation = GetCameraLocationStart() + (FPCamPos >> Rotation) + CamViewOffsetWorld;

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0.0, 0.0, 1.0) >> Rotation;
            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }

    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
}

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector  CameraLocation;
    local rotator CameraRotation;
    local Actor   ViewActor;
    local vector  GunOffset;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView && HUDOverlay != none)
    {
        if (!Level.IsSoftwareRendering())
        {
            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

            CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
            GunOffset += PC.ShakeOffset * FirstPersonGunShakeScale;

            // Make the first person gun appear lower when your sticking your head up
            GunOffset.Z += (((Gun.GetBoneCoords('1stperson_wep').Origin.Z - CameraLocation.Z) * 3.0));
            GunOffset += HUDOverlayOffset;

            // Not sure if we need this, but the HudOverlay might lose network relevancy if its location doesn't get updated - Ramm
            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));

            Canvas.DrawBoundActor(HUDOverlay, false, true, HUDOverlayFOV, CameraRotation, PC.ShakeRot * FirstPersonGunShakeScale, GunOffset * -1.0);
        }
    }
    else
    {
        ActivateOverlay(false);
    }

    if (PC != none)
    {
        // Draw tank, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, VehicleBase, self);
        }
    }
}

// Hack - turn off the muzzle flash in first person when your head is sticking up since it doesn't look right
// Matt: added this to bren carrier as muzzle flash looked wrong in raised gunner position
// I don't think it's ideal but it's better than seeing the muzzle flash and it's exactly the same as the other APC MGs
simulated state ViewTransition
{
    simulated function BeginState()
    {
        if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone  || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositionIndex > 0)
            {
                Gun.AmbientEffectEmitter.bHidden = true;
            }
        }

        super.BeginState();
    }

    simulated function EndState()
    {
        if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone  || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositionIndex == 0)
            {
                Gun.AmbientEffectEmitter.bHidden = false;
            }
        }

        super.EndState();
    }
}

// Modified to better suit the curved magazine of the bren gun
function float GetAmmoReloadState()
{
    local DH_ROMountedTankMG MG;
    local float ProportionOfReloadRemaining;

    MG = DH_ROMountedTankMG(Gun);

    if (MG != none)
    {
        if (MG.ReadyToFire(false))
        {
            return 0.0;
        }
        else if (MG.bReloading)
        {
            ProportionOfReloadRemaining = 1.0 - ((Level.TimeSeconds - MG.ReloadStartTime) / MG.ReloadDuration);

            if (ProportionOfReloadRemaining >= 0.75)
            {
                return 1.0;
            }
            else if (ProportionOfReloadRemaining >= 0.5)
            {
                return 0.67;
            }
            else if (ProportionOfReloadRemaining >= 0.25)
            {
                return 0.5;
            }
            else
            {
                return 0.35;
            }
        }
        else
        {
            return 1.0;
        }
    }
}

defaultproperties
{
    VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.Bren_ammo_reload'
    UnbuttonedPositionIndex=0
    FirstPersonGunShakeScale=1.5
    WeaponFOV=60.0
    DriverPositions(0)=(ViewLocation=(X=10.0),ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Bren_mg_int',TransitionUpAnim="com_open",DriverTransitionAnim="VUC_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=7500,ViewNegativeYawLimit=-7500,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Bren_mg_int',TransitionDownAnim="com_close",DriverTransitionAnim="VUC_com_open",ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=7500,ViewNegativeYawLimit=-7500,bExposed=true)
    bMultiPosition=true
    bMustBeTankCrew=false
    GunClass=class'DH_Vehicles.DH_UniCarrierGun'
    bCustomAiming=true
    PositionInArray=0
    bHasAltFire=false
    CameraBone="Camera_com"
    bDesiredBehindView=false
    DrivePos=(X=-11.0,Y=-4.0,Z=31.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VUC_com_idle_close"
    EntryRadius=130.0
    FPCamPos=(X=10.0)
    TPCamDistance=50.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    HUDOverlayClass=class'DH_Vehicles.DH_UniCarrierMGOverlay'
    HUDOverlayOffset=(X=-6.0)
    HUDOverlayFOV=35.0
    bKeepDriverAuxCollision=true
    PitchUpLimit=4000
    PitchDownLimit=60000
    ExitPositions(0)=(X=48.0,Y=-107.0,Z=15.0)
    ExitPositions(1)=(X=48.0,Y=117.0,Z=15.0)
    ExitPositions(2)=(X=52.0,Y=-119.0,Z=13.0)
    ExitPositions(3)=(X=-45.0,Y=-118.0,Z=15.0)
    ExitPositions(4)=(X=7.0,Y=110.0,Z=15.0)
    ExitPositions(5)=(X=-48.0,Y=111.0,Z=15.0)
}
