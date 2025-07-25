//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_T3485Tank_Berlin extends DH_T3485Tank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesSOV_tex.T3485_ext_Berlin'
    CannonSkins(0)=Texture'DH_VehiclesSOV_tex.T3485_ext_Berlin'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.T3485_ext_Berlin_dest'
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_T3485CannonPawn_Berlin')
}
