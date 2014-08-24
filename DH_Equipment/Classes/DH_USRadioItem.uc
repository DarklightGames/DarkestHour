//=============================================================================
// DH_USRadioItem
//=============================================================================

class DH_USRadioItem extends DHWeapon;

var     DHArtilleryTriggerUSMap     RadioTrigger;

function PickupFunction(Pawn Other)
{
    Super.PickupFunction(Other);

    AttachToPawn(Instigator);
    //Instigator.ClientMessage("Radio Operational");
    SetTimer(0.1, false);
}

function Timer()
{
    Destroy();
}

function AttachToPawn(Pawn P)
{
    local int i;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(DarkestHourGame(Level.Game).GameReplicationInfo);

    RadioTrigger = Spawn(Class'DHArtilleryTriggerUSMap', P);
    RadioTrigger.SetCarrier(P);                         // Tell the trigger who's carrying it for the purpose of scoring points
    DH_Pawn(P).CarriedRadioTrigger = RadioTrigger;         // Assign the new trigger to the pawn carrying it for deleting on death

    //Added in last patch so we can have a distinction between Allied and Axis radiomen.
    RadioTrigger.TeamCanUse = AT_Allies;

    for(i = 0; i < ArrayCount(GRI.CarriedAlliedRadios); i++)
    {
        if (GRI.CarriedAlliedRadios[i] == none)
        {
            GRI.CarriedAlliedRadios[i] = RadioTrigger;
            DH_Pawn(P).GRIRadioPos = i;
            break;
        }
    }

    P.AttachToBone(RadioTrigger,'hip');
}

defaultproperties
{
     FireModeClass(0)=Class'ROInventory.ROEmptyFireClass'
     FireModeClass(1)=Class'ROInventory.ROEmptyFireClass'
     InventoryGroup=10
     AttachmentClass=Class'DH_Equipment.DH_USRadioAttachment'
     ItemName="Radio"
}
