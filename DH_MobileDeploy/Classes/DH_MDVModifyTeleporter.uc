//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_MDVModifyTeleporter extends Actor
    hidecategories(Object,Movement,Lighting,LightColor,Karma,Force,Display,Advanced,Sound)
    placeable;

var()   name                    MDVTeleName;
var     DH_MobileTeleporter     MDVTeleRef;
var()   bool                    bTurnOffMDVTele;
var()   enum    MDVTeleModify
{
    MDVT_Increment,
    MDVT_Decrement,
    MDVT_Set
}                               HowToModify; // How to modify MDV teleporter
var()   int                     PriorityToSet;

function PostBeginPlay()
{
    local DH_MobileTeleporter MDVTele;

    super.PostBeginPlay();

    //"DH_MobileTeleporter"s are dynamic so use dynamic actor list
    foreach DynamicActors(class'DH_MobileTeleporter', MDVTele, MDVTeleName)
        MDVTeleRef = MDVTele;
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    //Modify MDVTeleRef based on HowToModify
    switch (HowToModify)
    {
        case MDVT_Increment:
            MDVTeleRef.IncrementPriorityUp();
        break;
        case MDVT_Decrement:
            MDVTeleRef.IncrementPriorityDown();
        break;
        case MDVT_Set:
            MDVTeleRef.ChangePriority(PriorityToSet);
        break;
    }
}

defaultproperties
{
    bHidden=true
}
