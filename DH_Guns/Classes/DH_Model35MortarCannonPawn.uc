//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] make the gunsight camera always have zero roll
// [ ] make sure gunsight camera calculation is correct (seems wrong!)
// [ ] fix issue with pitch limits
// [ ] replace mortar round names
// [ ] calibrate range table
// [ ] UI elements for clock image
// [ ] replace pitch/yaw sounds with squeaking wheels
// [ ] fix karma collision issue (aiming straight up kills the gun)
// [ ] adjust yaw dials to be more precise
// [ ] reduce spread of mortar rounds
// [ ] replace firing effects
// [ ] remove reloading sounds
// [ ] add animation to look at gunsight
// [ ] add mortar player idle animations
// [ ] figure out a system for the firing animations
// [ ] increase off-gun rotation speed
// [ ] fix bug where you can start rotating an AT gun while reloading (causes bugs)
//==============================================================================
class DH_Model35MortarCannonPawn extends DHATGunCannonPawn;

struct SAnimationDriver
{
    var int Channel;
    var name BoneName;
    var name SequenceName;
    var int SequenceFrameCount;
};

var SAnimationDriver PitchAnimationDriver;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SetupGunAnimationDrivers();
}

function int CustomLimitPitch(int Pitch)
{
    // Limit the pitch to the range of the gun.
    return Clamp(Pitch, GetGunPitchMin(), GetGunPitchMax());
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Role == ROLE_Authority)
    {
        // Put it right in the middle by default.
        // DOESN'T DO SHIT
        Gun.CurrentAim.Pitch = (GetGunPitchMin() + GetGunPitchMax()) / 2;
    }
}

simulated function SetupGunAnimationDrivers()
{
    Gun.AnimBlendParams(PitchAnimationDriver.Channel, 1.0, 0.0, 0.0, PitchAnimationDriver.BoneName);
    Gun.PlayAnim(PitchAnimationDriver.SequenceName, 1.0, 0.0, PitchAnimationDriver.Channel);
    UpdateGunAnimationDrivers();
}

simulated function UpdateGunAnimationDrivers()
{
    local float Time;

    if (Gun == none)
    {
        return;
    }

    Time = class'UInterp'.static.MapRangeClamped(
        GetGunPitch(),
        GetGunPitchMin(), GetGunPitchMax(),
        PitchAnimationDriver.SequenceFrameCount, 0.0
        );

    Gun.FreezeAnimAt(Time, PitchAnimationDriver.Channel);

    // TODO: get the current pitch of the gun and convert it to a 0..1 value to be used to setting the animation frame.

    // Calculate the correct bone rotation based on the yaw & pitch. (Yaw first, then pitch, then translate to local space).
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    // Only do this for clients.
    // The server will update the animation driver right before firing so that it gets the right firing position.
    if (Level.NetMode != NM_DedicatedServer)
    {
        UpdateGunAnimationDrivers();
    }
}

defaultproperties
{
    PitchAnimationDriver=(Channel=1,BoneName="PITCH_ROOT",SequenceName="PITCH_DRIVER",SequenceFrameCount=30)

    GunClass=class'DH_Guns.DH_Model35MortarCannon'

    // spotting scope
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="overlay_out",ViewFOV=40.0,ViewPitchUpLimit=2731,ViewPitchDownLimit=64626,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true,bExposed=true)
    // kneeling
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext',DriverTransitionAnim="crouch_idle_binoc",TransitionUpAnim="com_open",TransitionDownAnim="overlay_in",ViewPitchUpLimit=8192,ViewPitchDownLimit=55000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // standing
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext',DriverTransitionAnim="stand_idlehip_binoc",TransitionDownAnim="com_close",ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    // binoculars
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext',DriverTransitionAnim="stand_idleiron_binoc",ViewFOV=12.0,ViewPitchUpLimit=6000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)

    PlayerCameraBone="CAMERA_COM"
    CameraBone="GUNSIGHT_CAMERA"

    GunsightPositions=0
    UnbuttonedPositionIndex=0
    SpottingScopePositionIndex=0
    IntermediatePositionIndex=1 // the open sights position (used to play a special 'intermediate' firing anim in that position)
    RaisedPositionIndex=2
    BinocPositionIndex=3

    bLockCameraDuringTransition=true

    DrivePos=(X=0,Y=0.0,Z=60.0)
    DriveAnim="crouch_idle_binoc"

    GunsightOverlay=Texture'DH_VehicleOptics_tex.German.ZF_II_3x8_Pak'
    GunsightSize=0.282 // 8 degrees visible FOV at 3x magnification (ZF 3x8 Pak sight)

    OverlayCorrectionX=0
    OverlayCorrectionY=0

    AmmoShellTexture=Texture'DH_LeIG18_tex.HUD.leig18_he'   // TODO: swap it out
    AmmoShellReloadTexture=Texture'DH_LeIG18_tex.HUD.leig18_he_reload'
    ArtillerySpottingScopeClass=class'DH_Guns.DHArtillerySpottingScope_M116'
}
