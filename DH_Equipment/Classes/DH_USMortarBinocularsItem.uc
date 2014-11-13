//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USMortarBinocularsItem extends DH_BinocularsItem;

// Attempt to save the artillery strike positions
simulated function Fire(float F)
{
    // added check for player to be in iron view to save arty coords - Antarian
    if ((Instigator == none) || (Instigator.Controller == none)
        || (AIController(Instigator.Controller) != none) || !bUsingSights)
       return;

        // server
    if (Instigator.IsLocallyControlled())
       DHPlayer(Instigator.Controller).ServerSaveMortarTarget();
}

simulated function AltFire(float F)
{
    if (Instigator.IsLocallyControlled())
        DHPlayer(Instigator.Controller).ServerCancelMortarTarget();
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    local DHPlayer DHP;

    super.BringUp(PrevWeapon);

    if (Instigator.IsLocallyControlled())
    {
        DHP = DHPlayer(Instigator.Controller);

        if (DHP != none)
            DHP.QueueHint(11, true);
    }
}

defaultproperties
{
     AttachmentClass=Class'DH_Equipment.DH_USMortarBinocularsAttachment'
}
