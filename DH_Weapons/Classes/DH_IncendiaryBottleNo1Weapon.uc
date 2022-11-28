//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_IncendiaryBottleNo1Weapon extends DHExplosiveWeapon;

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
    ItemName="Flammable mixture No.1"
    DisplayFOV=70.0
    GroupOffset=3

    AttachmentClass=class'DH_Weapons.DH_IncendiaryBottleNo1Attachment'
    PickupClass=class'DH_Weapons.DH_IncendiaryBottleNo1Pickup'
    FireModeClass(0)=class'DH_Weapons.DH_IncendiaryBottleNo1Fire'
    FireModeClass(1)=class'DH_Weapons.DH_IncendiaryBottleNo1TossFire'

    // Mesh
    Mesh=SkeletalMesh'DH_IncendiaryBottles_1st.BottleNo1_1st'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    HandNum=1
    SleeveNum=0

    // Animations
    CrawlForwardAnim="crawl_F"
    CrawlBackwardAnim="crawl_B"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
}
