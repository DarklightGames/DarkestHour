//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHRadioItem extends DHWeapon;

var class<DHArtilleryTrigger>   ArtilleryTriggerClass;
var DHArtilleryTrigger          ArtilleryTrigger;
var name                        AttachBoneName;

simulated function PreBeginPlay()
{
    local DHPawn P;

    P = DHPawn(Instigator);

    if (P == none || P.CarriedRadioTrigger != none)
    {
        Destroy();

        return;
    }

    super.PreBeginPlay();
}

simulated function PostBeginPlay()
{
    local DHPawn P;

    P = DHPawn(Instigator);

    if (P != none)
    {
        AttachToPawn(P);
    }

    super.PostBeginPlay();
}

function AttachToPawn(Pawn P)
{
    local DHGameReplicationInfo GRI;
    local DHPawn DHP;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
    DHP = DHPawn(P);

    if (GRI == none || DHP == none || DHP.CarriedRadioTrigger != none)
    {
        return;
    }

    ArtilleryTrigger = Spawn(ArtilleryTriggerClass, P);

    switch (P.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            ArtilleryTrigger.TeamCanUse = AT_Axis;
            break;
        case ALLIES_TEAM_INDEX:
            ArtilleryTrigger.TeamCanUse = AT_Allies;
            break;
        default:
            ArtilleryTrigger.TeamCanUse = AT_Both;
            break;
    }

    ArtilleryTrigger.Carrier = DHP;

    DHP.CarriedRadioTrigger = ArtilleryTrigger;

    GRI.AddCarriedRadioTrigger(ArtilleryTrigger);

    P.AttachToBone(ArtilleryTrigger, AttachBoneName);
}

// Colin: The following functions make it impossible to select the radio as the
// current weapon.
simulated function Weapon WeaponChange(byte F, bool bSilent)
{
    if (Inventory != none)
    {
        return Inventory.WeaponChange(F, bSilent);
    }

    return none;
}

simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if (Inventory != none)
    {
        return Inventory.NextWeapon(CurrentChoice, CurrentWeapon);
    }

    return none;
}

simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if (Inventory != none)
    {
        return Inventory.NextWeapon(CurrentChoice, CurrentWeapon);
    }

    return none;
}

defaultproperties
{
    FireModeClass(0)=class'ROInventory.ROEmptyFireclass'
    FireModeClass(1)=class'ROInventory.ROEmptyFireclass'
    InventoryGroup=10
    AttachBoneName="hip"
    ArtilleryTriggerClass=class'DH_Engine.DHArtilleryTrigger'
    AttachmentClass=class'DH_Equipment.DHRadioAttachment'
    ItemName="Radio"
}
