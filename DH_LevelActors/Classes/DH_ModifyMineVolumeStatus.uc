//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ModifyMineVolumeStatus extends DH_ModifyActors;

var()   name                    MineVolumeToModify;
var     DH_MineVolume           MineVolumeReference;
var()   bool                    UseRandomness;
var()   int                     RandomPercent; // 100 for always succeed, 0 for always fail
var()   StatusModifyType        HowToModify;

function PostBeginPlay()
{
    local DH_MineVolume ROMV;

    super.PostBeginPlay();

    if (MineVolumeToModify == '')
    {
        return; // end script because volumename was not set
    }

    // Volume are static so use the all actor list
    foreach AllActors(class'DH_MineVolume', ROMV, MineVolumeToModify)
    {
        MineVolumeReference = ROMV;
        break;
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum;

    //Level.Game.Broadcast(self, "ChangeMineVolumeStatus was triggered");
    if (UseRandomness)
    {
        RandomNum = Rand(101); // gets a random # between 0 & 100

        if (RandomPercent <= RandomNum)
        {
            return; // leave script as it randomly failed
        }
    }

    switch (HowToModify)
    {
        case SMT_Activate:
            //Level.Game.Broadcast(self, "Activated Minefield");
            MineVolumeReference.bActive = true;
        break;
        case SMT_Deactivate:
            //Level.Game.Broadcast(self, "Deactivated Minefield");
            MineVolumeReference.bActive = false;
        break;
        case SMT_Toggle:
            MineVolumeReference.bActive = !MineVolumeReference.bActive;
        break;
        default:
        break;
    }

    //Level.Game.Broadcast(self, "Minefield bActive variable is" @ MineVolumeReference.bActive);
}

defaultproperties
{
}
