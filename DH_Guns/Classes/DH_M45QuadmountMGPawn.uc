//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M45QuadmountMGPawn extends DHVehicleMGPawn;

// Matt: modified to add workaround fix for weird problem with opacity of gun sights
// A net client would not render objects correctly through the glass sights shader material, with some objects being rendered in front of the sights
// But for some weird reason, if we call SetLocation on the VehicleBase, it cures the problem ! (have to do this each time the actor is spawned on a client)
simulated function InitializeMG()
{
    super.InitializeMG();

    if (Role < ROLE_Authority)
    {
        VehicleBase.SetLocation(VehicleBase.Location);
    }
}

// From ROTankCannonPawn, so the turret movement keys control the weapon
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    UpdateTurretRotation(DeltaTime, YawChange, PitchChange);

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }
}

// Modified to remove the super from DHVehicleMGPawn, which makes the mouse control the MG as well as the turret movement keys
// But retaining the scope turn speed factor if the player is using binoculars
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    local float TurnSpeedFactor;

    if (DriverPositionIndex == BinocPositionIndex && DHPlayer(Controller) != none)
    {
        TurnSpeedFactor = DHPlayer(Controller).DHISTurnSpeedFactor;
        YawChange *= TurnSpeedFactor;
        PitchChange *= TurnSpeedFactor;
    }

    super(VehicleWeaponPawn).UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange);
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
    local ROTreadCraft     AV;
    local color            VehicleColor;
    local float            VehicleHealthScale;
    local rotator          MyRot;

    super.DrawHUD(C);

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView && VehicleBase != none && Gun != none)
    {
        HUD = ROHud(PC.myHUD);
        AV = ROTreadCraft(VehicleBase);

        if (HUD != none && AV != none && AV.VehicleHudTurretLook != none && AV.VehicleHudTurret != none)
        {
            // Figure where to draw
            Coords.PosX = C.ClipX * HUD.VehicleIconCoords.X;
            Coords.Height = C.ClipY * HUD.VehicleIconCoords.YL * HUD.HudScale;
            Coords.PosY = C.ClipY * HUD.VehicleIconCoords.Y - Coords.Height;
            Coords.Width = Coords.Height;

            // Figure what colour to draw in
            VehicleHealthScale = VehicleBase.Health / VehicleBase.HealthMax;

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

            // Draw the turret
            AV.VehicleHudTurretLook.Rotation.Yaw = VehicleBase.Rotation.Yaw - CustomAim.Yaw;
            Widget.WidgetTexture = AV.VehicleHudTurretLook;
            Widget.Tints[0].A /= 2;
            Widget.Tints[1].A /= 2;
            HUD.DrawSpriteWidgetClipped(C, Widget, Coords, true);
            Widget.Tints[0] = VehicleColor;
            Widget.Tints[1] = VehicleColor;

            MyRot = rotator(vector(Gun.CurrentAim) >> Gun.Rotation);
            AV.VehicleHudTurret.Rotation.Yaw = VehicleBase.Rotation.Yaw - MyRot.Yaw;
            Widget.WidgetTexture = AV.VehicleHudTurret;
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
    return DriverPositionIndex != BinocPositionIndex;
}

// TEMP debug execs ///////////////////////////////////////////////////////////////
exec function SetAnim(name NewAnim)
{
    Driver.PlayAnim(NewAnim);
}
exec function SetPitch(int NewValue)
{
    Gun.CustomPitchUpLimit = NewValue;
    Log("CustomPitchUpLimit =" @ Gun.CustomPitchUpLimit);
}
exec function SetCamPos(int NewX, int NewY, int NewZ)
{
    Log(Tag @ "new DriverPositions[" $ DriverPositionIndex $ "].ViewLocation =" @ NewX @ NewY @ NewZ @ "(old was" @ DriverPositions[DriverPositionIndex].ViewLocation $ ")");
    DriverPositions[DriverPositionIndex].ViewLocation.X = NewX;
    DriverPositions[DriverPositionIndex].ViewLocation.Y = NewY;
    DriverPositions[DriverPositionIndex].ViewLocation.Z = NewZ;
    FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
}
exec function SetViewUp(int NewValue)
{
    DriverPositions[DriverPositionIndex].ViewPitchUpLimit = NewValue;
    Log(Tag @ "new DriverPositions[" $ DriverPositionIndex $ "].ViewPitchUpLimit =" @ DriverPositions[DriverPositionIndex].ViewPitchUpLimit);
}
exec function SetViewDown(int NewValue)
{
    DriverPositions[DriverPositionIndex].ViewPitchDownLimit = NewValue;
    Log(Tag @ "new DriverPositions[" $ DriverPositionIndex $ "].ViewPitchDownLimit =" @ DriverPositions[DriverPositionIndex].ViewPitchDownLimit);
}
////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    GunClass=class'DH_Guns.DH_M45QuadmountMG'
    PositionInArray=0
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    bMustBeTankCrew=false
    bMultiPosition=true
    UnbuttonedPositionIndex=0
    BinocPositionIndex=2
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
    DriverPositions(0)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionUpAnim="sights_out",bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',TransitionDownAnim="sights_in",ViewPitchUpLimit=6000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_M45_anm.m45_turret',ViewPitchUpLimit=6000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    DrivePos=(X=-10.0,Y=0.0,Z=-37.0)
    DriveAnim="VSU76_driver_idle_close"
    CameraBone="Camera_com"
    bSpecialRotateSounds=true
    RotateSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    PitchSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    RotateAndPitchSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    VehicleMGReloadTexture=texture'DH_Artillery_tex.ATGun_Hud.m45_ammo_reload'
    EntryRadius=130.0
}
