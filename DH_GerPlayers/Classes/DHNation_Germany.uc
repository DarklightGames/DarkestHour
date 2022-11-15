//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHNation_Germany extends DHNation;

defaultproperties
{
    NationName="Germany"
    NativeNationName="Deutschland"
    VoicePackClass=class'DH_GerPlayers.DHGerVoice'
    SupplyCacheStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.GER_Supply_cache_full'
    PlatoonHQFlagTexture=Texture'DH_Construction_tex.Base.GER_flag_01'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.Backpacks.GER_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.Backpacks.GER_backpack'
    SmokeGrenadeClass=class'DH_Equipment.DH_NebelGranate39Weapon'
    ColoredSmokeGrenadeClass=class'DH_Equipment.DH_OrangeSmokeWeapon'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_Ger_ammo_box'
    PlatoonHQConstructedStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent'
    PlatoonHQBrokenStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_destroyed'
    PlatoonHQUnpackedStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_unpacked'
    PlatoonHQTatteredStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_light_destro'
    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_germany'
    GrenadeCrateClass=class'DH_Weapons.DH_StielGranateSpawner'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=32,X2=31,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
}
