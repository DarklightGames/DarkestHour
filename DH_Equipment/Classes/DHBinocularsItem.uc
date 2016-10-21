//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHBinocularsItem extends DHProjectileWeapon; // obviously not really a projectile weapon, but that class has most of the necessary functionality, e.g. zoom in for ironsight mode

#exec OBJ LOAD FILE=Weapon_overlays.utx
#exec OBJ LOAD FILE=..\Animations\Common_Binoc_1st.ukx

var     texture     BinocsOverlay;
var     float       BinocsEnlargementFactor;

// Functions emptied out or returning false, as binoculars aren't a real weapon
simulated function bool IsFiring() {return false;}
simulated event ClientStartFire(int Mode) {return;}
simulated event StopFire(int Mode) {return;}
simulated function bool IsBusy() {return false;}
function bool FillAmmo() {return false;}

// Modified to add fire button functionality for mortar observer or artillery officer roles to mark targets
simulated function Fire(float F)
{
    local DHPawn P;
    local DHRoleInfo RI;
    local DHPlayer PC;

    if (bUsingSights && Instigator != none && Instigator.IsLocallyControlled())
    {
        P = DHPawn(Instigator);

        if (P != none)
        {
            RI = P.GetRoleInfo();
        }

        if (RI != none)
        {
            PC = DHPlayer(Instigator.Controller);
        }

        if (PC != none)
        {
            if (RI.bIsMortarObserver)
            {
                PC.ServerSaveMortarTarget(false);
            }
            else if (RI.bIsArtilleryOfficer)
            {
                PC.ServerSaveArtilleryPosition();
            }
        }
    }
}

// Modified to add alt fire button functionality for mortar observer or to mark smoke targets
simulated function AltFire(float F)
{
    local DHPawn P;
    local DHRoleInfo RI;
    local DHPlayer PC;

    if (bUsingSights && Instigator != none && Instigator.IsLocallyControlled())
    {
        P = DHPawn(Instigator);

        if (P != none)
        {
            RI = P.GetRoleInfo();
        }

        if (RI != none)
        {
            PC = DHPlayer(Instigator.Controller);
        }

        if (PC != none && RI.bIsMortarObserver)
        {
            PC.ServerSaveMortarTarget(true);
        }
    }
}

// Modified to add binoculars hint for mortar observer or artillery officer
simulated function BringUp(optional Weapon PrevWeapon)
{
    local DHPawn P;

    super(ROWeapon).BringUp(PrevWeapon);

    P = DHPawn(Instigator);

    if (P != none && P.GetRoleInfo() != none && InstigatorIsLocallyControlled() && DHPlayer(Instigator.Controller) != none)
    {
        if (P.GetRoleInfo().bIsMortarObserver)
        {
            DHPlayer(Instigator.Controller).QueueHint(11, true);
        }
        else if (P.GetRoleInfo().bIsArtilleryOfficer)
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
        SetPlayerFOV(PlayerIronsightFOV); // if there's no animation, go to zoomed FOV now
    }

    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetIronSightAnims(true);
    }
}

// Modified to draw the binoculars overlay when player has them raised
simulated event RenderOverlays(Canvas Canvas)
{
    local ROPawn  RPawn;
    local rotator RollMod;
    local int     LeanAngle;
    local float   PosX, Overlap;

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

    if (bPlayerViewIsZoomed)
    {
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;

        // Draw the binoculars overlay
        PosX = float(Canvas.SizeX - Canvas.SizeY) / 2.0 - Canvas.SizeY * BinocsEnlargementFactor;
        Canvas.SetPos(PosX, -BinocsEnlargementFactor * Canvas.SizeY);
        Canvas.DrawTile(BinocsOverlay, Canvas.SizeY * (1.0 + 2.0 * BinocsEnlargementFactor), Canvas.SizeY * (1.0 + 2.0 * BinocsEnlargementFactor), 0.0, 0.0, BinocsOverlay.USize, BinocsOverlay.VSize);

        // Draw black bars on the sides
        Overlap = 58.0 / float(BinocsOverlay.VSize) * Canvas.SizeY * (1.0 + BinocsEnlargementFactor);
        Canvas.SetPos(0.0, 0.0);
        Canvas.DrawTile(texture'Engine.BlackTexture', PosX + Overlap, Canvas.SizeY, 0.0, 0.0, 8.0, 8.0);
        Canvas.SetPos(Canvas.SizeX - PosX - Overlap, 0.0);
        Canvas.DrawTile(texture'Engine.BlackTexture', PosX + Overlap, Canvas.SizeY, 0.0, 0.0, 8.0, 8.0);
    }
    else
    {
        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, DisplayFOV);
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
    InventoryGroup=4
    Priority=1
    bCanAttachOnBack=false

    Mesh=mesh'Common_Binoc_1st.binoculars'
    HighDetailOverlay=shader'Weapons1st_tex.SniperScopes.Binoc_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    BinocsOverlay=texture'Weapon_overlays.Scopes.BINOC_overlay'
    BinocsEnlargementFactor=0.2
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
