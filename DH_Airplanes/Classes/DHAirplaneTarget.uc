//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHAirplaneTarget extends Info;

enum ETargetType
{
    // TODO: make a categorization later
    TARGET_Single,
    TARGET_MixedGroup
};

var ETargetType     Type;
var array<Actor>    Actors;

enum EWeaponType
{
    WEAPON_MachineGun,
    WEAPON_AutoCannon,
    WEAPON_Rocket,
    WEAPON_Bomb
};

// Returns flags indicating the recommended weapon types for this target.
function array<EWeaponType> GetRecommendedWeaponTypes()
{
    local array<EWeaponType> WeaponTypes;

    // TODO: fill this in with something real.
    WeaponTypes[WeaponTypes.Length] = WEAPON_AutoCannon;

    return WeaponTypes;
}

// Returns whether this target is still valid (eg. all target actors may have died).
// static function DHAirplaneTarget CreateTargetFromActors(array<Actor> Actors)
// {
//     local DHAirplaneTarget Target;

//     Target = new class'DHAirplaneTarget';
//     Target.Actors = Actors;

//     return Target;
// }

// Returns true if any of the target actors are valid.
function bool IsValid()
{
    local int i;

    for (i = 0; i < Actors.Length; ++i)
    {
        if (IsTargetActorValid(Actors[i]))
        {
            return true;
        }
    }

    return false;
}

// Returns true if the actor passed in is a valid target.
function bool IsTargetActorValid(Actor A)
{
    if (A == none)
    {
        return false;
    }

    if (A.IsA('Pawn'))
    {
        if (Pawn(A).Health == 0)
        {
            // Actor is dead, no longer valid.
            return false;
        }
    }

    return true;
}

// Gets the average velocity of all actors.
function vector GetVelocity()
{
    local int i, Count;
    local vector Vel;

    for (i = 0; i < Actors.Length; ++i)
    {
        if (IsTargetActorValid(Actors[i]))
        {
            Vel += Actors[i].Velocity;
        }
    }

    if (Count > 0)
    {
        return Vel * (1.0 / Count);
    }
}

// Gets the average location of all actors.
function vector GetLocation()
{
    local int i, Count;
    local vector Loc;

    for (i = 0; i < Actors.Length; ++i)
    {
        if (IsTargetActorValid(Actors[i]))
        {
            Loc += Actors[i].Location;
            ++Count;
        }
    }

    if (Count > 0)
    {
        return Loc * (1.0 / Count);
    }
}

// Gets the predicted location of the target after a certain duration of time
// using the average velocity of the actors.
function vector GetLocationPrediction(float DurationTimeSeconds)
{
    return GetLocation() + (GetVelocity() * DurationTimeSeconds);
}

defaultproperties
{
    DrawType=DT_None
}
