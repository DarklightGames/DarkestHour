//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flak38Factory extends DH_ATCannonFactoryBase;

#exec OBJ LOAD FILE=..\Animations\DH_Flak38_anm.ukx

defaultproperties
{
    VehicleClass=class'DH_Guns.DH_Flak38Gun'
    Mesh=SkeletalMesh'DH_Flak38_anm.Flak38_base_wheels'
}
