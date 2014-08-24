// class: DH_MineVolume
// Auther: Theel
// Date: 10-05-10
// Purpose:
// A new mine field volume that replicates correctly and works with modify actors
// Problems/Limitations:
// Can only modify 1 volume

class DH_MineVolume extends ROMineVolume;

var()   bool            bInitiallyActive;   //Will start active if true

function PostBeginPlay()
{
    Super.PostBeginPlay();

    bActive = bInitiallyActive;
}

//Override to prevent ROTeamGame from changing bActive
function Activate()
{
    if (bUsesSpawnAreas)
        bActive = true;
}

//Override to prevent ROTeamGame from changing bActive
function Deactivate()
{
    if (bUsesSpawnAreas)
        bActive = false;
}

function Reset()
{
    bActive = bInitiallyActive;
}

defaultproperties
{
     bInitiallyActive=true
}
