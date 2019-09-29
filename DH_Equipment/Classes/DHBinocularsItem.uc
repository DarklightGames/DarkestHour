//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHBinocularsItem extends DHProjectileWeapon; // obviously not really a projectile weapon, but that class has most of the necessary functionality, e.g. zoom in for ironsight mode

#exec OBJ LOAD FILE=Weapon_overlays.utx
#exec OBJ LOAD FILE=..\Animations\Common_Binoc_1st.ukx

var     texture     BinocsOverlay;
//var     float       BinocsEnlargementFactor;  --Deprecating this; not needed with new draw function

// Functions emptied out or returning false, as binoculars aren't a real weapon
simulated function bool IsFiring() {return false;}
simulated event ClientStartFire(int Mode) {return;}
simulated event StopFire(int Mode) {return;}
simulated function bool IsBusy() {return false;}
function bool FillAmmo() {return false;}

// Modified to ignore InventoryGroup, so this item can be picked up regardless if its group is occupied
function bool HandlePickupQuery(Pickup Item)
{
    local int i, Count, MagCount, RoundsRemaining;
    local DHWeaponPickup WP;

    // If no passed item, prevent pick up & stop checking rest of Inventory chain
    if (Item == none)
    {
        return true;
    }

    // Pickup weapon is same as this weapon, so see if we can pick up any spare
    // mags from it
    if (Class == Item.InventoryType && WeaponPickup(Item) != none)
    {
        WP = DHWeaponPickup(Item);

        // If we already have max mags, prevent pick up & stop checking rest of
        // Inventory chain (same if pickup isn't a DHWeaponPickup & won't have
        // stored mags)
        if (WP != none)
        {
            // Colin: Going to keep it simple here. This function is just going to
            // pool all the ammunition together and give as many magazines as it can
            // rather than some complicated thing where we have to sort out which
            // magazines are more full and what to take.

            // Count up all the rounds of ammunition in the pickup
            for (i = 0; i < WP.AmmoMags.Length; ++i)
            {
                Count += WP.AmmoMags[i];
            }

            // Calculate the amount of full magazines
            MagCount = Count / MaxAmmo(0);

            // Calculate the amount of remaining ammunition after filling up as many
            // magazines as we could
            RoundsRemaining = Count % MaxAmmo(0);

            // Add full magazines
            for (i = 0; PrimaryAmmoArray.Length < MaxNumPrimaryMags && i < MagCount; ++i)
            {
                PrimaryAmmoArray[PrimaryAmmoArray.Length] = MaxAmmo(0);
            }

            // Add magazine
            if (PrimaryAmmoArray.Length < MaxNumPrimaryMags && RoundsRemaining > 0)
            {
                PrimaryAmmoArray[PrimaryAmmoArray.Length] = RoundsRemaining;
            }
        }

        if (IsCurrentWeapon())
        {
            UpdateResupplyStatus(true);
        }

        // Need to do this here as we're going to prevent a new weapon pick up, so the pickup won't give a screen message or destroy/respawn itself
        Item.AnnouncePickup(Pawn(Owner));
        Item.SetRespawn();

        return true; // prevents pick up, as already have weapon, & stops checking rest of Inventory chain
    }

    // Didn't do any pick up for this weapon, so pass this query on to the next item in the Inventory chain
    // If we've reached the last Inventory item, returning false will allow pick up of the weapon
    return Inventory != none && Inventory.HandlePickupQuery(Item);
}

// Modified to add fire button functionality for artillery observer or artillery officer roles to mark targets
simulated function Fire(float F)
{
    local DHRoleInfo RI;
    local DHPlayer   PC;
    local DHPlayerReplicationInfo PRI;
    local DHPawn P;

    if (bUsingSights && Instigator != none && Instigator.IsLocallyControlled())
    {
        P = DHPawn(Instigator);

        if (P == none)
        {
            return;
        }

        RI = P.GetRoleInfo();
        PRI = DHPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
        PC = DHPlayer(Instigator.Controller);

        if (RI == none || PRI == none || PC == none)
        {
            return;
        }

        if (RI.bIsArtilleryOfficer || PRI.IsSquadLeader())
        {
            PC.ServerSaveArtilleryPosition();
        }
    }
}

