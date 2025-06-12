//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SovietMolotovWeapon extends DHExplosiveWeapon;

// TODO: Move the ignition logic to the parent class
// var     bool            IgnitedAlready;

// var     sound           IgnitionSound;
// var     sound           ThrowSound;

// simulated function Fire(float F)
// {
//     super.Fire(F);

//     if (Level.NetMode != NM_DedicatedServer)
//     {
//         if (IgnitedAlready == false)
//         {
//             IgnitedAlready = true;

//             if (IgnitionSound != none)
//             {
//                 PlaySound(IgnitionSound,,,, 100);
//             }
//         }
//     }
// }

// simulated function PostFire()
// {
//     super.PostFire();

//     if (ThrowSound != none)
//     {
//         PlaySound(ThrowSound,,,, 100);
//     }
// }

defaultproperties
{
    ItemName="Anti tank incendiary grenade" // TODO: Find specific name for soviet molotov
    NativeItemName="??????????????? ????????????? ??????? (???????)"
    DisplayFOV=90
    GroupOffset=3

    AttachmentClass=class'DH_Weapons.DH_SovietMolotovAttachment'
    PickupClass=class'DH_Weapons.DH_SovietMolotovPickup'
    FireModeClass(0)=class'DH_Weapons.DH_SovietMolotovFire'
    FireModeClass(1)=class'DH_Weapons.DH_SovietMolotovTossFire'

    // Mesh
    Mesh=SkeletalMesh'DH_Molotovs.SovietMolotov'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    

    // Animations
    SelectAnim="Draw"
    IdleAnim="Idle"
    PutDownAnim="putaway"
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
}
