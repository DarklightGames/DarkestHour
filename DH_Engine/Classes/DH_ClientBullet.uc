//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ClientBullet extends ROClientBullet
    config(DH_Penetration)
    abstract;

var bool bInHitWall;

var float MaxWall;      // Maximum wall penetration
var float WScale;       // Penetration depth scale factor to take into account; weapon scale
var float Hardness;     // wall hardness, calculated in CheckWall for surface type

var globalconfig float  PenetrationScale;   // global Penetration depth scale factor
var globalconfig float  DistortionScale;    // global Distortion scale factor
var globalconfig bool   bDebugMode;         // If true, give our detailed report in log.
var globalconfig bool   bDebugROBallistics; // If true, set bDebugBallistics to true for getting the arrow pointers

var int WhizType;
// WhizType
// 0 = none
// 1 = close supersonic bullet
// 2 = subsonic or distant bullet

simulated function PostBeginPlay()
{
    if (bDebugROBallistics)
        bDebugBallistics = true;

    super.PostBeginPlay();
}

// original
simulated function ProcessTouch(Actor Other, vector HitLocation)
{
    local vector X, Y, Z;
    local float V;
    local bool  bHitWhipAttachment;
    local ROVehicleHitEffect VehEffect;
    local ROPawn HitPawn;

    local vector TempHitLocation, HitNormal;
    local array<int>    HitPoints;

    local float BulletDist;

//  local ROBulletWhipAttachment ROWhip;


    if (bDebugMode && Pawn(Other) != none) {
        if (instigator != none)
            instigator.ClientMessage("ProcessTouch"@Other@"HitLoc"@HitLocation@"Health"@Pawn(Other).Health@"Velocity"@VSize(Velocity));
        Log(self@" >>> ProcessTouch"@Pawn(Other).PlayerReplicationInfo.PlayerName@"HitLoc"@HitLocation@"Health"@Pawn(Other).Health@"Velocity"@VSize(Velocity));
    }

    if (bDebugMode) log(">>>"@Other@"=="@Instigator@"||"@Other.Base@"=="@Instigator@"||"@!Other.bBlockHitPointTraces);

//  super.ProcessTouch(Other, HitLocation);
    //>>>>
    if (Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces)
        return;
    if (bDebugMode) log(">>> ProcessTouch 3");

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (ROVehicleWeapon(Other) != none && !ROVehicleWeapon(Other).HitDriverArea(HitLocation, Velocity))
        {
            VehEffect = Spawn(class'ROVehicleHitEffect',,, HitLocation, rotator(Normal(Velocity)) /*rotator(-HitNormal)*/);
            VehEffect.InitHitEffects(HitLocation,Normal(-Velocity));
        }
    }

    V = VSize(Velocity);

    if (bDebugMode) log(">>> ProcessTouch 4"@Other);

    if (bDebugMode && Pawn(Other) != none) {
        if (instigator != none)
            instigator.ClientMessage("ProcessTouch Velocity"@VSize(Velocity)@Velocity);
        Log(self@" >>> ProcessTouch Velocity"@VSize(Velocity)@Velocity);
    }

    // If the bullet collides right after launch, it doesn't have any velocity yet.
    // Use the rotation instead and give it the default speed - Ramm
    if (V < 25)
    {
        if (bDebugMode) log(">>> ProcessTouch 5a ... V < 25");
        GetAxes(Rotation, X, Y, Z);
        V=default.Speed;
    }
    else
    {
        if (bDebugMode) log(">>> ProcessTouch 5b ... GetAxes");
        GetAxes(Rotator(Velocity), X, Y, Z);
    }

    if (ROBulletWhipAttachment(Other) != none)
    {
        if (bDebugMode) log(">>> ProcessTouch ROBulletWhipAttachment ... ");
        bHitWhipAttachment=true;

        if (!Other.Base.bDeleteMe)
        {
            // If bullet collides immediately after launch, it has no location (or so it would appear, go figure)
            // Lets check against the firer's location instead
            if (OrigLoc == vect(0.00,0.00,0.00))
                OrigLoc = Instigator.Location;

            BulletDist = VSize(Location - OrigLoc) / 60.352; // Calculate distance travelled by bullet in metres

            // If it's FF at close range, we won't suppress, so send a different WT through
            if (BulletDist < 10.0 && Instigator != none && Instigator.Controller != none && Other != none && Other.Base != none && DH_Pawn(Other.Base) != none && DH_Pawn(Other.Base).Controller != none && Instigator.Controller.SameTeamAs(DH_Pawn(Other.Base).Controller))
                WhizType = 3;

            if ((BulletDist < 20.0) && WhizType == 1) // Bullets only "snap" after a certain distance in reality, same goes here
            {
                WhizType = 2;
            }

            Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (65535 * X), HitPoints, HitLocation,, WhizType);   //1
//          Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (10000 * X), HitPoints, HitLocation,, WhizType);
        if (bDebugMode) log(">>> ProcessTouch HitPointTrace ... "@Other);

            if (Other == none)
            {
                WhizType = default.WhizType; // Reset for the next collision
                return;
            }

            HitPawn = DH_Pawn(Other);
        }
        else
        {
            return;
        }
    }

    if (bDebugMode) log(">>> ProcessTouch MinPenetrateVelocity ... "@V@">"@(MinPenetrateVelocity * ScaleFactor));
    if (V > MinPenetrateVelocity * ScaleFactor)
    {
        if (Role == ROLE_Authority)
        {
            if (HitPawn != none)
            {
                // Hit detection debugging
                /*log("Bullet hit "$HitPawn.PlayerReplicationInfo.PlayerName);
                HitPawn.HitStart = HitLocation;
                HitPawn.HitEnd = HitLocation + (65535 * X);*/
                if (bDebugMode) log(">>> ProcessTouch ProcessLocationalDamage ... "@HitPawn);

                if (!HitPawn.bDeleteMe)
                    HitPawn.ProcessLocationalDamage(Damage - 20 * (1 - V / default.Speed), Instigator, TempHitLocation, MomentumTransfer * X, MyDamageType,HitPoints);

                // Hit detection debugging
                //if (Level.NetMode == NM_Standalone)
                //  HitPawn.DrawBoneLocation();

                 bHitWhipAttachment = false;
            }
            else
            {
                if (bDebugMode) log(">>> ProcessTouch Other.TakeDamage ... "@Other);
                Other.TakeDamage(Damage - 20 * (1 - V / default.Speed), Instigator, HitLocation, MomentumTransfer * X, MyDamageType);
            }
        }
        else
        {
            if (bDebugMode) log(">>> ProcessTouch Nothing cClientside... ");

            if (HitPawn != none)
            {
                bHitWhipAttachment = false;
            }
        }
    }

    if (bDebugMode && Pawn(Other) != none) {
        if (instigator != none)
            instigator.ClientMessage("result ProcessTouch"@Other@"HitLoc"@HitLocation@"Health"@Pawn(Other).Health);
        Log(self@" >>> result ProcessTouch"@Pawn(Other).PlayerReplicationInfo.PlayerName@"HitLoc"@HitLocation@"Health"@Pawn(Other).Health);
    }

     if (!bHitWhipAttachment)
        Destroy();

}

defaultproperties
{
     WScale=1.000000
     PenetrationScale=0.080000
     DistortionScale=0.400000
     WhizType=1
}
