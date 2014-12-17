//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz2342CannonPawn extends DH_GermanTankCannonPawn;

var   texture   PeriscopeOverlay;

function bool KDriverLeave(bool bForceLeave)
{
    local bool bSuperDriverLeave;

    if (!bForceLeave && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')))
    {
        Instigator.ReceiveLocalizedMessage(class'DH_VehicleMessage', 4);
        return false;
    }
    else
    {
        DriverPositionIndex=InitialPositionIndex;
        bSuperDriverLeave = super(VehicleWeaponPawn).KDriverLeave(bForceLeave);

        ROVehicle(GetVehicleBase()).MaybeDestroyVehicle();
        return bSuperDriverLeave;
    }
}

function DriverDied()
{
    DriverPositionIndex=InitialPositionIndex;
    super.DriverDied();
    ROVehicle(GetVehicleBase()).MaybeDestroyVehicle();

    // Kill the rotation sound if the driver dies but the vehicle doesnt
    if (GetVehicleBase().Health > 0)
        SetRotatingStatus(0);
}

simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector x, y, z;
    local vector VehicleZ, CamViewOffsetWorld;
    local float CamViewOffsetZAmount;
    local coords CamBoneCoords;
    local rotator WeaponAimRot;
    local quat AQuat, BQuat, CQuat;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = rotator(vector(Gun.CurrentAim) >> Gun.Rotation);
    WeaponAimRot.Roll =  GetVehicleBase().Rotation.Roll;

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    // This makes the camera stick to the cannon, but you have no control
    if (DriverPositionIndex < GunsightPositions)
    {
        CameraRotation =  WeaponAimRot;
        // Make the cannon view have no roll
        CameraRotation.Roll = 0;
    }
    else if (bPCRelativeFPRotation)
    {
        //__________________________________________
        // First, Rotate the headbob by the player
        // controllers rotation (looking around) ---
        AQuat = QuatFromRotator(PC.Rotation);
        BQuat = QuatFromRotator(HeadRotationOffset - ShiftHalf);
        CQuat = QuatProduct(AQuat,BQuat);
        //__________________________________________
        // Then, rotate that by the vehicles rotation
        // to get the final rotation ---------------
        AQuat = QuatFromRotator(GetVehicleBase().Rotation);
        BQuat = QuatProduct(CQuat,AQuat);
        //__________________________________________
        // Make it back into a rotator!
        CameraRotation = QuatToRotator(BQuat);
    }
    else
        CameraRotation = PC.Rotation;

    if (IsInState('ViewTransition') && bLockCameraDuringTransition)
    {
        CameraRotation = Gun.GetBoneRotation('Camera_com');
    }

    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

    if (CameraBone != '' && Gun != none)
    {
        CamBoneCoords = Gun.GetBoneCoords(CameraBone);

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && DriverPositionIndex < GunsightPositions && !IsInState('ViewTransition'))
        {
            CameraLocation = CamBoneCoords.Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
        }
        else
        {
            CameraLocation = Gun.GetBoneCoords('Camera_com').Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
        }

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0, 0, 1) >> WeaponAimRot;
            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }
    else
    {
        CameraLocation = GetCameraLocationStart() + (FPCamPos >> Rotation) + CamViewOffsetWorld;

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0, 0, 1) >> Rotation;
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
    local vector    CameraLocation;
    local rotator   CameraRotation;
    local Actor ViewActor;
    local float SavedOpacity;
    local float scale;
    local int   RotationFactor;
    local float XL, YL, MapX, MapY;
    local color SavedColor, WhiteColor;

    local float ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

    local float posx, posy;

    PC = PlayerController(Controller);
    if (PC == none)
    {
        super.RenderOverlays(Canvas);
        //Log("PanzerTurret PlayerController was none, returning");
        return;
    }
    else if (!PC.bBehindView)
    {
        // store old opacity and set to 1.0 for map overlay rendering
        SavedOpacity = Canvas.ColorModulate.W;
        Canvas.ColorModulate.W = 1.0;

        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;

        scale = Canvas.SizeY / 1200.0;

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            if (DriverPositionIndex < GunsightPositions)
            {

                // Draw Scope Overlay
                ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
                OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
                OverlayCenterTexStart = (1 - OverlayCenterScale) * float(CannonScopeOverlay.USize) / 2;
                OverlayCenterTexSize =  float(CannonScopeOverlay.USize) * OverlayCenterScale;
                Canvas.SetPos(0, 0);
                Canvas.DrawTile(CannonScopeOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

                // Draw the moving Aiming Graticule
                if (Gun != none && Gun.ProjectileClass != none)
                    Canvas.SetPos(0, Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * Canvas.ClipY);
                //Canvas.SetPos(ScopePositionX * Canvas.ClipY / ScreenRatio / OverlayCenterScale - (Canvas.ClipX / OverlayCenterScale - Canvas.ClipX) / 2, (Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * Canvas.ClipY / ScreenRatio / OverlayCenterScale) - Canvas.ClipY * (1/ScreenRatio/OverlayCenterScale - 1) / 2);
                else
                    Canvas.SetPos(ScopePositionX * Canvas.ClipY / ScreenRatio / OverlayCenterScale - (Canvas.ClipX / OverlayCenterScale - Canvas.ClipX) / 2, ScopePositionY  * Canvas.ClipY / ScreenRatio / OverlayCenterScale - Canvas.ClipY * (1/ScreenRatio/OverlayCenterScale-1)/2);

                    Canvas.DrawTile(CannonScopeCenter , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);
                    //Canvas.DrawTileScaled(CannonScopeCenter, scale * ScopeCenterScaleX / ScreenRatio / OverlayCenterScale, scale * ScopeCenterScaleY / ScreenRatio / OverlayCenterScale);

                    // Draw the Range Ring
                    posx = (float(Canvas.SizeX) - float(Canvas.SizeY) * 4/OverlayCenterScale/3) / 2.0;
                    posy = (float(Canvas.SizeY) - float(Canvas.SizeY) * 4/OverlayCenterScale/3) / 2.0;
                    Canvas.SetPos(OverlayCorrectionX + Posx + (Canvas.SizeY * (1.0 - ScopeCenterScale) * 4/OverlayCenterScale/3 / 2.0) , OverlayCorrectionY + Canvas.SizeY * (1.0 - ScopeCenterScale * 4/OverlayCenterScale/3) / 2.0);
                    // to do: above, the OverlayCorrectionX should be recalculated with resolution, it's in overlay pixels not screen pixels

                    RotationFactor = 0;

                    if (Gun != none)
                    {
                        if (Gun.CurrentRangeIndex < 20)  //20
                        {
                           RotationFactor += (Gun.CurrentRangeIndex * CenterRotationFactor);
                        }
                        else
                        {
                           RotationFactor += (CenterRotationFactor * 20) + (((Gun.CurrentRangeIndex - 20) * 2) * CenterRotationFactor);
                        }
                    }

                    ScopeCenterRotator.Rotation.Yaw = RotationFactor;
                    //Canvas.DrawTileScaled(ScopeCenterRotator, Canvas.SizeY / 512.0 * ScopeCenterScale, Canvas.SizeY / 512.0 * ScopeCenterScale);
                    Canvas.DrawTileScaled(ScopeCenterRotator, Canvas.SizeY / 512.0 * ScopeCenterScale * 4/OverlayCenterScale/3, Canvas.SizeY / 512.0 * ScopeCenterScale * 4/OverlayCenterScale/3);

                    // Draw the range setting
                    if (Gun != none && bShowRangeText)
                    {
                       Canvas.Style = ERenderStyle.STY_Normal;
                       SavedColor = Canvas.DrawColor;
                       WhiteColor =  class'Canvas'.Static.MakeColor(255,255,255,175);
                       Canvas.DrawColor = WhiteColor;
                       MapX = RangePositionX * Canvas.ClipX;
                       MapY = RangePositionY * Canvas.ClipY;
                       Canvas.SetPos(MapX,MapY);
                       Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
                       Canvas.StrLen(Gun.GetRange()$" "$RangeText, XL, YL);
                       Canvas.DrawTextJustified(Gun.GetRange()$" "$RangeText, 2, MapX, MapY, MapX + XL, MapY+YL);
                       Canvas.DrawColor = SavedColor;
                    }
            }
            else if (DriverPositionIndex == PeriscopePositionIndex)
            {

                DrawPeriscopeOverlay(Canvas);
            }
            else
            {

                DrawBinocsOverlay(Canvas);
            }
        }

        // reset HudOpacity to original value
        Canvas.ColorModulate.W = SavedOpacity;

        // Draw tank, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
    }

     // Zap the lame crosshair - Ramm
    if (IsLocallyControlled() && Gun != none && Gun.bCorrectAim && Gun.bShowAimCrosshair)
    {
        Canvas.DrawColor = CrosshairColor;
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;
        Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
        Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0, CrosshairY*2.0, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
    }

    if (PC != none && !PC.bBehindView && HUDOverlay != none)
    {
        if (!Level.IsSoftwareRendering())
        {
            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
            HUDOverlay.SetRotation(CameraRotation);
            Canvas.DrawActor(HUDOverlay, false, false, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1, 170));
        }
    }
    else
        ActivateOverlay(false);
}

