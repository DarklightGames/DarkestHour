//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_SnowAssaultEarly extends DH_RKKA_SnowAssault;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_PPD40Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')

    Headgear(0)=Class'DH_SovietHelmetSnow'
    Headgear(1)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
