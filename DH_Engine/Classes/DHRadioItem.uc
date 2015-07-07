//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHRadioItem extends DHWeapon
    abstract;

var class<DHArtilleryTrigger>   ArtilleryTriggerClass;
var DHArtilleryTrigger          ArtilleryTrigger;
var int                         TeamCanUse;
var name                        AttachBoneName;

simulated function PreBeginPlay()
{
    local DHPawn DHP;

    DHP = DHPawn(Instigator);

    if (DHP == none || DHP.CarriedRadioTrigger != none)
    {
        Destroy();

        return;
    }

    super.PreBeginPlay();
}

function AttachToPawn(Pawn P)
{
    local DHGameReplicationInfo GRI;
    local DHPawn DHP;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
    DHP = DHPawn(P);

    if (GRI == none || DHP == none)
    {
        return;
    }

    ArtilleryTrigger = Spawn(ArtilleryTriggerClass, P);

    switch (TeamCanUse)
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
    else
    {
        return none;
    }
}

simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if (Inventory != none)
    {
        return Inventory.NextWeapon(CurrentChoice, CurrentWeapon);
    }
    else
    {
        return none;
    }
}

simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if (Inventory != none)
    {
        return Inventory.NextWeapon(CurrentChoice, CurrentWeapon);
    }
    else
    {
        return none;
    }
}

defaultproperties
{
    FireModeClass(0)=class'ROInventory.ROEmptyFireclass'
    FireModeClass(1)=class'ROInventory.ROEmptyFireclass'
    InventoryGroup=10
    TeamCanUse=NEUTRAL_TEAM_INDEX
    AttachBoneName="hip"
    ArtilleryTriggerClass=class'DH_Engine.DHArtilleryTrigger'
}

