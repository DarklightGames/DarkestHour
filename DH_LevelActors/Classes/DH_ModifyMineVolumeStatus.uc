//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_ModifyMineVolumeStatus extends DH_ModifyActors;

var()   name                    MineVolumeToModify;
var     ROMineVolume            MineVolumeReference;
var()   bool                    UseRandomness;
var()   int                     RandomPercent; // 100 for always succeed, 0 for always fail
var()   EStatusModifyType       HowToModify;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (MineVolumeToModify == '')
    {
        return; // end script because volumename was not set
    }

    // Volume are static so use the all actor list
    foreach AllActors(class'ROMineVolume', MineVolumeReference, MineVolumeToModify)
    {
        break;
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int RandomNum;

    //Level.Game.Broadcast(self, "ChangeMineVolumeStatus was triggered");
    if (UseRandomness)
    {
        RandomNum = Rand(100); // Gets a random # between 0 & 99

        if (RandomPercent < RandomNum)
        {
            return; // leave script as it randomly failed
        }
    }

    switch (HowToModify)
    {
        case SMT_Activate:
            //Level.Game.Broadcast(self, "Activated Minefield");
            MineVolumeReference.Activate();
        break;
        case SMT_Deactivate:
            //Level.Game.Broadcast(self, "Deactivated Minefield");
            MineVolumeReference.Deactivate();
        break;
        case SMT_Toggle:
            if (MineVolumeReference.bActive)
            {
                MineVolumeReference.Deactivate();
            }
            else
            {
                MineVolumeReference.Activate();
            }
        break;
        default:
        break;
    }

    //Level.Game.Broadcast(self, "Minefield bActive variable is" @ MineVolumeReference.bActive);
}

