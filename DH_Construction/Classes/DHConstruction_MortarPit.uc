//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_MortarPit extends DHConstruction;

var class<DHMortarVehicle>  MortarClass;
var DHMortarVehicle         Mortar;
var vector                  MortarOffset;

function PostBeginPlay()
{
    super.PostBeginPlay();

    Mortar = Spawn(MortarClass, self,, Location + MortarOffset, Rotation);
}

defaultproperties
{
    MenuName="Mortar Pit"
    StaticMesh=StaticMesh'DH_Construction_stc.mortar_pit'
    GroupClass=class'DHConstructionGroup_Defenses'
    MortarClass=class'DH_Weapons.DH_Kz8cmGrW42Vehicle'  // TODO: static function to determine this
}

