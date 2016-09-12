//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40Pickup extends DHWeaponPickup
   notplaceable;

#exec OBJ LOAD FILE=..\StaticMeshes\WeaponPickupSM.usx
#exec OBJ LOAD File=..\Textures\Weapons3rd_tex.utx
#exec OBJ LOAD File=..\Textures\Weapons1st_tex.utx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.svt40');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.svt40pouch');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.Soviet.svt40_world');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.Soviet.svt40_bayonet_world');
    L.AddPrecacheMaterial(material'Weapons1st_tex.Rifles.SVT40_S');
    L.AddPrecacheMaterial(material'Weapons1st_tex.bayonet.SVTBayonet_S');
    L.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.svt40_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_SVT40Weapon'
    PickupMessage="You got the SVT40."
    TouchMessage="Pick Up: SVT40"
    PickupForce="AssaultRiflePickup"
    MaxDesireability=0.78
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.svt40'
    DrawType=DT_StaticMesh
    DrawScale=1.0
    CollisionRadius=25.0
    CollisionHeight=3.0
    PrePivot=(X=0.0,Y=0.0,Z=3.0)
}