// Modified to add binoculars hint for artillery observer or artillery officer
simulated function BringUp(optional Weapon PrevWeapon)
{
    local DHPawn P;

    super(ROWeapon).BringUp(PrevWeapon);

    P = DHPawn(Instigator);

    if (P != none && P.GetRoleInfo() != none && InstigatorIsLocallyControlled() && DHPlayer(Instigator.Controller) != none)
    {
        if (P.GetRoleInfo().bIsArtilleryOfficer)
        {
            DHPlayer(Instigator.Controller).QueueHint(12, true);
        }
    }
}

// Modified to avoid re-setting DHPawn.bPreventWeaponFire to false, as binocs can never fire (doesn't actually make a difference, but avoids unnecessary update on replicated variable)
simulated state RaisingWeapon
{
    simulated function EndState()
    {
    }
}

// Modified to avoid zooming in until raising binoculars animation finishes
simulated function ZoomIn(optional bool bAnimateTransition)
{
    // Don't allow player to go to ironsights while in melee mode
    if (FireMode[1].bIsFiring || FireMode[1].IsInState('MeleeAttacking'))
    {
        return;
    }

    bUsingSights = true;

    // Make the player stop firing when they go to ironsights
    if (FireMode[0].bIsFiring)
    {
        FireMode[0].StopFiring();
    }

    if (bAnimateTransition)
    {
        GotoState('IronSightZoomIn');
    }
    else if (InstigatorIsLocalHuman())
    {
        SetPlayerFOV(GetPlayerIronsightFOV()); // if there's no animation, go to zoomed FOV now
    }

    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetIronSightAnims(true);
    }
}

// Modified to draw the binoculars overlay when player has them raised
simulated event RenderOverlays(Canvas C)
{
    local ROPawn  RPawn;
    local rotator RollMod;
    local int     LeanAngle;
    //local float   PosX, Overlap;
    local float   ScreenRatio;

    if (Instigator == none)
    {
        return;
    }

    // Adjust weapon position for lean
    RPawn = ROPawn(Instigator);

    if (RPawn != none && RPawn.LeanAmount != 0.0)
    {
        LeanAngle += RPawn.LeanAmount;
    }

    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    // Remove the roll component so the weapon doesn't tilt with the terrain
    RollMod = Instigator.GetViewRotation();
    RollMod.Roll += LeanAngle;

    if (IsCrawling())
    {
        RollMod.Pitch = CrawlWeaponPitch;
    }

    SetRotation(RollMod);

    if (bPlayerViewIsZoomed && BinocsOverlay != none)
    {
        ScreenRatio = float(C.SizeY) / float(C.SizeX);
        C.SetPos(0.0, 0.0);

        C.DrawTile(BinocsOverlay, C.SizeX, C.SizeY,                         // screen drawing area (to fill screen)
            0.0, (1.0 - ScreenRatio) * float(BinocsOverlay.VSize) / 2.0,    // position in texture to begin drawing tile (from left edge, with vertical position to suit screen aspect ratio)
            BinocsOverlay.USize, float(BinocsOverlay.VSize) * ScreenRatio); // width & height of tile within texture
    }
    else
    {
        bDrawingFirstPerson = true;
        C.DrawActor(self, false, false, DisplayFOV);
        bDrawingFirstPerson = false;
    }
}


function bool CanDeadThrow()
{
    return false;
}

defaultproperties
{
    ItemName="Binoculars"
    AttachmentClass=class'DH_Equipment.DHBinocularsAttachment'
    PickupClass=class'DH_Equipment.DHBinocularsPickup'
    InventoryGroup=6
    GroupOffset=1
    Priority=1
    bCanAttachOnBack=false

    Mesh=SkeletalMesh'Common_Binoc_1st.binoculars'
    HighDetailOverlay=shader'Weapons1st_tex.SniperScopes.Binoc_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    BinocsOverlay=Texture'Weapon_overlays.Scopes.BINOC_overlay'
    //BinocsEnlargementFactor=0.2 -- deprecating; don't need
    IronSightDisplayFOV=70.0
    bPlayerFOVZooms=true
    PlayerFOVZoom=12.0
    bCanSway=false

    IronBringUp="Zoom_in"
    IronIdleAnim="Zoom_idle"
    IronPutDown="Zoom_out"

    AIRating=0.0
    CurrentRating=0.0
}
