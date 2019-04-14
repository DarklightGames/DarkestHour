//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHRotatingActor extends Actor;

var DHGameReplicationInfo DHGRI;
var DHPawn ControllerPawn;

var int   RotationFactor;
var int   ExpiryTime;
var float ControlRadius;

var Rotator InitalRotation;
var Rotator YawRot;

var int   LifespanTime;          // how long something can be hogged for rotation
var float ControlRadiusInMeters; // how far a controlling player can stray away

delegate OnDestroyed(int Time);

simulated event PostBeginPlay()
{
    local vector TraceHitLocation;
    local vector TraceHitNormal;

    DesiredRotation = Rotation;

    InitalRotation = Rotation;

    ControlRadius = class'DHUnits'.static.MetersToUnreal(ControlRadiusInMeters);
}

event PostNetBeginPlay()
{
    DHGRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (DHGRI != none && LifespanTime > 0)
    {
        ExpiryTime = DHGRI.ElapsedTime + LifespanTime;

        SetTimer(1.0, true);
    }
}

event Destroyed()
{
    OnDestroyed(DHGRI.ElapsedTime);
}

simulated function Timer()
{
    // End rotation if the player takes too long or strayed too far
    // TODO: Notify why he was thrown out of the rotation mode
    if ((DHGRI != none && DHGRI.ElapsedTime > ExpiryTime) ||
        (ControllerPawn != none && VSize(ControllerPawn.Location - Location) > ControlRadius))
    {
        Destroy();
    }
}

simulated function Tick(float DeltaTime)
{
    UpdateRotation(DeltaTime);
}

function SetRotationFactor(int RotationFactor)
{
    self.RotationFactor = RotationFactor;
}

simulated function UpdateRotation(float DeltaTime)
{
    if (RotationFactor == 0)
    {
        return;
    }

    YawRot.Pitch =0;
    YawRot.Yaw += RotationFactor * RotationRate.Yaw * DeltaTime;
    YawRot.Roll = 0;

    DesiredRotation = QuatToRotator(QuatProduct(QuatFromRotator(YawRot), QuatFromRotator(InitalRotation)));
}

defaultproperties
{
    Physics=PHYS_Rotating
    RotationRate=(Pitch=2048,Yaw=2048,Roll=2048)
    YawRot=(Pitch=0,Yaw=0,Roll=0)
    RemoteRole=ROLE_SimulatedProxy

    Texture = none

    bReplicateMovement=true
    bNetInitialRotation=true
    bAlwaysRelevant=true
    bRotateToDesired=true

    LifespanTime=20
    ControlRadiusInMeters=5.0
}
