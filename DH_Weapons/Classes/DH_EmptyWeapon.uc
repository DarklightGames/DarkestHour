//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================
// For some silly reason, there's no way to just simply switch to having no
// weapon without dropping a current weapon. This weapon can be given to a
// player you want them to have no weapon without dropping their current weapon.
//==============================================================================

class DH_EmptyWeapon extends DHWeapon;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerDestroyEmptyWeapon;
}

// TODO: pretty sure this does nothing
// Overridden so nothing happens
simulated state IronSightZoomIn
{
}

// Overridden so nothing happens
simulated state IronSightZoomOut
{
}

// Overridden so nothing happens
simulated function Fire(float F) { }
simulated function AltFire(float F) { }
simulated exec function ROManualReload() { }

// Delete Holster from inventory
simulated function ServerDestroyEmptyWeapon()
{
    local Inventory Inv;

    if (Pawn(Owner) != none)
    {
        Inv = Pawn(Owner).FindInventoryType(self.Class);

        if (Inv != none)
        {
            Inv.Destroy();
        }
    }
}

// Get rid of Holster when the player switches weapons
simulated function Weapon WeaponChange(byte F, bool bSilent)
{
    ServerDestroyEmptyWeapon();

    return super.WeaponChange(F, bSilent);
}

// Get rid of Holster when the player switches weapons
simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    local Weapon WeaponResult;

    WeaponResult = super.PrevWeapon(CurrentChoice, CurrentWeapon);

    ServerDestroyEmptyWeapon();

    return WeaponResult;
}

// Get rid of Holster when the player switches weapons
simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    local Weapon WeaponResult;

    WeaponResult = super.NextWeapon(CurrentChoice, CurrentWeapon);

    ServerDestroyEmptyWeapon();

    return WeaponResult;
}

defaultproperties
{
     SprintStartAnim="Idle"
     SprintLoopAnim="Idle"
     SprintEndAnim="Idle"
     CrawlForwardAnim="Idle"
     CrawlBackwardAnim="Idle"
     CrawlStartAnim="Idle"
     CrawlEndAnim="Idle"
     FireModeClass(0)=Class'DH_Weapons.DH_EmptyFire'
     FireModeClass(1)=Class'DH_Weapons.DH_EmptyFire'
     RestAnim="Idle"
     AimAnim="Idle"
     RunAnim="Idle"
     SelectAnim="Idle"
     PutDownAnim="Idle"
     bCanThrow=false
     Priority=100
     bUsesFreeAim=false
     bCanSway=false
     InventoryGroup=69
     PlayerViewOffset=(X=-6.000000,Y=-6.000000,Z=10.000000)
     PlayerViewPivot=(Roll=-2730)
     AttachmentClass=Class'DH_Weapons.DH_EmptyAttachment'
     ItemName=" "
//     Mesh=SkeletalMesh'29thCharacter.29sal1st'
}
