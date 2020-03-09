//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_GLWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="M24 x7 Geballte Ladung"

    FireModeClass(0)=class'DH_Weapons.DH_GLFire'
    AttachmentClass=class'DH_Weapons.DH_GLAttachment'
    PickupClass=class'DH_Weapons.DH_GLPickup'
    FuzeLength=6.0

    InventoryGroup=7
    GroupOffset=1
    Priority=2

    Mesh=SkeletalMesh'DH_GL_1st.geballteLadung_mesh'
    Skins(2)=Texture'DH_Weapon_CC2_tex.Grenades.gl_skin'
    bUseHighDetailOverlayIndex=false
    DisplayFOV=65.0
    PlayerViewOffset=(X=10.0,Y=5.0,Z=0.0)

    SprintStartAnim="Sprint_Start"
    SprintLoopAnim="Sprint_Middle"
    SprintEndAnim="Sprint_Stop"
    PreFireHoldAnim="Weapon_Down"
}
