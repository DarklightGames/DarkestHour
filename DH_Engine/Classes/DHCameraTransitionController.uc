//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCameraTransitionController extends Object;

var private name CurrentCameraBone;
var private Vector CameraLocation;
var private Rotator CameraRotation;

struct CameraTransition
{
    var name TargetCameraBone;
    var float StartTimeSeconds;
    var float EndTimeSeconds;
    var UInterp.EInterpolationType InterpolationType;
};
// The list of currently queued camera transitions.
var private array<CameraTransition> CameraTransitions;

function SetCurrentCameraBone(name NewCameraBone)
{
    CurrentCameraBone = NewCameraBone;
}

// Queuing assumes that the caller will ensure that transitions are correctly ordered and do not overlap in time.
function QueueCameraTransition(name TargetCameraBone, float StartTimeSeconds, float DurationSeconds, UInterp.EInterpolationType InterpolationType)
{
    local CameraTransition NewTransition;

    NewTransition.TargetCameraBone = TargetCameraBone;
    NewTransition.StartTimeSeconds = StartTimeSeconds;
    NewTransition.EndTimeSeconds = StartTimeSeconds + DurationSeconds;
    NewTransition.InterpolationType = InterpolationType;

    CameraTransitions[CameraTransitions.Length] = NewTransition;
}

// Tick function to update the camera location and rotation based on state and active transitions.
function Tick(Actor Actor, float TimeSeconds)
{
    local int i;
    local CameraTransition ActiveTransition;
    local name TargetCameraBone;
    local Vector CurrentLocation, TargetLocation;
    local Rotator CurrentRotation, TargetRotation;
    local float Alpha;

    // Calculate the current bone's location and rotation.
    CurrentLocation = Actor.GetBoneCoords(CurrentCameraBone).Origin;
    CurrentRotation = Actor.GetBoneRotation(CurrentCameraBone);

    if (CameraTransitions.Length == 0)
    {
        // No active transitions, just use the current bone.
        CameraLocation = CurrentLocation;
        CameraRotation = CurrentRotation;
        return;
    }

    ActiveTransition = CameraTransitions[0];

    // Make sure we're within the transition time range.
    if (TimeSeconds < ActiveTransition.StartTimeSeconds)
    {
        // Not yet started; use current bone.
        CameraLocation = CurrentLocation;
        CameraRotation = CurrentRotation;
        return;
    }

    // There is an active transition; interpolate towards the target bone.
    // Calculate the target bone's location and rotation.
    TargetLocation = Actor.GetBoneCoords(ActiveTransition.TargetCameraBone).Origin;
    TargetRotation = Actor.GetBoneRotation(ActiveTransition.TargetCameraBone);

    // Calculate interpolation alpha based on time and interpolation type.
    Alpha = (TimeSeconds - ActiveTransition.StartTimeSeconds) / (ActiveTransition.EndTimeSeconds - ActiveTransition.StartTimeSeconds);
    Alpha = FClamp(Alpha, 0.0, 1.0);
    Alpha = Class'UInterp'.static.Interpolate(Alpha, 0.0, 1.0, ActiveTransition.InterpolationType);

    // Interpolate location and rotation.
    CameraLocation = Class'UVector'.static.VLerp(Alpha, CurrentLocation, TargetLocation);
    CameraRotation = Class'URotator'.static.RLerp(CurrentRotation, TargetRotation, Alpha);

    if (Alpha >= 1.0)
    {
        // Transition complete; update current camera bone and remove the transition.
        CurrentCameraBone = ActiveTransition.TargetCameraBone;
        CameraTransitions.Remove(0, 1);
    }
}

function GetCameraLocationAndRotation(out Vector OutLocation, out Rotator OutRotation)
{
    OutLocation = CameraLocation;
    OutRotation = CameraRotation;
}
