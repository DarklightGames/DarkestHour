class DH_Flakvierling38CannonPawn extends DH_ATGunTwoCannonPawn;

#exec OBJ LOAD FILE=..\Animations\DH_Flakvierling38_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Flakvierling38_tex.utx

function IncrementRange() { }
function DecrementRange() { }

simulated exec function SwitchFireMode()
{
    if (Gun != none && ROTankCannon(Gun) != none && ROTankCannon(Gun).bMultipleRoundTypes)
    {
        if (Controller != none && ROPlayer(Controller) != none)
            ROPlayer(Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick',false,,SLOT_Interface);

        ServerToggleExtraRoundType();
    }
}

function ServerToggleExtraRoundType()
{
    if (Gun != none && ROTankCannon(Gun) != none)
    {
        ROTankCannon(Gun).ToggleRoundType();
    }
}

function Fire(optional float F)
{
    if (DriverPositionIndex == 2 || DriverPositionIndex == BinocPositionIndex && ROPlayer(Controller) != none)
    {
        return;
    }

    super.Fire(F);
}

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector CameraLocation;
    local rotator CameraRotation;
    local Actor ViewActor;
    local float SavedOpacity;

    local float ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

    PC = PlayerController(Controller);
    if (PC == none)
    {
        Super.RenderOverlays(Canvas);
        //log("PanzerTurret PlayerController was none, returning");
        return;
    }
    else if (!PC.bBehindView)
    {
        // store old opacity and set to 1.0 for map overlay rendering
        SavedOpacity = Canvas.ColorModulate.W;
        Canvas.ColorModulate.W = 1.0;

        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            if (DriverPositionIndex == 0)
            {

            // Calculate reticle drawing position (and position to draw black bars at)

              // Draw reticle
              ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
              OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
              OverlayCenterTexStart = (1 - OverlayCenterScale) * float(CannonScopeOverlay.USize) / 2;
              OverlayCenterTexSize =  float(CannonScopeOverlay.USize) * OverlayCenterScale;

              Canvas.SetPos(0, 0);
              Canvas.DrawTile(CannonScopeOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);
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

defaultproperties
{
     CannonScopeOverlay=Texture'DH_Flakvierling38_tex.flak.flakv38_sight'
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.2341Mag_reload'
     DriverPositions(0)=(ViewLocation=(X=30.000000),ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Flakvierling38_anm.flak_turret',TransitionUpAnim="optic_out",DriverTransitionAnim="Vt3485_driver_idle_close",bDrawOverlays=true,bExposed=true)
     DriverPositions(1)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Flakvierling38_anm.flak_turret',TransitionUpAnim="lookover_up",TransitionDownAnim="optic_in",DriverTransitionAnim="Vt3485_driver_idle_close",bExposed=true)
     DriverPositions(2)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Flakvierling38_anm.flak_turret',TransitionDownAnim="lookover_down",DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
     DriverPositions(3)=(ViewFOV=18.000000,PositionMesh=SkeletalMesh'DH_Flakvierling38_anm.flak_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
     bMustBeTankCrew=true
     GunClass=Class'DH_Guns.DH_Flakvierling38Cannon'
     CameraBone="Camera_com"
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     PitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     RotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     DriveAnim="Vt3485_driver_idle_close"
     ExitPositions(0)=(X=-150.000000,Y=0.000000,Z=0.000000)
     ExitPositions(1)=(X=-100.000000,Y=0.000000,Z=0.000000)
     ExitPositions(2)=(X=-100.000000,Y=20.000000,Z=0.000000)
     ExitPositions(3)=(X=-100.000000,Y=-20.000000,Z=0.000000)
     ExitPositions(4)=(Y=50.000000,Z=0.000000)
     ExitPositions(5)=(Y=-50.000000,Z=0.000000)
     ExitPositions(6)=(X=-50.000000,Y=-50.000000,Z=0.000000)
     ExitPositions(7)=(X=-50.000000,Y=50.000000,Z=0.000000)
     ExitPositions(8)=(X=-75.000000,Y=75.000000,Z=0.000000)
     ExitPositions(9)=(X=-75.000000,Y=-75.000000,Z=0.000000)
     ExitPositions(10)=(X=-40.000000,Y=0.000000,Z=5.000000)
     ExitPositions(11)=(X=-60.000000,Y=0.000000,Z=5.000000)
     ExitPositions(12)=(X=-60.000000,Z=10.000000)
     ExitPositions(13)=(X=-60.000000,Z=15.000000)
     ExitPositions(14)=(X=-60.000000,Z=20.000000)
     ExitPositions(15)=(Z=5.000000)
     TPCamDistance=2048.000000
     TPCamLookat=(X=25.000000)
     TPCamWorldOffset=(Z=0.000000)
     VehiclePositionString="Using a Flakvierling 38"
     VehicleNameString="Flakvierling 38"
     bKeepDriverAuxCollision=true
}
