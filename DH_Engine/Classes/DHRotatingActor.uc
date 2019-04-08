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

var vector GroundSearch;
var vector rotationAxes; // the ground normal about which this rotator will rotate.
var Rotator InitalRotation;
var Rotator YawRot;

var Rotator SavedRot;
var Rotator SentinelRot;

var int   LifespanTime;          // how long something can be hogged for rotation
var float ControlRadiusInMeters; // how far a controlling player can stray away


replication
{
//    unreliable if (RemoteRole == ROLE_SimulatedProxy && Physics == PHYS_Rotating)
 //      UpdateRotation;
//     unreliable if (RemoteRole == ROLE_SimulatedProxy)
//       UpdateRotation;
 //   reliable if (Role == ROLE_Authority)
 //       RotationFactor;
//    reliable if (Role == ROLE_Authority)
//        DesiredRotation;

//        reliable if ( Role == ROLE_Authority)
//            SentinelRot;
}

delegate OnDestroyed(int Time);

simulated event PostBeginPlay()
{
    local vector TraceHitLocation;
    local vector TraceHitNormal;
    DesiredRotation = Rotation;

    InitalRotation = Rotation;
    SentinelRot = DesiredRotation;

    ControlRadius = class'DHUnits'.static.MetersToUnreal(ControlRadiusInMeters);
    //Log(Role@RemoteRole);
    // ray trace down, and get ground normal. This will be the axes we will rotate about.
    //Trace(TraceHitLocation, TraceHitNormal, Location + GroundSearch, Location, false);

    //Log("Ground Normal: "$TraceHitNormal);
    //DrawStayingDebugLine(Location,Location + (1000 * rotationAxes),255,10,255);

    //rotationAxes = TraceHitNormal;
    //if(Role == ROLE_SimulatedProxy)
    //SetPhysics(PHYS_None);

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
    //Log("Bingo"$RotationFactor);
    UpdateRotation(DeltaTime);
}

function SetRotationFactor(int RotationFactor)
{
    Log("Set Rotation Factor");
    self.RotationFactor = RotationFactor;
}

//simulated function UpdateRotation(float DeltaTime)
//simulated function UpdateRotation(float DeltaTime)
simulated function UpdateRotation(float DeltaTime)
{

    local Quat RotationDelta;
    local Vector testAxes;

    if (RotationFactor == 0)
    {
        return;
    }
    testAxes.X=0;
    testAxes.Y=1;
    testAxes.Z=0;

    YawRot.Pitch =0;

    YawRot.Yaw += RotationFactor * RotationRate.Yaw * DeltaTime;
    //Log("Update: "$YawRot.Yaw);

    YawRot.Roll = 0;


    DesiredRotation =  QuatToRotator( QuatProduct(  QuatFromRotator(YawRot) , QuatFromRotator(InitalRotation)  )  );


    SentinelRot = DesiredRotation;

    //create a rotation about the normal axis using QuatFromAxisAndAngle(GroundNormal, RotationRate);


    //RotationDelta = QuatFromAxisAndAngle(testAxes, RotationFactor * RotationRate.Yaw * DeltaTime * ((pi / 32768)));


    //MY WAY
    //RotationDelta = QuatFromAxisAndAngle(rotationAxes, RotationFactor * RotationRate.Yaw * DeltaTime * ((pi / 32768)));
    //DesiredRotation =  QuatToRotator( QuatProduct(  RotationDeltaQuat,FromRotator(DesiredRotation)));



    //acc +=  RotationRate.Yaw * DeltaTime * (pi / 32768.0);
    //DrawStayingDebugLine(Location,Location + (1000 * rotationAxes),255,10,255);
    //RotationDelta = QuatFromAxisAndAngle(rotationAxes, acc);
    //DesiredRotation = QuatToRotator(RotationDelta);
    //DesiredRotation =  QuatToRotator( QuatProduct(   QuatFromRotator(DesiredRotation),RotationDelta ));


    /*
    YawRot.Pitch = 0;
    YawRot.Yaw = RotationFactor * RotationRate.Yaw * DeltaTime;
    YawRot.Roll = 0;
    DesiredRotation = QuatToRotator(QuatProduct( QuatFromRotator(YawRot),QuatFromRotator(DesiredRotation)));
    */



    //DesiredRotation.Yaw += RotationFactor * RotationRate.Yaw * DeltaTime;
    //DesiredRotation.Pitch += RotationFactor * RotationRate.Yaw * DeltaTime;

}

simulated event PostNetReceive()
{
    super.PostNetReceive();

    DesiredRotation = SentinelRot;


}


defaultproperties
{

    Physics=PHYS_Rotating
    RotationRate=(Pitch=2048,Yaw=2048,Roll=2048)
    YawRot=(Pitch=0,Yaw=0,Roll=0)
    GroundSearch=(X=0,Y=0,Z=-100)
    RemoteRole=ROLE_SimulatedProxy

    //bReplicateMovement=true
    bReplicateMovement=true


    bNetInitialRotation=true
    bAlwaysRelevant=true

    bRotateToDesired=true



    LifespanTime=20
    ControlRadiusInMeters=5.0


    //bNetNotify=true
}
