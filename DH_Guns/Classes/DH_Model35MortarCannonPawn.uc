//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] replace mortar round names
// [ ] calibrate range table
// [ ] UI elements for clock image
// [ ] replace pitch/yaw sounds with squeaking wheels used on the other mortars
// [ ] adjust yaw dials to be more precise
// [ ] reduce spread of mortar rounds
// [ ] replace firing effects
// [ ] remove reloading sounds
// [ ] add mortar player idle animations
// [ ] figure out a system for the firing animations
// [ ] increase off-gun rotation speed
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

simulated function InitializeVehicleAndWeapon()
{
    super.InitializeVehicleAndWeapon();

    if (Level.NetMode != NM_DedicatedServer)
    {
        SetupGunAnimationDrivers();
        UpdateGunAnimationDrivers();
    }
}

simulated function SuperFire(optional float F)
{
    super.Fire(F);
}

simulated function Fire(optional float F)
{
    // TODO: only if the player *CAN* fire.

    GotoState('Firing');
}

// New state for the mortar to play the firing animation.
simulated state Firing
{
    // Don't let the user move, leave, or change the round type while firing.
    function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange) { }
    simulated function Fire(optional float F) { }
    exec simulated function SwitchFireMode() { }
    function bool KDriverLeave(bool bForceLeave) { return false; }
    simulated function NextWeapon() { }
    simulated function PrevWeapon() { }

    simulated function BeginState()
    {
        // Turn off the audio of the pitch/yaw sounds.

        Log("In Firing state");
    }

Begin:
    Sleep(3.0);
    if (Role == ROLE_Authority)
    {
        GotoState('ServerFire');
    }
    else
    {
        // Non-authoritative clients should just go back to the default state.
        GotoState('');
    }
}

simulated state ServerFire
{
    simulated function BeginState()
    {
        // Fire the round.
        super.Fire();

        GotoState('');
    }
}

// TODO: add in functionality for firing the mortar to play the animation, then spawn the projectile.

simulated function SetupGunAnimationDrivers()
{
    Gun.AnimBlendParams(PitchAnimationDriver.Channel, 1.0, 0.0, 0.0, PitchAnimationDriver.BoneName);
    Gun.PlayAnim(PitchAnimationDriver.SequenceName, 1.0, 0.0, PitchAnimationDriver.Channel);
    UpdateGunAnimationDrivers();
}

simulated function UpdateGunAnimationDrivers()
{
    local float Time;

    if (Gun != none)
    {
        Time = class'UInterp'.static.MapRangeClamped(
            GetGunPitch(),
            GetGunPitchMin(), GetGunPitchMax(),
            PitchAnimationDriver.SequenceFrameCount, 0.0
            );

        Gun.FreezeAnimAt(Time, PitchAnimationDriver.Channel);
    }
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

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

    OverlayCorrectionX=0
    OverlayCorrectionY=0

    AmmoShellTexture=Texture'DH_LeIG18_tex.HUD.leig18_he'   // TODO: swap it out
    AmmoShellReloadTexture=Texture'DH_LeIG18_tex.HUD.leig18_he_reload'
    ArtillerySpottingScopeClass=class'DH_Guns.DHArtillerySpottingScope_Model35Mortar'

    GunPitchOffset=7280 // +40 degrees
}
