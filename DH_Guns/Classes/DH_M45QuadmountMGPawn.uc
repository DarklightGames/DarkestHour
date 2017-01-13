//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M45QuadmountMGPawn extends DHVehicleMGPawn;

// Matt: modified to add workaround fix for weird problem with opacity of gun sights
// A net client would not render objects correctly through the glass sights shader material, with some objects being rendered in front of the sights
// But for some weird reason, if we call SetLocation on the VehicleBase, it cures the problem ! (have to do this each time the actor is spawned on a client)
simulated function InitializeVehicleBase()
{
    super.InitializeVehicleBase();

    if (Role < ROLE_Authority)
    {
        VehicleBase.SetLocation(VehicleBase.Location);
    }
}

// From ROTankCannonPawn, so the turret movement keys control the weapon
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    UpdateTurretRotation(DeltaTime, YawChange, PitchChange);

    if (IsHumanControlled())
    {
        PlayerController(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
        PlayerController(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }
}

// From DHVehicleCannonPawn (just omitting the periscope position check)
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    local float TurnSpeedFactor;

    if (DriverPositionIndex == BinocPositionIndex && DHPlayer(Controller) != none)
    {
        TurnSpeedFactor = DHPlayer(Controller).DHScopeTurnSpeedFactor;
        YawChange *= TurnSpeedFactor;
        PitchChange *= TurnSpeedFactor;
    }

    super(DHVehicleWeaponPawn).UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange); // skip over Super in DHVehicleMGPawn
}

// Modified so camera rotation & offset positioning is always based on the weapon's aim, so player's view always moves with turret
// But with 'look around' rotation added in when player's head is raised above the reflector sight
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat RelativeQuat, TurretQuat, NonRelativeQuat;

    ViewActor = self;

    if (PC == none || Gun == none)
    {
        return;
    }

    // Get camera rotation, based on rotation of weapon's aim, & update custom aim
    CameraRotation = Gun.GetBoneRotation(CameraBone);
    PC.WeaponBufferRotation.Yaw = CameraRotation.Yaw;
    PC.WeaponBufferRotation.Pitch = CameraRotation.Pitch;

    // Player has his head raised above the reflector sight & can look around, so factor in the PlayerController's relative rotation
    if (DriverPositionIndex > 0 || IsInState('ViewTransition'))
    {
        RelativeQuat = QuatFromRotator(Normalize(PC.Rotation));
        TurretQuat = QuatFromRotator(CameraRotation);
        NonRelativeQuat = QuatProduct(RelativeQuat, TurretQuat);
        CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));
    }

    // Get camera location, including adjusting for any offset positioning (FPCamPos is either set in default props or from any ViewLocation in DriverPositions)
    CameraLocation = Gun.GetBoneCoords(CameraBone).Origin;

    if (FPCamPos != vect(0.0, 0.0, 0.0))
    {
        CameraLocation = CameraLocation + (FPCamPos >> CameraRotation);
    }

    // Finalise the camera with any shake
    CameraLocation = CameraLocation + (PC.ShakeOffset >> PC.Rotation);
    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
}

// Modified to draw rotating turret on the HUD, like a vehicle cannon (relevant features copied from DHHud & adapted as necessary)
simulated function DrawHUD(Canvas C)
{
    local ROHud.AbsoluteCoordsInfo Coords;
    local HudBase.SpriteWidget     Widget;
    local PlayerController PC;
    local ROHud            HUD;
    local DHVehicle        V;
    local color            VehicleColor;
    local float            VehicleHealthScale;
    local rotator          MyRot;

    super.DrawHUD(C);

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView && Gun != none)
    {
        HUD = ROHud(PC.myHUD);
        V = DHVehicle(VehicleBase);

        if (HUD != none && !HUD.bHideHud && V != none && V.VehicleHudTurretLook != none && V.VehicleHudTurret != none)
        {
            // Figure where to draw
            Coords.PosX = C.ClipX * HUD.VehicleIconCoords.X;
            Coords.Height = C.ClipY * HUD.VehicleIconCoords.YL * HUD.HudScale;
            Coords.PosY = C.ClipY * HUD.VehicleIconCoords.Y - Coords.Height;
            Coords.Width = Coords.Height;

            // Set turret color based on any damage
            VehicleHealthScale = V.Health / V.HealthMax;

            if (VehicleHealthScale > 0.75)
            {
                VehicleColor = class'DHHud'.default.VehicleNormalColor;
            }
            else if (VehicleHealthScale > 0.35)
            {
                VehicleColor = class'DHHud'.default.VehicleDamagedColor;
            }
            else
            {
                VehicleColor = class'DHHud'.default.VehicleCriticalColor;
            }

            Widget = HUD.VehicleIcon;
            Widget.Tints[0] = VehicleColor;
            Widget.Tints[1] = VehicleColor;

            // Draw the turret, with current turret rotation
            MyRot = rotator(vector(Gun.CurrentAim) >> Gun.Rotation);
            V.VehicleHudTurret.Rotation.Yaw = V.Rotation.Yaw - MyRot.Yaw;
            Widget.WidgetTexture = V.VehicleHudTurret;
            HUD.DrawSpriteWidgetClipped(C, Widget, Coords, true);

            V.VehicleHudTurretLook.Rotation.Yaw = V.Rotation.Yaw - CustomAim.Yaw;
            Widget.WidgetTexture = V.VehicleHudTurretLook;
            Widget.Tints[0].A /= 2;
            Widget.Tints[1].A /= 2;
            HUD.DrawSpriteWidgetClipped(C, Widget, Coords, true);
        }
    }
}

// Modified so when player lifts head away from sights, view rotation is initially zeroed so the view doesn't snap to another rotation
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        super.HandleTransition();

        if (Level.NetMode != NM_DedicatedServer && LastPositionIndex == 0 && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
            SetRotation(rot(0, 0, 0));
            Controller.SetRotation(Rotation);
        }
    }
}

// Can't fire if using binoculars
function bool CanFire()
{
    return DriverPositionIndex != BinocPositionIndex || !IsHumanControlled();
}

defaultproperties
{
    GunClass=class'DH_Guns.DH_M45QuadmountMG'
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMultiPosition=true
    DriverPositions(0)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionUpAnim="sights_out",bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionDownAnim="sights_in",ViewPitchUpLimit=6000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    UnbuttonedPositionIndex=0
    BinocPositionIndex=2
    bDrawDriverInTP=true
    DrivePos=(X=-10.0,Y=0.0,Z=-37.0)
    DriveAnim="VSU76_driver_idle_close"
    CameraBone="Camera_com"
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
    VehicleMGReloadTexture=texture'DH_Artillery_tex.ATGun_Hud.m45_ammo_reload'
    bSpecialRotateSounds=true
    RotateSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    PitchSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    RotateAndPitchSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
}
