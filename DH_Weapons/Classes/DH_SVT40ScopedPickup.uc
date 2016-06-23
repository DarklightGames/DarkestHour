//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40ScopedPickup extends DHWeaponPickup
   notplaceable;

#exec OBJ LOAD FILE=..\StaticMeshes\WeaponPickupSM.usx
#exec OBJ LOAD File=..\Textures\Weapons3rd_tex.utx
#exec OBJ LOAD File=Weapons1st_tex.utx

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.svt40Scope');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.svt40pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.svt40_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.svt40_sniper_s');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SniperScopes.svt_scope_s');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.svt40_ammo');
    L.AddPrecacheMaterial(Material'Weapon_overlays.Scopes.Rus_sniperscope_overlay');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_SVT40ScopedWeapon'

    PickupMessage="You got the SVT40 Scoped."
    TouchMessage="Pick Up: SVT40 Scoped"
    PickupForce="AssaultRiflePickup"  // jdf

    MaxDesireability=+0.78

    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.svt40Scope'
    DrawType=DT_StaticMesh
    DrawScale=1.0

    CollisionRadius=25.0
    CollisionHeight=3.0
    PrePivot=(X=0.0,Y=0.0,Z=3.0)
}
