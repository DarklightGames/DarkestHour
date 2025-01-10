//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarHandsActor extends Actor;

var() int HandsSkinIndex;
var() int SleeveSkinIndex;

simulated function SetSkins(DHPlayer PC)
{
    local DHRoleInfo RI;

    if (PC != none)
    {
        RI = DHRoleInfo(PC.GetRoleInfo());
    }

    if (RI != none)
    {
        Skins[HandsSkinIndex] = RI.GetHandTexture(class'DH_LevelInfo'.static.GetInstance(Level));
        Skins[SleeveSkinIndex] = RI.static.GetSleeveTexture();
    }
}

defaultproperties
{
    DrawType=DT_Mesh
    bOnlyOwnerSee=True
    bOnlyDrawIfAttached=True
    RemoteRole=ROLE_None
    HandsSkinIndex=0
    SleeveSkinIndex=1
}
