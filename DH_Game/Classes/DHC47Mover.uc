//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHC47Mover extends DHVariableTimedMover;

var(InitialAnimation)   name    AnimName;
var(InitialAnimation)   float   AnimRate;

simulated function BeginPlay()
{
    local AntiPortalActor AntiPortalA;

LoopAnim(AnimName, AnimRate);               //DH - loop the anim

    if (AntiPortalTag != '')
    {
        foreach AllActors(class'AntiPortalActor',AntiPortalA,AntiPortalTag)
        {
            AntiPortals.Length = AntiPortals.Length + 1;
            AntiPortals[AntiPortals.Length - 1] = AntiPortalA;
        }
    }

    // timer updates real position every second in network play
    if (Level.NetMode != NM_Standalone)
    {
        if (Level.NetMode == NM_Client && bClientAuthoritative)
            settimer(4.0, true);
        else
            settimer(1.0, true);
        if (Role < ROLE_Authority)
            return;
    }

    RealPosition = Location;
    RealRotation = Rotation;

    // Init key info.
    super.BeginPlay();
    KeyNum         = Clamp(KeyNum, 0, arraycount(KeyPos)-1);
    PhysAlpha      = 0.0;
    StartKeyNum = KeyNum;

    // Set initial location.
    Move(BasePos + KeyPos[KeyNum] - Location);

    // Initial rotation.
    SetRotation(BaseRot + KeyRot[KeyNum]);

    // find movers in same group
    if (ReturnGroup == '')
        ReturnGroup = tag;
    Leader = none;
    Follower = none;
}

defaultproperties
{
    AnimName="c47_in_flight"
    AnimRate=1.0
    DrawType=DT_Mesh
    CullDistance=16000.0
    Mesh=SkeletalMesh'DH_C47_anm.FlyingC47'
    CollisionRadius=1800.0
    CollisionHeight=400.0
    bBlockKarma=true
}
