//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyDSMStatus extends DH_ModifyActors;

enum DSMModifyType
{
    DSM_Destroy,
    DSM_Repair,
    DSM_ToggleDestroyed,
    DSM_Activate,
    DSM_Deactivate,
    DSM_ToggleActiveStatus
};

var()   DSMModifyType       HowToModify;            // the way in which we will modify the specified destroyable static mesh (DSM) when this actor gets triggered
var()   name                DSMToModify;            // the Tag of the DSM that we are set up to modify
var()   bool                UseRandomness;          // option for random chance of modifying the DSM each time this modify actor is triggered
var()   int                 RandomPercent;          // percentage chance of modifying the DSM if the UseRandomness option is enabled
var()   bool                bRepairIfNotFullHealth; // extra option to restore DSM to full health if it's been damaged but not destroyed (used with DSM_Repair option)
var     DHDestroyableSM     DSMReference;           // our actor reference to the DSM we are to modify, found from matching our specified DSMToModify with the DSM's Tag

// Implemented to find our paired DSM by matching our specified DSMToModify to its Tag name
function PostBeginPlay()
{
    super.PostBeginPlay();

    if (DSMToModify != '')
    {
        foreach DynamicActors(class'DHDestroyableSM', DSMReference, DSMToModify)
        {
            break;
        }
    }

    if (DSMReference == none)
    {
        Log("MAP WARNING:" @ Name @ "with no matching DHDestroyableSM actor (specified Tag = '" $ DSMToModify $ "')");
        Destroy();
    }
}

// Implemented to modify our paired DSM when this modify actor gets triggered by an event
event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum;

    // Option for only random chance of modifying the DSM
    if (UseRandomness)
    {
        RandomNum = Rand(100);

        if (RandomPercent < RandomNum)
        {
            return;
        }
    }

    // Modify the DSM in the way specified by the leveller
    switch (HowToModify)
    {
        case DSM_Destroy: // destroys the DSM if it's not already destroyed
            if (!DSMReference.bDamaged)
            {
                DSMReference.DestroyDSM(EventInstigator);
            }

            break;

        case DSM_Repair: // repairs the DSM if it's been destroyed or if leveller specified the bRepairIfNotFullHealth option
            if (DSMReference.bDamaged || bRepairIfNotFullHealth)
            {
                DSMReference.Reset();
            }

            break;

        case DSM_ToggleDestroyed: // toggle the DSM status between working/destroyed state
            if (DSMReference.bDamaged)
            {
                DSMReference.Reset();
            }
            else
            {
                DSMReference.DestroyDSM(EventInstigator);
            }

            break;

        case DSM_Activate: // activate the DSM (allowing it to be damaged/destroyed)
            DSMReference.SetActiveStatus(true);
            break;

        case DSM_Deactivate: // deactivate the DSM (meaning it cannot be damaged/destroyed)
            DSMReference.SetActiveStatus(false);
            break;

        case DSM_ToggleActiveStatus: // toggle the DSM between active/deactive status
            DSMReference.SetActiveStatus(!DSMReference.bActive);
            break;

        default:
            break;
    }
}
