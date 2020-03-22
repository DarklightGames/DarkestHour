//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovMark extends BlastMark;

defaultproperties
{
    ProjTexture=Texture'DH_Weapon_tex_molotov.molotov_mark'
    MaterialBlendingOp=PB_Add
    FrameBufferBlendingOp=PB_AlphaBlend
    DrawScale=0.5
    bGameRelevant=true
    PushBack=24
    LifeSpan=30
    FOV=1
    MaxTraceDistance=60
    bProjectBSP=true
    bProjectTerrain=true
    bProjectStaticMesh=true
}
