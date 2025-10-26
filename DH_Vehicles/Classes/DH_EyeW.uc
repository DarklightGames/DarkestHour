//-----------------------------------------------------------
// Props to Moz
//-----------------------------------------------------------
class DH_EyeW extends DH_EyeE;


defaultproperties
{

     DriverWeapons(0)=(WeaponClass=Class'DH_Vehicles.DH_EyeWGun',WeaponBone="Turret_placement3")

     //AmbientGlow=224
     //bUseDynamicLights=true
     //bUseLightingFromBase=true
     //LightType=LT_SubtlePulse
    // LightEffect=LE_TorchWaver
     //LightRadius=555
     //LightBrightness=200
     //LightPeriod=2
     //bLightingVisibility=True 
     
     VehiclePositionString="in Wicked Eye"
     VehicleNameString="Wicked Eye"
     Mesh=SkeletalMesh'DH_UFO_anm.EyeBody'
     Skins(0)=Texture'DH_UFO_tex.UFO.EyeC'
     //Skins(1)=Texture'allies_vehicles_tex.int_vehicles.BA64_int'
     ExplosionSounds(0)=sound'DH_UFO_snd.UFO.UfoDeath'
     ExplosionSounds(1)=sound'DH_UFO_snd.UFO.UfoDeath'


}
