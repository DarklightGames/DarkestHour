//=============================================================================
// The moving brush class.
// This is a built-in Unreal class and it shouldn't be modified.
// Note that movers by default have bNoDelete==true.  This makes movers and their default properties
// remain on the client side.  If a mover subclass has bNoDelete=false, then its default properties must
// be replicated
//=============================================================================
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
    Super.BeginPlay();
    KeyNum         = Clamp(KeyNum, 0, ArrayCount(KeyPos)-1);
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

/*
function PostBeginPlay()
{
    local int n;

        AnimName='c47_in_flight';
    LoopAnim(AnimName, 1);              //DH - loop the anim

    for (n = 0; n < KeyMoveTime.length; n++)
        KeyMoveSpeed[n] = KeyMoveTime[n] * MoveTime;

    Super.PostBeginPlay();

    MoveTime = KeyMoveSpeed[ KeyNum ];

    if (bActAsClientMover && Level.NetMode == NM_DedicatedServer)
    {
        SetTimer(0, false);
        SetPhysics(PHYS_none);
        GotoState('ServerIdle');
    }
}
*/

defaultproperties
{
     AnimName="c47_in_flight"
     AnimRate=1.000000
     DrawType=DT_Mesh
     CullDistance=16000.000000
     Mesh=SkeletalMesh'DH_C47_anm.FlyingC47'
     CollisionRadius=1800.000000
     CollisionHeight=400.000000
     bBlockKarma=true
}
