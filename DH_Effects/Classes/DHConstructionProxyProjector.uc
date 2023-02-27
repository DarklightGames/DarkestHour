//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstructionProxyProjector extends DynamicProjector
    notplaceable;

var Material GreenTexture;
var Material RedTexture;

defaultproperties
{
    GreenTexture=Material'DH_Construction_tex.ui.aura_green'
    RedTexture=Material'DH_Construction_tex.ui.aura_red'
    bNoProjectOnOwner=true
    bProjectActor=false
    bProjectOnAlpha=true
    bProjectParticles=false
    bProjectBSP=true
    MaterialBlendingOp=PB_AlphaBlend
    ProjTexture=Texture'DH_Construction_tex.ui.construction_aura'
    FrameBufferBlendingOp=PB_AlphaBlend
    FOV=1
}

