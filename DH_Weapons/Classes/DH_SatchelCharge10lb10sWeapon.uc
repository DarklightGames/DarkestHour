//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_SatchelCharge10lb10sWeapon extends DHExplosiveWeapon;

#exec OBJ LOAD FILE=..\Animations\Common_Satchel_1st.ukx

simulated state RaisingWeapon
{
    simulated function EndState()
    {
        super.EndState();

        if (Instigator != none && ROPlayer(Instigator.Controller) != none)
        {
            ROPlayer(Instigator.Controller).CheckForHint(7);
        }
    }
}

defaultproperties
{
    ItemName="10lb Satchel Charge"
    Mesh=mesh'Common_Satchel_1st.Sachel_Charge'
    PlayerViewOffset=(X=10.0,Y=5.0,Z=0.0)
    bCanThrow=false // cannot be dropped
    FuzeLength=15.0 // was 10
    FireModeClass(0)=class'DH_Weapons.DH_SatchelCharge10lb10sFire'
    FireModeClass(1)=class'DH_Weapons.DH_SatchelCharge10lb10sFire'
    PickupClass=class'DH_Weapons.DH_SatchelCharge10lb10sPickup'
    AttachmentClass=class'DH_Weapons.DH_SatchelCharge10lb10sAttachment'
    PreFireHoldAnim="Weapon_Down"
    bSniping=false // so bots will use this weapon to take long range shots
    InventoryGroup=6
}
