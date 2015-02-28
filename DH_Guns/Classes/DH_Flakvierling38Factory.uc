//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flakvierling38Factory extends DH_ATCannonFactoryBase;

#exec OBJ LOAD FILE=..\Animations\DH_Flakvierling38_anm.ukx

defaultproperties
{
    VehicleClass=class'DH_Guns.DH_Flakvierling38Gun'
    Mesh=SkeletalMesh'DH_Flakvierling38_anm.flak_base'
}
