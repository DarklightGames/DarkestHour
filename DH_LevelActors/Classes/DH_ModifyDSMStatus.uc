//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ModifyDSMStatus extends DH_ModifyActors;

var() enum DSMModifyType
{
    DSM_Destroy,
    DSM_Repair,
    DSM_Toggle //Will toggle the status
}                                   HowToModify; //Custom enum for what to do with the DSM
var()   name                        DSMToModify;
var DH_DestroyableSM                DSMReference;
var()   bool                        UseRandomness;
var()   int                         RandomPercent; // 100 for always succeed, 0 for always fail
var()   bool                        bRepairIfNotFullHealth;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (DSMToModify == '')
        return; //end script because DSMToModify was not set

    //DSM are dynamic so use dynamic actor list
    foreach DynamicActors(class'DH_DestroyableSM', DSMReference, DSMToModify)
    {
        break;
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum;

    if (UseRandomness)
    {
        RandomNum = Rand(101);  //Gets a random # between 0 & 100
        if (RandomPercent <= RandomNum)
            return; //Leave script as it randomly failed
    }
    switch (HowToModify)
    {
        case DSM_Destroy: //Destroys the reference DSM if it's not already
            if (!DSMReference.bDamaged)
                DSMReference.DestroyDSM();
        break;
        case DSM_Repair: //Repairs the reference DSM if needed
            if (DSMReference.bDamaged || bRepairIfNotFullHealth)
                DSMReference.Reset();
        break;
        case DSM_Toggle: //Check DSM status and toggle it
            if (DSMReference.bDamaged)
                DSMReference.Reset();
            else
                DSMReference.DestroyDSM();
        break;
        default:
        break;
    }
}

defaultproperties
{
}
