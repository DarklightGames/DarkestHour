//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHWireCuttersItem extends DHWeapon;

var name        CutAnim;
var DHObstacle  ObstacleBeingCut;

function bool FillAmmo()
{
    return false;
}

function bool ResupplyAmmo()
{
    return false;
}

simulated function bool IsFiring()
{
    return false;
}

simulated function bool ShouldUseFreeAim()
{
    return false;
}

simulated function bool IsBusy()
{
    return false;
}

simulated exec function ROManualReload()
{
    return;
}

simulated state Cutting
{
    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function bool WeaponCanSwitch()
    {
        return false;
    }

    simulated function BeginState()
    {
        local DH_Pawn P;

        P = DH_Pawn(Instigator);

        if (P != none)
        {
            P.SetIsCuttingWire(true);
        }

        // TODO: swap this out with variable
        PlayAnim(CutAnim);
    }

    simulated function EndState()
    {
        local DH_Pawn P;

        P = DH_Pawn(Instigator);

        if (P != none)
        {
            P.SetIsCuttingWire(false);
        }
    }

    simulated function AnimEnd(int Channel)
    {
        local DHPlayer P;
        local name SeqName;
        local float AnimRate, AnimFrame;

        GetAnimParams(Channel, SeqName, AnimFrame, AnimRate);

        super.AnimEnd(Channel);

        switch (SeqName)
        {
            case 'cutStart':
                PlayAnim('cutVin');
                break;
            case 'cutVin':
                PlayAnim('cutVout');
                break;
            case 'cutVout':
                PlayAnim('cutHin');
                break;
            case 'cutHin':
                PlayAnim('cutHout');
                break;
            case 'cutHout':
                PlayAnim('cutEnd');

                if (Instigator != none)
                {
                    P = DHPlayer(Instigator.Controller);

                    if (P != none && ObstacleBeingCut != none)
                    {
                        // Tell server to clear obstacle
                        P.ServerClearObstacle(ObstacleBeingCut.Index);
                    }

                    // Get out of cutting state
                    GotoState('');
                }

                break;
        }
    }
}

simulated function Fire(float F)
{
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;
    local DHObstacle O;

    if (Instigator == none ||
        Instigator.Controller == none ||
        Instigator.IsProneTransitioning() ||
        Instigator.Velocity != vect(0.0, 0.0, 0.0))
    {
        return;
    }

    TraceStart = Instigator.Location;
    TraceEnd = TraceStart + vector(Instigator.Controller.Rotation) * 100.0; // TODO: adjust this value

    foreach TraceActors(class'DHObstacle', O, HitLocation, HitNormal, TraceEnd, TraceStart, vect(1.0, 1.0, 1.0))
    {
        if (O != none && !O.IsCleared() && O.CanBeCut())
        {
            ObstacleBeingCut = O;

            GotoState('Cutting');

            break;
        }
    }
}

defaultproperties
{
    ItemName="Wire Cutters"
    Mesh=mesh'axis_wirecutter_1st.wirecutters'
    DrawScale=1.0
    DisplayFOV=70
    IronSightDisplayFOV=70
    BobDamping=1.6
    HighDetailOverlay=Material'Weapons1st_tex.SniperScopes.Binoc_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    bCanRestDeploy=false
    bUsesFreeAim=false
    AttachmentClass=class'DHWireCuttersAttachment'
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    SelectAnim=Draw
    PutDownAnim=putaway
    CrawlForwardAnim=crawlF
    CrawlBackwardAnim=crawlB
    CrawlStartAnim=crawlIn
    CrawlEndAnim=crawlOut
    ZoomInTime=0.4
    ZoomOutTime=0.2
    PlayerFOVZoom=10
    bPlayerFOVZooms=true
    AIRating=+0.0
    CurrentRating=0.0
    bSniping=false
    bCanThrow=false
    bCanSway=false
    InventoryGroup=4
    Priority=1
    FireModeClass(0)=class'ROInventory.ROEmptyFireClass'
    FireModeClass(1)=class'ROInventory.ROEmptyFireClass'
    CutAnim=cutStart
    SprintStartAnim=sprintStart
    SprintLoopAnim=sprintMiddle
    SprintEndAnim=sprintEnd
}
