//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyTeleportURL extends DH_ModifyActors;

var()   bool                bAutoStart;
var()   name                TeleporterToModify;
var     teleporter          TeleReference;
var()   array<string>       NewURLs; //List of possible URLs to modify to
var()   bool                bCallCorrelatedEvents; //If true will call the event that matches the randomly chosen index (with delay)
//var() bool                bEventsByTrigger; //If true will call the correlated events when triggered
var()   array<name>         CorrelatedEvents;
var()   bool                UseRandomness;
var()   int                 RandomPercent; // 100 for always succeed, 0 for always fail
var     int                 PreviousEventIndex; // for use in problems dealing with matching events/spawns

function PostBeginPlay()
{
    super.PostBeginPlay();

    //Teleporter is bStatic so use AllActors list
    foreach AllActors(class'Teleporter', TeleReference, TeleporterToModify)
    {
        break;
    }

    if (bAutoStart)
        Trigger(self, none);
}

function Reset()
{
    if (bAutoStart)
        Trigger(self, none);

    SetTimer(3, false);
}

function Timer()
{
    if (bCallCorrelatedEvents && CorrelatedEvents[PreviousEventIndex] != '')
        TriggerEvent(CorrelatedEvents[PreviousEventIndex], self, none); //Triggers the correlated event
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum;

    if (UseRandomness)
    {
        RandomNum = Rand(100);  //Gets a random # between 0 & 99
        if (RandomPercent < RandomNum)
            return; //Leave script randomly failed
    }
    if (TeleReference != none)
    {
        RandomNum = Rand(NewURLs.Length);
        if (NewURLs[RandomNum] != "")
            TeleReference.URL = NewURLs[RandomNum];

        if (bCallCorrelatedEvents && CorrelatedEvents[RandomNum] != '')
        {
            TriggerEvent(CorrelatedEvents[RandomNum], self, none); //Triggers the correlated event
        }

        PreviousEventIndex = RandomNum;
    }
}


