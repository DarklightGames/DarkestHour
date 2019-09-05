///==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHAirplaneHardpoint extends Actor;

var int HardpointIndex;

// Projectile
var class<DHProjectile> ProjectileClass;
var vector              ProjectileOffset;

var bool  bUseProjectileMesh; // for mounted projectiles (bombs, rockets, etc.)
var bool  bInitiallyEmpty;
var vector TargetLocation;

var RODebugTracerGreen DebugActor;

function Disarm();
function Resupply();

simulated function PostBeginPlay()
{
    if (bUseProjectileMesh)
    {
        // SetDrawType(DT_Mesh);
        // LinkMesh(ProjectileClass.default.Mesh);
    }

    if (bInitiallyEmpty)
    {
        InitialState = 'Empty';
    }
}

function Timer()
{
    Fire();
}

function SpawnProjectile()
{
    local vector ProjectileLocation;
    local rotator ProjectileRotation;

    ProjectileLocation = Location + (ProjectileOffset >> Rotation);
    ProjectileRotation = Rotation;

    Spawn(ProjectileClass, self,, ProjectileLocation, ProjectileRotation);
}

function Fire()
{
    Log("BOMBS AWAY! WOO!");
    GotoState('Empty');
    SpawnProjectile();
}

state Empty
{
    ignores Fire;

    function Timer()
    {
        Resupply();
    }

    function BeginState()
    {
        if (bUseProjectileMesh)
        {
            bHidden = true;
        }

        // DEBUG: Resuppy the bombs for testing
        SetTimer(5, false);
    }

    function EndState()
    {
        if (bUseProjectileMesh)
        {
            bHidden = false;
        }
    }

    function Resupply()
    {
        GotoState('');
    }
}

function Arm() { GotoState('Armed'); }

state Armed
{
    function Disarm() { GotoState(''); }

    simulated function Tick(float DeltaTime)
    {
        local vector HorizontalVelocity, FiringPosition;
        local float Error, HorizontalSpeed;

        if (Role == ROLE_Authority && Owner != none)
        {
            if (!GetFiringPosition(FiringPosition, Owner, TargetLocation))
            {
                Log("Can't reach target");
                GotoState('');
            }

            Error = VSize(Owner.Location - FiringPosition);

            HorizontalVelocity = Owner.Velocity;
            HorizontalVelocity.Z = 0.0;
            HorizontalSpeed = VSize(HorizontalVelocity);

            // The target is getting close, but we might overshoot it next
            // tick.
            if (HorizontalSpeed != 0.0 && Error <= HorizontalSpeed * DeltaTime)
            {
                // SetTimer(GetTimeToFiringPosition(Owner, TargetLocation), false);

                // The final error should be within 2 meters short of the
                // target. Because target pawns float above the ground, bombs
                // will tend to overshoot the target slightly, so the error
                // actually helps.
                Log("BOMB ERROR:" @ Error);
                Fire();
                return;
            }
        }
    }
}

// Returns ideal firing location at current height and velocity
// TODO: Move this to the projectile class
static function bool GetFiringPosition(out vector FiringPosition, Actor Instigator, vector TargetLocation)
{
    local float T, D, G;
    local vector InitLocation, InitVelocity, Direction;

    if (Instigator == none)
    {
        return false;
    }

    InitLocation = Instigator.Location;
    InitVelocity = Instigator.Velocity;

    Direction = Normal(TargetLocation - InitLocation);

    G = Instigator.PhysicsVolume.Gravity.Z;
    D = Square(InitVelocity.Z) - 2 * G * (InitLocation.Z - TargetLocation.Z);

    // Can't reach target
    if (D < 0 || G == 0.0)
    {
        return false;
    }

    T = -(InitVelocity.Z + Sqrt(D)) / G;

    TargetLocation.Z = 0.0;
    InitVelocity.Z = 0.0;

    FiringPosition = TargetLocation - Direction * VSize(InitVelocity * T);
    FiringPosition.Z = InitLocation.Z;

    return true;
}

// Returns the time to the firing position, given that velocity remains constant
// and pointed towards the target.
// TODO: Results are off
static function float GetTimeToFiringPosition(Actor Instigator, vector TargetLocation)
{
    local float G, Slope, Radicand, Speed;
    local vector InitVelocity, Target, RelativeFiringPosition;

    if (Instigator == none)
    {
        return 0.0;
    }

    Target = ProjectToVerticalPlane(TargetLocation - Instigator.Location);
    InitVelocity = ProjectToVerticalPlane(Instigator.Velocity);
    Speed = VSize(InitVelocity);
    G = -Instigator.PhysicsVolume.Gravity.Z;

    if (G == 0 || InitVelocity.X == 0.0 || Speed == 0.0)
    {
        return 0.0;
    }

    Slope = InitVelocity.Y / InitVelocity.X;
    Radicand = 2 * G * (Slope * Target.X - Target.Y);

    if (Radicand >= 0.0)
    {
        RelativeFiringPosition.X = Target.X - (InitVelocity.X * Sqrt(Radicand)) / G;
        RelativeFiringPosition.Y = Slope * RelativeFiringPosition.X;

        return VSize(RelativeFiringPosition) / Speed;
    }
}

// TODO: Move to UVector
static function vector ProjectToVerticalPlane(vector V)
{
    local vector Temp, Result;

    Temp = V;
    Temp.Z = 0.0;

    Result.X = VSize(Temp);
    Result.Y = V.Z;

    return Result;
}

defaultproperties
{
    // TODO: !
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Airplanes_stc.Bombs.sc250'
        
    RemoteRole=ROLE_SimulatedProxy
    ProjectileClass=class'DHAirplaneBomb_SC250'
    bUseProjectileMesh=true
}
