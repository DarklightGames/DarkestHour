//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ArtilleryActor extends DH_LevelActors;

var()   int                         XWidth, YWidth, PercentToSucceed, CallIntervalMin, CallIntervalMax;
var()   bool                        bAutoStart;
var()   array<name>                 AttachedArtilleryTags;
var()   int                         MaxRounds;      // 0 = infinite
var     int                         NumRoundsFired; // default to 0
var     array<DH_ArtilleryActor>    ArtyReferences; // references of attached

function PostBeginPlay()
{
    local DH_ArtilleryActor RAA;
    local int               i;

    super.PostBeginPlay();

    for (i = 0; i < AttachedArtilleryTags.Length; ++i)
    {
        foreach AllActors(class'DH_ArtilleryActor', RAA, AttachedArtilleryTags[i])
        {
            ArtyReferences.Insert(0, 1); // adds a new spot at index for the attached arty
            ArtyReferences[0] = RAA;     // sets the attached arty in the reference array
            break;
        }
    }
}

function Reset()
{
    super.Reset();

    NumRoundsFired = 0;
    GotoState('Initialize'); // needed for reseting the state
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    if (IsInState('Activated'))
    {
        GotoState('Deactivated');
    }
    else
    {
        GotoState('Activated');
    }
}

auto state Initialize
{
    function BeginState()
    {
        if (bAutoStart)
        {
            GotoState('Activated');
        }
        else
        {
            GotoState('Deactivated');
        }
    }
}

state Activated
{
    function BeginState()
    {
        local int RanIntervalTime;

        RanIntervalTime = RandRange(CallIntervalMin, CallIntervalMax);
        SetTimer(RanIntervalTime, false);
    }

    function Timer()
    {
        local int    RandomNum;
        local vector FallOffset;

        RandomNum = Rand(100); // gets a random # between 0 & 99

        if (RandomNum < PercentToSucceed)
        {
            if (NumRoundsFired >= MaxRounds && MaxRounds != 0)
            {
                GotoState('Deactivated');
            }

            NumRoundsFired++;

            if (ArtyReferences.Length > 0)
            {
                // Select the location to send the round
                RandomNum = Rand(ArtyReferences.Length);

                // Randomize the location offset
                FallOffset = vect(0.0, 0.0, 0.0);
                FallOffset.X += Rand(ArtyReferences[RandomNum].XWidth);

                if (Frand() > 0.5)
                {
                    FallOffset.X *= -1.0;
                }

                FallOffset.Y += Rand(ArtyReferences[RandomNum].YWidth);

                if (Frand() > 0.5)
                {
                    FallOffset.Y *= -1.0;
                }

                Spawn(class'DHArtilleryShell',,, ArtyReferences[RandomNum].Location + FallOffset, rotator(PhysicsVolume.Gravity));
            }
            else
            {
                // Randomize the location offset
                FallOffset = vect(0.0, 0.0, 0.0);
                FallOffset.X += Rand(XWidth);

                if (Frand() > 0.5)
                {
                    FallOffset.X *= -1.0;
                }

                FallOffset.Y += Rand(YWidth);

                if (Frand() > 0.5)
                {
                    FallOffset.Y *= -1.0;
                }

                // Spawn the artillery round with the random offset
                Spawn(class'DHArtilleryShell',,, Location + FallOffset, rotator(PhysicsVolume.Gravity));
            }
        }

        RandomNum = RandRange(CallIntervalMin, CallIntervalMax);
        SetTimer(RandomNum, false); // Recall the timer with a new random Call interval
        //Level.Game.Broadcast(self, "Randomvector: X:" $ Randvector.X @ "Y:" $ Randvector.Y @ "Z:" $ Randvector.Z);
    }
}

state Deactivated
{
    //do nothing
}

defaultproperties
{
    XWidth=512
    YWidth=512
    PercentToSucceed=80
    CallIntervalMin=10
    CallIntervalMax=20
    bAutoStart=true
    MaxRounds=50
}
