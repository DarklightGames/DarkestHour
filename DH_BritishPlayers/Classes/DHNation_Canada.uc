//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHNation_Canada extends DHNation;

defaultproperties
{
    NationName="Canada"
    VoicePackClass=class'DH_BritishPlayers.DHCanadianVoice'
    SupplyCacheStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.USA_Supply_cache_full';
    PlatoonHQFlagTexture=Texture'DH_Construction_tex.Base.CAN_flag_01'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.Backpacks.CAN_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.Backpacks.CAN_backpack'
    SmokeGrenadeClass=class'DH_Equipment.DH_USSmokeGrenadeWeapon'
    ColoredSmokeGrenadeClass=class'DH_Equipment.DH_RedSmokeWeapon'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_Commonwealth_ammo_box'
    PlatoonHQConstructedStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent'
    PlatoonHQBrokenStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_destroyed'
    PlatoonHQUnpackedStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_unpacked'
    PlatoonHQTatteredStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_light_destro'
    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_canada'
    GrenadeCrateClass=class'DH_Weapons.DH_MillsBombSpawner'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=32,Y1=0,X2=63,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
}
