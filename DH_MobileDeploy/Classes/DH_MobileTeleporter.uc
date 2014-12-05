//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MobileTeleporter extends Teleporter;

//Load texture file for MDV skins
#exec OBJ LOAD FILE="..\Textures\DH_MDV_Tex.utx"

//class Variables
var     Vehicle                     CurrentMDVReference; //Used to check if LastSpawnedVehicle changed from timer to timer call
var()   array<name>                 MDVFactoryPriority; //0 for lowest priority, tag names of the factories
var     array<ROVehicleFactory>     MDVFactoryReferences; //The MDV factory references (often accessing LastSpawnedVehicle)
var     int                         QueuedPriority; //if priority is changed but the previous priority MDV is still alive and not empty
                                                    //que up the change so when it finally resets we know which priority to change to
var     int                         CurrentPriority; //Current MDV factory reference (can go either way, but must start @ zero
var()   int                         InitialPriority; //Leveler modification of priority
var     bool                        bCheckForQueue;
var()   float                       EnemyRadius; //Give ability for leveler to set the radius, though it may confuse players if changed
var()   bool                        bUseURLAsBackup; //The ability for a leveler to have the MDV teleporter use the URL when deploy to the MDV fails
var     int                         ReasonCantDeploy; //A saved reason for can't deploy
var     texture                     NoDeployTexture; //The texture reference for deny deploy to the MDV
var     texture                     DeployTexture; //The texture reference for allow deploy to the MDV
var     texture                     NoTexture; //The texture reference when no texture is to be displayed

//Begin Functions
function PostBeginPlay()
{
    local int   i;
    local ROVehicleFactory ROFactory;
    super.PostBeginPlay();

    //Get the vehicle factorys and set the reference to it
    //Can search Dynamic Actors beccause ROVehicleFactory is Dynamic
    for(i=0; i<MDVFactoryPriority.Length; i++)
    {
        foreach DynamicActors(class'ROVehicleFactory', ROFactory, MDVFactoryPriority[i])
        {
            MDVFactoryReferences.Insert(0,1); //Adds a new spot at index for the attached factory
            MDVFactoryReferences[0] = ROFactory; //Sets the attached factory in the reference array
        }
    }

    //Reset current priority
    CurrentPriority = InitialPriority;

    //Setup textures
    NoDeployTexture = Texture'DH_MDV_Tex.MobileTele_Deny'; //Setup the deny texture reference
    DeployTexture = Texture'DH_MDV_Tex.MobileTele_Allow'; //Setup the allow texture reference

    //Start the class timer that checks to see what state we need to be in!
    SetTimer(1, true);
}

function Reset()
{
    //Stops the timer
    SetTimer(0.0, false);

    //Reset needed variables
    CurrentPriority = InitialPriority;
    bCheckForQueue = false;
    QueuedPriority = 0;
    CurrentMDVReference = none;

    //Reset to activated because it's the auto state anyway
    GotoState('Activated');

    //Start the class timer that checks to see what state we need to be in!
    SetTimer(1, true);
}

//This state is when we know teleportation to the MDV is open
auto state Activated
{
    function BeginState()
    {
        texture = DeployTexture; //Set the texture can deploy
    }
    simulated function PostTouch(actor Other)
    {
        if (Pawn(Other)== none)
            return; //Leave function as Other isn't a pawn

        //If the vehicle exists send the pawn
        if (MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle != none)
        {
            //Send Other to the vehicle that the factory last spawned
            if (!MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle.TryToDrive(Pawn(Other)))
            {
                if (bUseURLAsBackup)
                    super.PostTouch(Other); //Send the pawn to the normal URL
                //We could goto deactivated at this point, but it's a bad idea because players can crouch in this actor
                //and cause other players temporary delay before they can teleport, so we must rely on Timer
            }
        }
    }
}

state Deactivated
{
    function BeginState()
    {
        texture = NoDeployTexture; //Set the can't deploy texture
    }
    //Overridden so if it's deactivated the function doesn't do unnesessary checks
    simulated function PostTouch(actor Other)
    {
        //If vehicle exists and pawn is a SL
        if (MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle != none && DH_Pawn(Other).GetRoleInfo().bIsSquadLeader)
        {
            //Send Other to the vehicle that the factory last spawned
            if (!MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle.TryToDrive(Pawn(Other)))
            {
                if (bUseURLAsBackup)
                    super.PostTouch(Other); //Send the pawn to the normal URL
                return;
            }
        }

        Pawn(Other).ReceiveLocalizedMessage(class'DH_MobileDeployMessage', ReasonCantDeploy); //Reason why the pawn can't tele

        if (bUseURLAsBackup)
            super.PostTouch(Other); //Send the pawn to the normal URL
    }
}

