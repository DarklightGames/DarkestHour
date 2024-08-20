//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2024
//==============================================================================

class DH_Battlegroup_US506th101 extends DH_Battlegroup_US
    placeable;

defaultproperties
{
    Name="506th 101 Airborne"
    Squads(0)=(Name="Rifle Squad",SquadType=class'DHSquadTypeInfantry',SquadLimit=4,Role1Leader=(Role=class'DH_USSergeant506101st',Limit=1),Role2Asl=(Role=class'DH_USSergeant506101st',Limit=1),Role3=(Role=class'DH_USSergeant506101st',Limit=-1))
}
