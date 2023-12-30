//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [1] https://web.archive.org/web/20170505040922/http://www.quarryhs.co.uk/ammotable6.html
// [2] https://en.wikipedia.org/wiki/Cannone_da_47/32#Characteristics
// [3] https://bergerbullets.com/form-factors-a-useful-analysis-tool/
// [4] https://www.longrangehunting.com/threads/g7-to-g1-conversion.292082/
// [5] https://wwiitanks.co.uk/FORM-Gun_Data.php?I=192
//===============================================================================

class DH_Cannone4732CannonShell extends DHItalianCannonShell;

defaultproperties
{
    RoundType=RT_APC
    Speed=38022 // 630 m/s
    MaxSpeed=38022
    ShellDiameter=4.7

    // The ballistic coefficient of this shell is calculated using the G7 form factor and then crudely converting it to G1.
    // Sectional Density = (mass (lb) / (diameter (in)^2)
    // 3.17 lb / 1.85 in^2 = 0.92719325613011248803204100369853
    // Form Factor: 1.006 (approximate)
    // G7 = Sectional Density / Form Factor
    // G1 = G7 / 0.512 [3]
    BallisticCoefficient=1.8218

    //Damage
    ImpactDamage=325  // 18 gramms TNT filler // TODO: not sure what this should be, but the damage should be comparable to similar shells
    ShellImpactDamage=class'DH_Guns.DH_Cannone4732CannonShellDamageAP'
    HullFireChance=0.30
    EngineFireChance=0.55

    // The penetrable table is based on [5].
    // I plotted the data from the table then ran a parabolic regression on it, then sampled the table at the distances we need.
    DHPenetrationTable(0)=6.3   // 100m
    DHPenetrationTable(1)=5.7   // 250m
    DHPenetrationTable(2)=5.0   // 500m
    DHPenetrationTable(3)=4.4   // 750m
    DHPenetrationTable(4)=3.9   // 1000m
    DHPenetrationTable(5)=3.4   // 1250m
    DHPenetrationTable(6)=2.9   // 1500m
    DHPenetrationTable(7)=2.5   // 1750m
    DHPenetrationTable(8)=2.2   // 2000m
    DHPenetrationTable(9)=1.5   // 2500m
    DHPenetrationTable(10)=1.0  // 3000m

    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=0,RangeValue=59)
    MechanicalRanges(1)=(Range=100,RangeValue=59)
    MechanicalRanges(2)=(Range=200,RangeValue=59)
    MechanicalRanges(3)=(Range=300,RangeValue=70)
    MechanicalRanges(4)=(Range=400,RangeValue=84)
    MechanicalRanges(5)=(Range=500,RangeValue=104)
    MechanicalRanges(6)=(Range=600,RangeValue=110)
    MechanicalRanges(7)=(Range=700,RangeValue=126)
    MechanicalRanges(8)=(Range=800,RangeValue=142)
    MechanicalRanges(9)=(Range=900,RangeValue=158)
    MechanicalRanges(10)=(Range=1000,RangeValue=175)
    MechanicalRanges(11)=(Range=1100,RangeValue=194)
    MechanicalRanges(12)=(Range=1200,RangeValue=204)
    MechanicalRanges(13)=(Range=1300,RangeValue=224)
    MechanicalRanges(14)=(Range=1400,RangeValue=244)
    MechanicalRanges(15)=(Range=1500,RangeValue=264)
    MechanicalRanges(16)=(Range=1600,RangeValue=287)
    MechanicalRanges(17)=(Range=1700,RangeValue=308)
    MechanicalRanges(18)=(Range=1800,RangeValue=332)
    MechanicalRanges(19)=(Range=1900,RangeValue=356)
    MechanicalRanges(20)=(Range=2000,RangeValue=380)
}
