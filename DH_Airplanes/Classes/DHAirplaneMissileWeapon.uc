///==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHAirplaneMissileWeapon extends DHAirplaneWeapon;

var vector TargetLocation;
var bool   bHideWhenEmpty;

function Disarm();
function Resupply();

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (!HasAmmo())
    {
        InitialState = 'Empty';
    }
}

function Timer()
{
    Fire();
}

function Fire()
{
    Log("BOMBS AWAY! WOO!");
    GotoState('Empty');
    SpawnProjectile();
}

function Arm()
{
    local DHAirplane Airplane;
    local DHAirplaneTarget Target;

    if (!CanFire())
    {
        return;
    }

    Airplane = GetAirplane();

    if (Airplane == none)
    {
        return;
    }

    Target = Airplane.Target;

    if (Target != none && Target.IsValid())
    {
        TargetLocation = Target.GetLocation();
        GotoState('Armed');
    }
}

state Armed
{
    function Disarm()
    {
        GotoState('');
    }

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

state Empty
{
    ignores Fire, Arm;

    function Timer()
    {
        Resupply();
    }

    function BeginState()
    {
        if (bHideWhenEmpty)
        {
            bHidden = true;
        }

        // DEBUG: Resuppy the bombs for testing
        SetTimer(5, false);
    }

    function EndState()
    {
        if (bHideWhenEmpty)
        {
            bHidden = false;
        }
    }

    function Resupply()
    {
        super.Resupply();

        GotoState('');
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

defaultproperties
{
    DrawType=DT_StaticMesh
    bHideWhenEmpty=true

    StaticMesh=StaticMesh'DH_Airplanes_stc.Bombs.sc250'
    ProjectileClass=class'DHAirplaneBomb_SC250'

    MaxAmmo=1
    AmmoCount=1
}
