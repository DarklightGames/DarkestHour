// class: DH_AdvLevelTeleporter
// Auther: Theel
// Date: 11-03-10
// Purpose:
// Optimizes the teleporter and also adds new features including pawn capturing and alt URLs
// Problems/Limitations:
// Needs testing (lacks ability to change URL)
//

//***************
// Delete as this class really isn't needed
// though I feel it is much more optimized, it's use would be too rare to justify it's inclusion in the next update
//***************


class DH_AdvLevelTeleporter extends DH_Teleporter;


/*
//Implemented to allow for proper reset action
var()   bool                bInitTeleStatus; //Overrides bEnabled value

//Implemented to allow for certain pawn types to teleport at another location
var()   string              AlternateURL; //If set will act as a seperate URL for Alternate pawn class
var()   array<class<Pawn> > AlternatePawnClasses; //Array of pawn classes that should be sent to AlternateURL

//Implemented for optimization
var     array<Teleporter>   URLRef;
var     array<Teleporter>   AltURLRef;

//Implemented to add catch and check
var     bool                    bCaught;
var()   bool                    bCatchAlternate; //Will send the pawn reference to WatchPawn actor
var()   name                    WatchPawnActorName; //The WatchPawn actor to send the alternate pawn reference to
var     DH_CatchAndWatchPawn    WatchPawnRef;

//Override to optimize and redo teleportation system
function PostBeginPlay()
{
    local int i;
    local Teleporter Tele;
    local DH_CatchAndWatchPawn wPawn;

    bEnabled = bInitTeleStatus;

    if (URL ~= "")
        SetCollision(false, false, false); //destination only

    if (!bEnabled)
        FindTriggerActor();

    //for keeping bots in vehicles from trying to use teleporters
    for (i=0; i<PathList.Length; i++){
        if (Teleporter(PathList[i].End) != none){
            PathList[i].bForced = true;
            PathList[i].reachFlags = PathList[i].reachFlags | 256;
        }
    }
    super.PostBeginPlay();

    //Setup references properly
    //Teleporter is bStatic so use AllActors list
    foreach AllActors(class'Teleporter', Tele)
    {
        if (string(Tele.tag)~=URL)
        {
            URLRef.Insert(0,1); //Adds a new spot at index for the attached tele
            URLRef[0] = Tele; //Sets the tele reference in the reference array
        }
    }

    foreach AllActors(class'Teleporter', Tele)
    {
        if (string(Tele.tag)~=AlternateURL)
        {
            AltURLRef.Insert(0,1); //Adds a new spot at index for the attached tele
            AltURLRef[0] = Tele; //Sets the tele reference in the reference array
        }
    }

    foreach AllActors(class'DH_CatchAndWatchPawn', wPawn, WatchPawnActorName)
    {
        WatchPawnRef = wPawn;
    }
}

function Reset()
{
    bCaught = false;
    bEnabled = bInitTeleStatus; //Act as consistent teleporter
}

// Teleporter was touched by an actor.
// Overridden for extra functionatlity and optimazation
simulated function PostTouch(actor Other)
{
    local int i, RandomNum;

    if (Pawn(Other)== none)
        return; //Leave function as Other isn't a pawn

    if ((InStr(URL, "/") >= 0) || (InStr(URL, "#") >= 0))
    {   // Teleport to a level on the net.
        if ((Role == ROLE_Authority) && (Pawn(Other) != none) && Pawn(Other).IsHumanControlled())
            Level.Game.SendPlayer(PlayerController(Pawn(Other).Controller), URL);
    }
    else
    {

        //if AltURLRef has length then we need to check pawn class
        if (AltURLRef.Length > 0 || (bCatchAlternate && !bCaught))
        {
            for(i=0;i<AlternatePawnClasses.Length;i++)
            {
                if (Other.IsA(AlternatePawnClasses[i].Name)) //Then the actor is of type in AlternatePawnClasses
                {
                    if (bCatchAlternate && !bCaught) //We caught the actor and need to send refernce to catch
                    {
                        WatchPawnRef.PassPawnRef(pawn(Other));
                        bCaught = true;
                    }

                    if (AltURLRef.Length > 0)
                    {
                        //We need to send them to the correct place
                        RandomNum = rand(AltURLRef.Length);
                        AltURLRef[RandomNum].Accept(Other,self);
                        Other.PlayTeleportEffect(false, true);
                        TriggerEvent(Event, self, Pawn(Other));
                        return; //return as the actor was teleportered
                    }
                }
            }
        }
        //if we get to this point we know that Other isn't a AltPawnClass
        RandomNum = rand(URLRef.Length); //Get a random num in the ref array
        URLRef[RandomNum].Accept(Other,self); //Send Other to the random teleporter in the array
        Other.PlayTeleportEffect(false, true); //Play teleport effect (not sure what it does)
        TriggerEvent(event, self, Pawn(Other)); //Trigger event of teleporter
    }
}

defaultproperties
{
    bInitTeleStatus=true
}
*/

defaultproperties
{
}
