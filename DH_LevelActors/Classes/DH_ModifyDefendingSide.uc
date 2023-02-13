//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyDefendingSide extends DH_ModifyActors;

var()   ROSideIndex     NewDefendingSide;

event Trigger(Actor Other, Pawn EventInstigator)
{
    switch (NewDefendingSide)
    {
        //Change Defending Side To none
        case NEUTRAL:
                ROTeamGame(Level.Game).LevelInfo.DefendingSide = SIDE_none;
            break;
        //Change Defending Side To Axis
        case AXIS:
                ROTeamGame(Level.Game).LevelInfo.DefendingSide = SIDE_Axis;
            break;
        //Change Defending Side To Allies
        case ALLIES:
                ROTeamGame(Level.Game).LevelInfo.DefendingSide = SIDE_Allies;
            break;
        default:
            break;
    }
}
