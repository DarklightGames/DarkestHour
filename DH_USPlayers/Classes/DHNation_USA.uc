//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHNation_USA extends DHNation;

defaultproperties
{
    NationName="United States of America"
    VoicePackClass=class'DH_USPlayers.DHUSVoice'
    SupplyCacheStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.USA_Supply_cache_full'
    PlatoonHQFlagTexture=Texture'DH_Construction_tex.Base.USA_flag_01'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.Backpacks.USA_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.Backpacks.USA_backpack'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box'
    PlatoonHQConstructedStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent'
    PlatoonHQBrokenStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_destroyed'
    PlatoonHQUnpackedStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_unpacked'
    PlatoonHQTatteredStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_light_destro'
    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_usa'
    GrenadeCrateClass=class'DH_Weapons.DH_M1GrenadeSpawner'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=96,Y1=0,X2=127,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Able"
    DefaultSquadNames(1)="Baker"
    DefaultSquadNames(2)="Charlie"
    DefaultSquadNames(3)="Dog"
    DefaultSquadNames(4)="Easy"
    DefaultSquadNames(5)="Fox"
    DefaultSquadNames(6)="George"
    DefaultSquadNames(7)="How"
    HealthFigureClass=class'DH_USPlayers.DHHealthFigure_USA'
    RoundStartSound= Sound'DH_SundrySounds.RoundBeginSounds.US_Start'
}
