//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHWireCuttersItem extends DHWeapon;

var name                CutAnim;
var DHObstacleInstance  ObstacleBeingCut;
var float               CutDistance;

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
        local DHPawn P;

        P = DHPawn(Instigator);

        if (P != none)
        {
            P.SetIsCuttingWire(true);
        }

        PlayAnim(CutAnim);

        SetTimer(ObstacleBeingCut.Info.GetCutDuration(), false);
    }

    simulated function EndState()
    {
        local DHPawn P;

        P = DHPawn(Instigator);

        if (P != none)
        {
            P.SetIsCuttingWire(false);
        }
    }

    simulated function Timer()
    {
        local DHPlayer P;

        if (Instigator != none)
        {
            P = DHPlayer(Instigator.Controller);
        }

        if (P != none)
        {
            P.ServerClearObstacle(ObstacleBeingCut.Info.Index);
        }

        GotoState('');
        PlayAnim('cutEnd', 1.0, 0.2);
    }

    simulated function AnimEnd(int Channel)
    {
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
                PlayAnim('cutVin');
                break;
            default:
                break;
        }
    }

    simulated function Tick(float DeltaTime)
    {
        super.Tick(DeltaTime);

        if (ObstacleBeingCut == none || ObstacleBeingCut.Info.IsCleared())
        {
            GotoState('');
            PlayAnim('cutEnd', 1.0, 0.2);
        }
    }
}

simulated function Fire(float F)
{
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;
    local DHObstacleInstance O;

    if (Instigator == none ||
        Instigator.Controller == none ||
        Instigator.IsProneTransitioning() ||
        Instigator.Velocity != vect(0.0, 0.0, 0.0))
    {
        return;
    }

    TraceStart = Instigator.Location;
    TraceEnd = TraceStart + vector(Instigator.Controller.Rotation) * CutDistance;

    foreach TraceActors(class'DHObstacleInstance', O, HitLocation, HitNormal, TraceEnd, TraceStart, vect(1.0, 1.0, 1.0))
    {
        if (O != none && !O.Info.IsCleared() && O.Info.CanBeCut())
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
    Mesh=mesh'DH_Wirecutters_1st.wirecutters'
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
    CutDistance=100.0
}
