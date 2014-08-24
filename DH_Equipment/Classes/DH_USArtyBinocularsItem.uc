//=============================================================================
// DH_USArtyBinocularsItem
//=============================================================================

class DH_USArtyBinocularsItem extends DH_BinocularsItem;

// Attempt to save the artillery strike positions
simulated function Fire(float F)
{
    // added check for player to be in iron view to save arty coords - Antarian
    if ((Instigator == none) || (Instigator.Controller == none)
        || (AIController(Instigator.Controller) != none) || !bUsingSights)
       return;

        // server
    if (Instigator.IsLocallyControlled())
    {
       DHPlayer(Instigator.Controller).ServerSaveArtilleryPosition();
    }
}

defaultproperties
{
     AttachmentClass=Class'DH_Equipment.DH_USArtyBinocularsAttachment'
}
