//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_StuH42Destroyer extends DH_Stug3GDestroyer;

defaultproperties
{
    VehicleNameString="StuH42 Ausf.G"
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42CannonPawn')
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42MountedMGPawn')
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_body_ext'
    Skins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.stug3g_armor_camo1'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.StuH.Stuh_dest'
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.stuh42_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.stuh42_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.stuh42_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.stuh42'

    // Damage
	// cons: petrol fuel; 105mm ammo is more likely to explode
	// 4 men crew
	AmmoIgnitionProbability=0.88  // 0.75 default
    Health=525
    HealthMax=525.0
	EngineHealth=300

    VehHitpoints(0)=(PointRadius=25.0,PointHeight=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-60.0,Y=-30.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(1)=(PointRadius=25.0,PointHeight=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=5.0,Y=30.0,Z=30.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
                    //these are 105mm shells, point radius enlarged to fit the size of the shell
}
