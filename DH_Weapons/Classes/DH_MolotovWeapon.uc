//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovWeapon extends DHExplosiveWeapon;

var     bool            IgnitedAlready;

var     sound           IgnitionSound;
var     sound           ThrowSound;

simulated function Fire(float F)
{
    super.Fire(F);

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (IgnitedAlready == false)
        {
            IgnitedAlready = true;

            if (IgnitionSound != none)
            {
                PlaySound(IgnitionSound,,,, 100);
            }
        }
    }
}

simulated function PostFire()
{
    super.PostFire();

    if (ThrowSound != none)
    {
        PlaySound(ThrowSound,,,, 100);
    }
}

defaultproperties
{
    ItemName="Molotov"
    DisplayFOV=70.0
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    GroupOffset=3

    AttachmentClass=class'DH_Weapons.DH_MolotovAttachment'
    PickupClass=class'DH_Weapons.DH_MolotovPickup'
    FireModeClass(0)=class'DH_Weapons.DH_MolotovFire'
    FireModeClass(1)=class'DH_Weapons.DH_MolotovTossFire'

    // anims
    CrawlForwardAnim="crawl_F"
    CrawlBackwardAnim="crawl_B"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"

    // sound
    IgnitionSound=Sound'DH_MolotovCocktail.ignite'
    ThrowSound=Sound'DH_MolotovCocktail.throw'

    // mesh
    Mesh=SkeletalMesh'DH_Molotov_1st.Soviet'
    //HighDetailOverlay=shader'shader goes here'
}
