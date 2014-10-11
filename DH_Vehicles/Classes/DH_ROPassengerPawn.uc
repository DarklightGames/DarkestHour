//==============================================================================
// DH_ROPassengerPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Base class for Darkest Hour Passenger Pawns - sets rotation, bailing dmg, etc
//==============================================================================
class DH_ROPassengerPawn extends ROPassengerPawn;

struct ExitPositionPair
{
    var int Index;
    var float DistanceSquared;
};

var bool bDebugExitPositions;

static final operator(24) bool > (ExitPositionPair A, ExitPositionPair B)
{
    return A.DistanceSquared > B.DistanceSquared;
}

//http://wiki.beyondunreal.com/Legacy:Insertion_Sort
static final function InsertSortEPPArray(out array<ExitPositionPair> MyArray, int LowerBound, int UpperBound)
{
    local int InsertIndex, RemovedIndex;

    if (LowerBound < UpperBound)
    {
        for (RemovedIndex = LowerBound + 1; RemovedIndex <= UpperBound; ++RemovedIndex)
        {
            InsertIndex = RemovedIndex;

            while (InsertIndex > LowerBound && MyArray[InsertIndex - 1] > MyArray[RemovedIndex])
            {
                --InsertIndex;
            }

            if ( RemovedIndex != InsertIndex )
            {
                MyArray.Insert(InsertIndex, 1);
                MyArray[InsertIndex] = MyArray[RemovedIndex + 1];
                MyArray.Remove(RemovedIndex + 1, 1);
            }
        }
    }
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
	{
		bTearOff = true;
	}
}

// Overridden to stop the game playing silly buggers with exit positions while moving and breaking my damage code
function bool PlaceExitingDriver()
{
    local int i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;
    local array<ExitPositionPair> ExitPositionPairs;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1, 1, 0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0, 0, 0.5);

    if (VehicleBase == none)
    {
        return false;
    }

    ExitPositionPairs.Length = VehicleBase.ExitPositions.Length;

    for (i = 0; i < VehicleBase.ExitPositions.Length; ++i)
    {
        ExitPositionPairs[i].Index = i;
        ExitPositionPairs[i].DistanceSquared = VSizeSquared(DrivePos - VehicleBase.ExitPositions[i]);
    }

    InsertSortEPPArray(ExitPositionPairs, 0, ExitPositionPairs.Length - 1);

    if (bDebugExitPositions)
    {
        for (i = 0; i < ExitPositionPairs.Length; ++i)
        {
            ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[ExitPositionPairs[i].Index] >> VehicleBase.Rotation) + ZOffset;

            Spawn(class'RODebugTracer',,,ExitPosition);
        }
    }

    for (i = 0; i < ExitPositionPairs.Length; ++i)
    {
        ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[ExitPositionPairs[i].Index] >> VehicleBase.Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, VehicleBase.Location + ZOffset, false, Extent) != none ||
            Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) != none)
        {
            continue;
        }

        if (Driver.SetLocation(ExitPosition))
        {
            Level.Game.Broadcast(self, ExitPosition);

            return true;
        }
    }

    return false;
}

// Overridden to set passenger exit rotation to be the same as when they were in the vehicle - looks a bit silly otherwise
simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    NewRot = GetVehicleBase().Rotation;
    NewRot.Pitch = LimitPitch(NewRot.Pitch);
    SetRotation(NewRot);

    Super.ClientKDriverLeave(PC);
}

function KDriverEnter(Pawn P)
{
    bTearOff = false;

    super.KDriverEnter(P);
}

// Overridden to give players the same momentum as their vehicle had when exiting
// Adds a little height kick to allow for hacked in damage system
function bool KDriverLeave(bool bForceLeave)
{
    local vector OldVel;
    local bool   bSuperDriverLeave;

    if (!bForceLeave)
    {
        OldVel = VehicleBase.Velocity;

        bSuperDriverLeave = super.KDriverLeave(bForceLeave);

        OldVel.Z += 50;
        Instigator.Velocity = OldVel;
    }
    else
    {
        bSuperDriverLeave = super.KDriverLeave(bForceLeave);
    }

    if (bSuperDriverLeave)
    {
        NetUpdateTime = Level.TimeSeconds + 6.0;

        bTearOff = true;
    }

    return bSuperDriverLeave;
}

function DriverDied()
{
	super.DriverDied();

	NetUpdateTime = Level.TimeSeconds + 6.0;

	bTearOff = true;
}

function bool TryToDrive(Pawn P)
{
    if (VehicleBase != none)
    {
        if (VehicleBase.NeedsFlip())
        {
            VehicleBase.Flip(vector(P.Rotation), 1);

            return false;
        }

        if (P.GetTeamNum() != VehicleBase.VehicleTeam)
        {
            if (VehicleBase.Driver == none)
            {
                return VehicleBase.TryToDrive(P);
            }

            DenyEntry( P, 1 );

            return false;
        }

        if (VehicleBase.Driver == none && !P.IsHumanControlled())
        {
            return VehicleBase.TryToDrive(P);
        }
    }

    return super(Vehicle).TryToDrive(P);
}

// Matt: modified to add clientside checks before sending the function call to the server
// Optimises network performance generally & specifically avoids a rider camera bug when unsuccessfully trying to switch to another vehicle position
simulated function SwitchWeapon(byte F)
{
    local  ROVehicleWeaponPawn  WeaponPawn;
    local  bool                 bMustBeTankerToSwitch;

    if (F == 1)
    {
        if (VehicleBase != none)
        {
            // Matt: don't allow switch to driver if there's a human player there
            if (VehicleBase.Driver != none && VehicleBase.Driver.IsHumanControlled())
            {
                return;
            }

            if (VehicleBase.bMustBeTankCommander)
            {
                bMustBeTankerToSwitch = true;
            }
        }
    }
    else
    {
        if (VehicleBase != none && F > 1 && (F - 2) < VehicleBase.WeaponPawns.Length)
        {
            WeaponPawn = ROVehicleWeaponPawn(VehicleBase.WeaponPawns[F - 2]);
        }

        // Matt: don't allow switch to non-existent or current weapon position or if there's a human player already there
        if (WeaponPawn == none || WeaponPawn == self || (WeaponPawn.Driver != none && WeaponPawn.Driver.IsHumanControlled()))
        {
            return;
        }

        if (WeaponPawn.bMustBeTankCrew)
        {
            bMustBeTankerToSwitch = true;
        }
    }

    // Matt: don't allow switch if the position is a tank crew role & we aren't tank crew
    if (bMustBeTankerToSwitch && (Controller == none || ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) == none ||
        ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
    {
        ReceiveLocalizedMessage(class'DH_VehicleMessage', 0);
        return;
    }

    ServerChangeDriverPosition(F);
}

defaultproperties
{
    WeaponFov=80.000000
    bSinglePositionExposed=true
    bAllowViewChange=false
    bDesiredBehindView=false
    DriverDamageMult=1.000000
    bKeepDriverAuxCollision=true
    bDebugExitPositions=true
}
