//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MaximM191030Gun_Winter extends DH_MaximM191030Gun;

defaultproperties
{
    Skins(0)=Texture'DH_Maxim_tex.MAXIM_BODY_EXT_WINTER'
    CannonSkins(0)=Texture'DH_Maxim_tex.MAXIM_TURRET_EXT_WINTER'
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_MaximM191030MGPawn_Winter',WeaponBone="TURRET_PLACEMENT")
    MountedWeaponClass=Class'DH_MaximM191030Weapon_Winter'
    DestroyedMeshSkins(0)=Combiner'DH_Maxim_tex.MAXIM_BODY_DESTROYED_WINTER'
    DestroyedMeshSkins(1)=Combiner'DH_Maxim_tex.MAXIM_TURRET_DESTROYED_WINTER'
}