state TurnOff
{
    function BeginState()
    {
        SetTimer(0.0, false); //Stops the timer (until reset is called)
        texture = NoTexture; //Set no texture
    }
    //Overridden so if it's deactivated the function doesn't do unnesessary checks
    simulated function PostTouch(actor Other)
    {

    }
}

function Timer()
{
    local int i;

    //Deactivate all active factories but current factory
    for(i=0; i<MDVFactoryReferences.Length; i++)
    {
        if (i != CurrentPriority && MDVFactoryReferences[i].bFactoryActive)
        {
            MDVFactoryReferences[i].Deactivate();
            if (MDVFactoryReferences[i].LastSpawnedVehicle != none && ROVehicle(MDVFactoryReferences[i].LastSpawnedVehicle) != none && ROVehicle(MDVFactoryReferences[i].LastSpawnedVehicle).IsVehicleEmpty())
                ROVehicle(MDVFactoryReferences[i].LastSpawnedVehicle).Destroy(); //Destroy the vehicle
        }
    }

    //Check for queue
    if (bCheckForQueue)
    {
        if (CurrentMDVReference != MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle ||
         MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle == none ||
         MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle.bVehicleDestroyed)
        {
            CurrentPriority = QueuedPriority;
            MDVFactoryReferences[CurrentPriority].Activate(MDVFactoryReferences[CurrentPriority].TeamNum); //Activates the new factory

            bCheckForQueue = false;
        }
    }

    //Check if the vehicle is dead, in capture area, or enemies near it
    if (CanDeploy())
    {
        if (IsInState('Deactivated'))
            GotoState('Activated'); //We can deploy so lets goto Activated state if we aren't already there
    }
    else
    {
        if (IsInState('Activated'))
            GotoState('Deactivated'); //We can't deploy so lets goto Deactivated state if we aren't already there
    }

    CurrentMDVReference = MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle;
}

//Overridden so if it's deactivated the function doesn't do anything
simulated function PostTouch(actor Other)
{
}

//Returns false if vehicle is destroyed, in a capture area, or if enemy in radius
function bool CanDeploy()
{
    local ROPawn P;

    //Check to make sure the vehicle even exists or if it's destroyed
    if (MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle == none || MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle.bVehicleDestroyed)
    {
        ReasonCantDeploy = 1; //Vehicle is destroyed
        return false;
    }

    //Check to make sure the vehicle isn't in a capture area (255 means it's not)
    if (ROVehicle(MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle).CurrentCapArea != 255)
    {
        ReasonCantDeploy = 2; //Vehicle is in capture area
        return false;
    }

    //Check to see if the Pawn is human and if not on the same team as the vehicle
    foreach CollidingActors(class'ROPawn', P, EnemyRadius, MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle.Location)
        if (P.GetTeamNum() != MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle.GetTeamNum() && P.IsHumanControlled())
        {
            ReasonCantDeploy = 3; //Vehicle has enemy nearby
            return false;
        }

    return true; //No enemies were present so we can deploy
}

function IncrementPriorityUp()
{
    if (!(CurrentPriority+1 > MDVFactoryReferences.Length) && !bCheckForQueue) //Check if an increment would send the value greater than length
        ChangePriority(CurrentPriority+1); //if not then increment
    else if (!(QueuedPriority+1 > MDVFactoryReferences.Length) && bCheckForQueue)
        ChangePriority(QueuedPriority+1);
}

function IncrementPriorityDown()
{
    if (!(CurrentPriority-1 < 0) && !bCheckForQueue) //Check if an increment down would send value lower than 0
        ChangePriority(CurrentPriority-1); //if not then increment down
    else if (!(QueuedPriority-1 < 0) && bCheckForQueue)
        ChangePriority(QueuedPriority-1);
}

function ChangePriority(int NewPriority)
{
    local int i;

    //Activate the new priority one if current mdv is gone or dead
    if (MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle == none || MDVFactoryReferences[CurrentPriority].LastSpawnedVehicle.bVehicleDestroyed)
    {
        //The MDV is dead, now lets deactivate all factories
        for(i=0; i<MDVFactoryReferences.Length; i++)
            MDVFactoryReferences[i].Deactivate();
            if (ROVehicle(MDVFactoryReferences[i].LastSpawnedVehicle).IsVehicleEmpty())
                ROVehicle(MDVFactoryReferences[i].LastSpawnedVehicle).Destroy(); //Destroy the vehicle

        //Change priority
        CurrentPriority = NewPriority;

        //Activate the new factory
        MDVFactoryReferences[CurrentPriority].Activate(MDVFactoryReferences[CurrentPriority].TeamNum);
    }
    else
    {
        QueuedPriority = NewPriority;
        bCheckForQueue = true;
    }
}

defaultproperties
{
    EnemyRadius=4096.000000
    bStatic=false
    bHidden=false
    bAlwaysRelevant=true
    Texture=Texture'DH_MDV_Tex.TeleMDV.MobileTele_Deny'
    DrawScale=0.330000
}
