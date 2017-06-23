//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHShovelAttachment_German extends DHShovelAttachment;

defaultproperties
{
    // TODO: import 3rd person German shovel mesh into the DH_Weapons3rd_anm package, then change the Skins line below to the German texture
    // The current 'German' 3rd person shovel is just a placeholder for now, using the US shovel mesh
    Mesh=SkeletalMesh'DH_Weapons3rd_anm.Shovel_German_3rd'
    Skins(0)=shader'DH_USA_shovel.Textures.USA_shovel_shine' // 'DH_GER_Shovel.Textures.Ger_shovel_shine'
}