simulated function DrawPeriscopeOverlay(Canvas Canvas)
{
    local float ScreenRatio;

    ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
    Canvas.SetPos(0,0);
    Canvas.DrawTile(PeriscopeOverlay, Canvas.SizeX, Canvas.SizeY, 0.0 , (1 - ScreenRatio) * float(PeriscopeOverlay.VSize) / 2, PeriscopeOverlay.USize, float(PeriscopeOverlay.VSize) * ScreenRatio);
}

defaultproperties
{
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    ScopeCenterScale=0.635000
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.PZ3_Sight_Center'
    CenterRotationFactor=985
    OverlayCenterSize=0.830000
    PeriscopePositionIndex=1
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.PZ3_sight_destroyed'
    bManualTraverseOnly=true
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.PZ3_sight_graticule'
    ScopePositionX=0.237000
    ScopePositionY=0.150000
    bLockCameraDuringTransition=true
    WeaponFov=30.000000
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
    DriverPositions(0)=(ViewLocation=(X=30.000000,Y=-14.000000),ViewFOV=30.000000,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=16.000000,Y=-2.500000,Z=14.000000),ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer3_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer3_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext',ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    bMustBeTankCrew=false
    FireImpulse=(X=-15000.000000)
    GunClass=class'DH_Vehicles.DH_Sdkfz2342Cannon'
    CameraBone="Gun"
    MinRotateThreshold=0.500000
    MaxRotateThreshold=2.300000
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=true
    DrivePos=(X=4.000000,Z=-8.000000)
    DriveAnim="VPanzer3_com_idle_close"
    EntryRadius=130.000000
    FPCamPos=(X=50.000000,Y=-30.000000,Z=11.000000)
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    VehiclePositionString="in a Sdkfz 234/2 Armored Car cannon"
    VehicleNameString="Sdkfz 234/2 Armored Car cannon"
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}
