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

var int   LifespanTime;          // how long something can be hogged for rotation
var float ControlRadiusInMeters; // how far a controlling player can stray away

replication
{
    unreliable if (RemoteRole == ROLE_SimulatedProxy && Physics == PHYS_Rotating)
       UpdateRotation;
}

delegate OnDestroyed(int Time);

simulated event PostBeginPlay()
{
    DesiredRotation = Rotation;
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
    // TODO: Notify why he was thrown out of the rotaion mode
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

    DesiredRotation.Yaw += RotationFactor * RotationRate.Yaw * DeltaTime;
}

defaultproperties
{
    Physics=PHYS_Rotating
    RotationRate=(Pitch=2048,Yaw=2048,Roll=2048)
    RemoteRole=ROLE_SimulatedProxy
    bReplicateMovement=true
    bNetInitialRotation=true
    bAlwaysRelevant=true
    bRotateToDesired=true
    LifespanTime=20
    ControlRadiusInMeters=5.0
}
