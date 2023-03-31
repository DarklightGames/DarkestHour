//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyMineVolumeStatus extends DH_ModifyActors;

var()   name                    MineVolumeToModify; // the tag that the minefield uses
var     array<ROMineVolume>     MineVolumes;
var()   bool                    UseRandomness;
var()   int                     RandomPercent; // 100 for always succeed, 0 for always fail
var()   StatusModifyType        HowToModify;

function PostBeginPlay()
{
    local ROMineVolume MineVolume;

    super.PostBeginPlay();

    if (MineVolumeToModify == '')
    {
        return; // end script because volumename was not set
    }

    // Volume are static so use the all actor list
    foreach AllActors(class'ROMineVolume', MineVolume, MineVolumeToModify)
    {
        MineVolumes[MineVolumes.Length] = MineVolume;
    }
}

event Trigger(Actor Other, Pawn EventInstigator)
{
    local int i, RandomNum;
    local ROMineVolume MineVolume;

    if (UseRandomness)
    {
        RandomNum = Rand(100); // Gets a random # between 0 & 99

        if (RandomPercent < RandomNum)
        {
            return; // leave script as it randomly failed
        }
    }

    for (i = 0; i < MineVolumes.Length; ++i)
    {
        switch (HowToModify)
        {
            case SMT_Activate:
                MineVolumes[i].Activate();
            break;
            case SMT_Deactivate:
                MineVolumes[i].Deactivate();
            break;
            case SMT_Toggle:
                if (MineVolumes[i].bActive)
                {
                    MineVolumes[i].Deactivate();
                }
                else
                {
                    MineVolumes[i].Activate();
                }
            break;
            default:
            break;
        }
    }
}
