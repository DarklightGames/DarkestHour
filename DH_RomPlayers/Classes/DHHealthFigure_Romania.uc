//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHHealthFigure_Romania extends DHHealthFigure  
    abstract;

defaultproperties
{
    HealthFigure=Material'DH_InterfaceArt_CC_tex.HUD.rom_player'
	HealthFigureBackground=Material'DH_InterfaceArt_CC_tex.HUD.rom_player_background'
	HealthFigureStamina=Material'DH_InterfaceArt_CC_tex.HUD.rom_player_Stamina'
	HealthFigureStaminaCritical=FinalBlend'DH_InterfaceArt_CC_tex.HUD.rom_player_Stamina_critical'
	LocationHitImages(0)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_head'
	LocationHitImages(1)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_torso'
	LocationHitImages(2)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Pelvis'
	LocationHitImages(3)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Lupperleg'
	LocationHitImages(4)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Rupperleg'
	LocationHitImages(5)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Lupperarm'
	LocationHitImages(6)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Rupperarm'
	//LocationHitImages(7)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Llowerleg' //its missing, fix it
	LocationHitImages(8)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Rlowerleg'
	LocationHitImages(9)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Llowerarm'
	LocationHitImages(10)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Rlowerarm'
	LocationHitImages(11)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Lhand'
	LocationHitImages(12)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Rhand'
	LocationHitImages(13)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Lfoot'
	LocationHitImages(14)=Texture'DH_InterfaceArt_CC_tex.Player_hits.rom_hit_Rfoot'
}
