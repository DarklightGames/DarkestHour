//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M16Halftrack_Snow extends DH_M16Halftrack;

#exec OBJ LOAD FILE=..\Animations\DH_M3Halftrack_anm.ukx

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M45QuadmountMGPawn_Snow',WeaponBone="turret_placement")
}

