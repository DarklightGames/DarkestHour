//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMRadioOperatorRoles extends DHRomRoles
    abstract;

defaultproperties
{
    MyName="Radio Operator"
    AltName="aaa"
    Limit=1
    bCarriesRadio=true
    bCanBeSquadLeader=false
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_vz24Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M34GrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHRadioItem"  // make romanian radio!!
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}
