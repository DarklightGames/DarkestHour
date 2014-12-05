//=============================================================================================
// DH_AdminMenu_ParachuteStaticLine - by Matt UK
//=============================================================================================
//
// Modified to properly handle dropping a bot without lots of "accessed none" errors in the log
// Also prevents most of the "accessed none" errors from the original whenever any player lands
//
//=============================================================================================
class DH_AdminMenu_ParachuteStaticLine extends DH_ParachuteStaticLine;

simulated function Tick(float DeltaTime)
{
    if (Instigator != none)
    {
        if (bChuteDeployed)
        {
            if (Instigator.Physics == PHYS_Falling)
            {
                Instigator.Velocity.Z = -400.0;

                if (Instigator.Weapon != class'DH_Equipment.DH_ParachuteItem')
                    Instigator.SwitchWeapon(12);
            }
            else
            {
                Instigator.AccelRate = Instigator.default.AccelRate;
                Instigator.AirControl = Instigator.default.AirControl;
                // changed hard-coded LandGrass sound with GetSound function, which returns a suitable sound based on what we landed on:
                Instigator.PlayOwnedSound(ROPawn(Instigator).GetSound(EST_Land), SLOT_Misc, 512.0, true, 128.0);
                RemoveChute(Instigator);

                if (ThirdPersonActor != none)
                {
                    RemoveChute(Instigator);
                }

                Instigator.Controller.ClientSwitchToBestWeapon(); // removed Instigator.Controller being cast to DHPlayer, which prevents "accessed none" log errors (cast is unecessary anyway)
//              Destroy(); // moved this to after the call to DeleteInventory because otherwise we are trying to delete nothing (since this item has already destroyed itself)
                Instigator.DeleteInventory(self);
                Destroy();
            }
        }
        else
        {
            if (Instigator.Physics == PHYS_Falling && Instigator.Velocity.Z < (-1.0 * Instigator.MaxFallSpeed))
            {
                bChuteDeployed = true;
                ROPawn(Instigator).Stamina = 0.0; // changed cast from DH_Pawn to ROPawn to make more generic
                Instigator.Controller.bCrawl = 0;
                Instigator.ShouldProne(false);
                Instigator.Switchweapon(12);
                AttachChute(Instigator);
                Instigator.PlaySound(sound'DH_SundrySounds.Parachute.ParachuteDeploy', SLOT_Misc, 512.0, true, 128.0);
                Instigator.AirControl = 1.0;
                Instigator.AccelRate = 60.0;
                Instigator.Velocity.Z = -400.0;
            }
        }
    }
}

defaultproperties
{
}
