//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAxisMarksmanRoles extends DHAxisRoles
    abstract;

defaultproperties
{
    MyName="Marksman"   //historically, there was no "marksman" type role within the wehrmacht or Waffen-SS, however the ZF41 was given out to fullfill this role and there was no distinction between snipers with or without
    AltName="Scharfsch�tze" //the native role name reflects this, but the translated name is there so that people can understand that this isnt a true "sniper"
    Article="a "        
    PluralName="Snipers"    
    Limit=2
    AddedRoleRespawnTime=8  //"snipers" or marksman with the zf41 get a penaulty for respawn, but it is not as high as regular higher level snipers
    bExemptSquadRequirement=true
    bCanBeSquadLeader=false
}
