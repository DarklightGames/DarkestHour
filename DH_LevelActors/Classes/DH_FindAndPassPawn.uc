//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_FindAndPassPawn extends DH_LevelActors
    showcategories(Collision,Advanced);

enum FindType
{
    FT_ClassProximity,
    FT_TagProximity,
    FT_Factory,
};

var()   FindType                HowToFind;
var()   name                    TagToFind;
var()   array<class<Pawn> >     PawnClassToFind;
var()   name                    VehicleFactoryTag;
var     ROVehicleFactory        VehicleFactoryRef;
var()   name                    CatchActorTag;
var     DH_CatchAndWatchPawn    CatchActorRef;

function PostBeginPlay()
{
    //can use dynamic actors?
    foreach AllActors(class'DH_CatchAndWatchPawn', CatchActorRef, CatchActorTag)
        break;

    foreach AllActors(class'ROVehicleFactory', VehicleFactoryRef, VehicleFactoryTag)
        break;
}

function Reset()
{
    GotoState('DelayBeforeFind');
}

auto state DelayBeforeFind
{
    function BeginState()
    {
        SetTimer(5.0, false);
    }

    function Timer()
    {
        switch (HowToFind)
        {
            case FT_ClassProximity:
                GotoState('Findclass');
            break;
            case FT_TagProximity:
                GotoState('FindTag');
            break;
            case FT_Factory:
                GotoState('FindFactory');
            break;
        }
    }
}

state FindClass
{
    event Touch(Actor Other)
    {
        local int           i;

        if (Pawn(Other) == none)
            return;

        for (i = 0; i < PawnClassToFind.Length; ++i)
        {
            if (Other.IsA(PawnClassToFind[i].Name))
            {
                //Other is of type to find and we need to pass it and goto passed
                CatchActorRef.PassPawnRef(Pawn(Other));
                GotoState('Passed');
            }
        }
    }
}

state FindTag
{
    event Touch(Actor Other)
    {
        if (Pawn(Other) == none)
            return;

        if (Pawn(Other).Tag == TagToFind)
        {
            //we have a matching tag this is the pawn we want!
            CatchActorRef.PassPawnRef(Pawn(Other));
            GotoState('Passed');
        }
    }
}

state FindFactory
{
    function BeginState()
    {
        if (VehicleFactoryRef.LastSpawnedVehicle != none && VehicleFactoryRef.LastSpawnedVehicle.Health >= 0)
        {
            CatchActorRef.PassPawnRef(VehicleFactoryRef.LastSpawnedVehicle);
            GotoState('Passed');
        }
    }
}

state Passed
{
}
