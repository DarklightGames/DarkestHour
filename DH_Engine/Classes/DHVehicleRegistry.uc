//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHVehicleRegistry extends Object
    abstract;

struct SVehicleRecordVariant
{
    var string VariantName;
    var string ClassName;
};

struct SVehicleRecord
{
    var array<string> VehicleNames;
    var array<SVehicleRecordVariant> Variants;
};

var array<SVehicleRecord> Records;

static function string GetClassNameFromVehicleName(string VehicleName, optional string VariantName)
{
    local int i, j, k;

    VehicleName = Caps(VehicleName);

    for (i = 0; i < default.Records.Length; ++i)
    {
        for (j = 0; j < default.Records[i].VehicleNames.Length; ++j)
        {
            if (StrCmp(VehicleName, default.Records[i].VehicleNames[j]) == 0)
            {
                for (k = 0; k < default.Records[i].Variants.Length; ++k)
                {
                    if (StrCmp(default.Records[i].Variants[k].VariantName, VariantName) == 0)
                    {
                        return default.Records[i].Variants[k].ClassName;
                    }
                }

                return "";
            }
        }
    }

    return "";
}

static function DumpToLog(PlayerController PC)
{
    local int i, j;
    local array<string> VariantNames;
    local string LogLine;

    if (PC == none)
    {
        return;
    }

    for (i = 0; i < default.Records.Length; ++i)
    {
        VariantNames.Length = 0;
        LogLine = "";

        for (j = 0; j < default.Records[i].Variants.Length; ++j)
        {
            if (default.Records[i].Variants[j].VariantName == "")
            {
                continue;
            }

            VariantNames[VariantNames.Length] = default.Records[i].Variants[j].VariantName;
        }

        LogLine = class'UString'.static.Join(", ", default.Records[i].VehicleNames);

        if (VariantNames.Length > 0)
        {
            LogLine @= "-" @ "(" $ class'UString'.static.Join(", ", VariantNames) $ ")";
        }

        PC.Log(LogLine);
    }
}

defaultproperties
{

    //Vehicle registry for abbrivaiated names, this is to enable a person to spawn a vehicle without looking up the class name
    //Much like the weapon registry
    //TEMPLATE
    //Records()=(VehicleNames=(""),Variants=((ClassName="DH_Vehicles."),(ClassName="DH_Vehicles.",VariantName="")))

    //Watch for spaces between commas when defining variant type as this will throw an error
    //vehicles to be added go at the bottom of the stack under "to be filed"

    //wheeled vehicles (soft skin/lightly armored)
    //Soviet
    Records(0)=(VehicleNames=("ba64","clowncar"),Variants=((ClassName="DH_Vehicles.DH_BA64ArmoredCar"),(ClassName="DH_Vehicles.DH_BA64ArmoredCar_Snow",VariantName="snow")))
    Records(1)=(VehicleNames=("gaz67","gaz"),Variants=((ClassName="DH_Vehicles.DH_GAZ67Vehicle")))
    Records(2)=(VehicleNames=("zis5","ZiS5transport","zistransport"),Variants=((ClassName="DH_Vehicles.DH_ZiS5vTruckTransport")))
    Records(3)=(VehicleNames=("zislogi","zis5logi","ZiS5logi"),Variants=((ClassName="DH_Vehicles.DH_ZiS5vTruckSupport")))
    //American/British
    Records(4)=(VehicleNames=("gmc"),Variants=((ClassName="DH_Vehicles.DH_GMCTruckTransport"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_LL",VariantName="LL"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_LL_Snow",VariantName="LLsnow"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_Halloween",VariantName="haloween"),(ClassName="DH_Vehicles.DH_GMCTruckTransport_Halloween",VariantName="spooky")))
    Records(5)=(VehicleNames=("gmclogi","gmcsupply"),Variants=((ClassName="DH_Vehicles.DH_GMCTruckSupport"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_LL",VariantName="LL"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_LL_Snow",VariantName="LLsnow"),(ClassName="DH_Vehicles.DH_GMCTruckSupport_Halloween",VariantName="haloween")))
    Records(6)=(VehicleNames=("jeep","willysjeep"),Variants=((ClassName="DH_Vehicles.DH_WillysJeep"),(ClassName="DH_Vehicles.DH_WillysJeep_SovietRoof",VariantName="sovietroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Soviet",VariantName="soviet"),(ClassName="DH_Vehicles.DH_WillysJeep_SnowRoof",VariantName="snowroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_WillysJeep_Roof",VariantName="roof"),(ClassName="DH_Vehicles.DH_WillysJeep_ItalyRoof",VariantName="italyroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Italy",VariantName="italy"),(ClassName="DH_Vehicles.DH_WillysJeep_DesertRoof",VariantName="desertroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Desert",VariantName="desert"),(ClassName="DH_Vehicles.DH_WillysJeep_AirborneRoof",VariantName="airborneroof"),(ClassName="DH_Vehicles.DH_WillysJeep_Airborne",VariantName="airborne")))
    //German
    Records(7)=(VehicleNames=("kubel","kubelwagen"),Variants=((ClassName="DH_Vehicles.DH_KubelwagenCar_WH.uc"),(ClassName="DH_Vehicles.DH_KubelwagenCar_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_KubelwagenCar_SS",VariantName="SS"),(ClassName="DH_Vehicles.DH_KubelwagenCarTwo_SS",VariantName="SStwo")))
    Records(8)=(VehicleNames=("opel"),Variants=((ClassName="DH_Vehicles.DH_OpelBlitzTransport"),(ClassName="DH_Vehicles.DH_OpelBlitzTransport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_OpelBlitzTransport_NoTarp",VariantName="notarp")))
    Records(9)=(VehicleNames=("opellogi"),Variants=((ClassName="DH_Vehicles.DH_OpelBlitzSupport"),(ClassName="DH_Vehicles.DH_OpelBlitzSupport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_OpelBlitzSupport_NoTarp",VariantName="notarp")))
    
    //--+--

    //Armored cars, halftracks and tankettes (heavily Armored)
    //Soviet (there are none currently apart from the soviet universal carrier)
    Records(10)=(VehicleNames=("sovietcarrier","DTcarrier"),Variants=((ClassName="DH_Vehicles.DH_UniversalCarrierMG"),(ClassName="DH_Vehicles.DH_UniversalCarrierTransport_Snow",VariantName="snow")))
    //American
    Records(11)=(VehicleNames=("greyhound","m8"),Variants=((ClassName="DH_Vehicles.DH_GreyhoundArmoredCar"),(ClassName="DH_Vehicles.DH_GreyhoundArmoredCar_British",VariantName="british"),(ClassName="DH_Vehicles.DH_GreyhoundArmoredCar_Snow",VariantName="snow")))
    Records(12)=(VehicleNames=("m3halftrack","americanhalftrack","americanHT","m3"),Variants=((ClassName="DH_Vehicles.DH_M3A1HalftrackTransport"),(ClassName="DH_Vehicles.DH_M3A1HalftrackTransport_Soviet",VariantName="soviet"),(ClassName="DH_Vehicles.DH_M3A1HalftrackTransport_Soviet_Snow",VariantName="sovietsnow"),(ClassName="DH_Vehicles.DH_M3A1HalftrackTransport_Snow",VariantName="snow")))
    Records(13)=(VehicleNames=("m16halftrack","m16","quad50ht"),Variants=((ClassName="DH_Vehicles.DH_M16Halftrack"),(ClassName="DH_Vehicles.DH_M16Halftrack_Snow",VariantName="snow")))
    //British
    Records(14)=(VehicleNames=("brencarrier","universalcarrier"),Variants=((ClassName="DH_Vehicles.DH_BrenCarrierTransport"),(ClassName="DH_Vehicles.DH_BrenCarrierTransport_Italy",VariantName="italy"),(ClassName="DH_Vehicles.DH_BrenCarrierTransport_Africa",VariantName="africa")))
    //German
    Records(15)=(VehicleNames=("sdkfz105","sdk105","flakwagen"),Variants=((ClassName="DH_Vehicles.DH_Sdkfz105Transport"),(ClassName="DH_Vehicles.DH_Sdkfz105Transport_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_Sdkfz105Transport_Camo",VariantName="camo"),(ClassName="DH_Vehicles.DH_Sdkfz105TransportArmored",VariantName="armored"),(ClassName="DH_Vehicles.DH_Sdkfz105TransportArmored_Snow",VariantName="armoredsnow"),(ClassName="DH_Vehicles.DH_Sdkfz105TransportArmored_Camo",VariantName="armoredcamo")))
    Records(16)=(VehicleNames=("sdkfz251","germanhalftrack","germanht"),Variants=((ClassName="DH_Vehicles.DH_Sdkfz251Transport"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_Soviet",VariantName="soviet"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_SnowOne",VariantName="snow"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_SnowTwo",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_SnowWhiteWash",VariantName="snowthree"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoTwo",VariantName="camotwo"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoThree",VariantName="camothree"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_CamoFour",VariantName="camofour"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_Allies",VariantName="allies"),(ClassName="DH_Vehicles.DH_Sdkfz251Transport_Allies",VariantName="captured")))
    Records(17)=(VehicleNames=("sdkfz251/22","sdk251/22","sdkfz25122","pakwagen"),Variants=((ClassName="DH_Vehicles.DH_SdKfz251_22Transport")))
    Records(18)=(VehicleNames=("sdkfz251/9d","sdkfz251/9","sdkfz2519","sdk251/9","stummel"),Variants=((ClassName="DH_Vehicles.DH_SdKfz2519DTransport"),(ClassName="DH_Vehicles.DH_SdKfz2519DTransport_Snow",VariantName="snow")))
    Records(19)=(VehicleNames=("sdkfz234/1","sdk234/1","sdkfz2341","20mmpuma"),Variants=((ClassName="DH_Vehicles.DH_Sdkfz2341ArmoredCar"),(ClassName="DH_Vehicles.DH_Sdkfz2341ArmoredCar_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_Sdkfz2341ArmoredCar_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_Sdkfz2341ArmoredCar_CamoTwo",VariantName="camotwo")))
    Records(20)=(VehicleNames=("sdkfz234/2","sdk234/2","sdkfz2342","puma","50mmpuma"),Variants=((ClassName="DH_Vehicles.DH_Sdkfz2342ArmoredCar"),(ClassName="DH_Vehicles.DH_Sdkfz2342ArmoredCar_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_Sdkfz2342ArmoredCar_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.",VariantName="DH_Sdkfz2342ArmoredCar_CamoTwo")))
    Records(21)=(VehicleNames=("germancarrier","bren731","mg34carrier"),Variants=((ClassName="DH_Vehicles.DH_GermanCarrierTransport"),(ClassName="DH_Vehicles.DH_GermanCarrierTransport_Africa",VariantName="africa")))

    //--+--

    //light tanks
    //Soviet
    Records(22)=(VehicleNames=("t60"),Variants=((ClassName="DH_Vehicles.DH_T60Tank"),(ClassName="DH_Vehicles.DH_T60Tank_Snow",VariantName="snow")))
    Records(23)=(VehicleNames=("bt7"),Variants=((ClassName="DH_Vehicles.DH_BT7Tank"),(ClassName="DH_Vehicles.DH_BT7Tank_Snow",VariantName="snow")))
    //American/British
    Records(24)=(VehicleNames=("stuart","m5stuart"),Variants=((ClassName="DH_Vehicles.DH_StuartTank"),(ClassName="DH_Vehicles.DH_StuartTank_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_StuartTank_British",VariantName="british"),(ClassName="DH_Vehicles.DH_StuartTank_British",VariantName="mk6stuart")))
    //German(None currently)

    //--+--

    //medium tanks
    //Soviet
    Records(25)=(VehicleNames=("t34/76","t3476","t3476early","t34/76early"),Variants=((ClassName="DH_Vehicles.DH_T3476Tank"),(ClassName="DH_Vehicles.DH_T3476TankSnow",VariantName="snow"),(ClassName="DH_Vehicles.DH_T3476Tank_CamoA",VariantName="camo")))
    Records(26)=(VehicleNames=("t34/76m42","t3476m42","t34m42","m42"),Variants=((ClassName="DH_Vehicles.DH_T3476_42Tank"),(ClassName="DH_Vehicles.DH_T3476_42TankSnow",VariantName="snow")))
    Records(27)=(VehicleNames=("t34/76m43","t3476m43","t34m43","m43"),Variants=((ClassName="DH_Vehicles.DH_T3476_43Tank"),(ClassName="DH_Vehicles.DH_T3476_43TankSnow",VariantName="snow")))
    Records(28)=(VehicleNames=("t34/85","t3485"),Variants=((ClassName="DH_Vehicles.DH_T3485Tank"),(ClassName="DH_Vehicles.DH_T3485TankSnow",VariantName="snow"),(ClassName="DH_Vehicles.DH_T3485Tank_CamoA",VariantName="camo"),(ClassName="DH_Vehicles.DH_T3485Tank_Berlin",VariantName="berlin")))
    Records(29)=(VehicleNames=("sovietsherman","m4a2soviet","m4a275soviet"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A275W_Soviet"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A275W_Soviet_Snow",VariantName="snow")))
    Records(30)=(VehicleNames=("sovietsherman76","m4a276soviet"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A276W_Soviet"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A276W_Soviet_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A276W_Berlin",VariantName="berlin")))
    Records(31)=(VehicleNames=("capturedpanzer4f1","sovietpanzer4f1","t4f1","t_4f1"),Variants=((ClassName="DH_Vehicles.DH_T_4F1Tank")))
    Records(32)=(VehicleNames=("capturedpanzer4g","sovietpanzer4g","t4g","t_4g"),Variants=((ClassName="DH_Vehicles.DH_T_4GEarlyTank")))
    //American
    Records(33)=(VehicleNames=("m4a1","shermanearly","m4a175","m4a1/75"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank"),(ClassName="DH_Vehicles.DH_ShermanTank_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_ShermanTank_Camo",VariantName="camo"),(ClassName="DH_ShermanTank_DDay",VariantName="dday"),(ClassName="DH_ShermanTank_DDay",VariantName="DD")))
    Records(34)=(VehicleNames=("m4a3","m4a375","m4a3/75"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A375W"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A375W_Snow",VariantName="snow")))
    Records(35)=(VehicleNames=("m4a176","m4a1/76"),Variants=((ClassName="DH_ShermanTankA_M4A176W"),(ClassName="DH_Vehicles.DH_ShermanTankA_M4A176W_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_ShermanTankA_M4A176W_Early",VariantName="early"),(ClassName="DH_Vehicles.DH_ShermanTankA_M4A176W_Early_Camo",VariantName="earlycamo"),(ClassName="DH_Vehicles.DH_ShermanTankA_M4A176W_Camo",VariantName="camo"),(ClassName="DH_Vehicles.DH_ShermanTankB_M4A176W",VariantName="b"),(ClassName="DH_Vehicles.DH_ShermanTankB_M4A176W_Snow",VariantName="snowb")))
    Records(36)=(VehicleNames=("m4a376","m4a3/76"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A376W"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A376W_Early",VariantName="early"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A376W_Snow",VariantName="snow")))
    Records(37)=(VehicleNames=("m4a3e8","m4a3/e8","easyeight"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A3E8"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A3E8_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A3E8_Fury",VariantName="fury"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A3E8_ZombieSlayer",VariantName="haloween")))
    Records(38)=(VehicleNames=("sherman105","m4a3105","m4a3/105"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A3105_Howitzer"),(ClassName="DH_Vehicles.DH_ShermanTank_M4A3105_Snow",VariantName="snow")))
    //British
    Records(39)=(VehicleNames=("shermanbritish","shermanmk2","britishsherman"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_British")))
    Records(40)=(VehicleNames=("shermanfirefly","shermanmkvc","firefly"),Variants=((ClassName="DH_Vehicles.DH_ShermanFireflyTank")))
    Records(41)=(VehicleNames=("cromwellmk1","cromwellearly","cromwell6pdr","6pdrcromwell","cromwell1"),Variants=((ClassName="DH_Vehicles.DH_Cromwell6PdrTank"),(ClassName="DH_Vehicles.DH_Cromwell6PdrTank_Snow",VariantName="snow")))
    Records(42)=(VehicleNames=("cromwell","cromwell75","cromwellmk4","cromwell4"),Variants=((ClassName="DH_Vehicles.DH_CromwellTank"),(ClassName="DH_Vehicles.DH_CromwellTank_Snow",VariantName="snow")))
    Records(43)=(VehicleNames=("cromwellmk6","cromwell95","cromwellhowitzer","cromwell6"),Variants=((ClassName="DH_Vehicles.DH_Cromwell95mmTank"),(ClassName="DH_Vehicles.DH_Cromwell95mmTank_Snow",VariantName="snow")))
    //German
    Records(44)=(VehicleNames=("panzer3j","panzer3early","panzer3ausfj","panzer3ausf/j"),Variants=((ClassName="DH_Vehicles.DH_PanzerIIIJTank"),(ClassName="DH_Vehicles.DH_PanzerIIIJTank_Snow",VariantName="snow")))
    Records(45)=(VehicleNames=("panzer3l","panzer3ausfl","panzer3ausf/l","panzer3mid"),Variants=((ClassName="DH_Vehicles.DH_PanzerIIILTank"),(ClassName="DH_Vehicles.DH_PanzerIIILTank_SnowTwo",VariantName="snow"),(ClassName="DH_Vehicles.DH_PanzerIIILTank_Sand",VariantName="desert"),(ClassName="DH_Vehicles.DH_PanzerIIILTank_Camo",VariantName="camoone"),(ClassName="DH_Vehicles.DH_PanzerIIILTank_CamoTwo",VariantName="camotwo"),(ClassName="DH_Vehicles.DH_PanzerIIILTank_CamoThree",VariantName="camothree")))
    Records(46)=(VehicleNames=("panzer3n","panzer3late","panzer3ausfn","panzer3ausf/n"),Variants=((ClassName="DH_Vehicles.DH_PanzerIIINTank"),(ClassName="DH_Vehicles.DH_PanzerIIINTank_SnowTwo",VariantName="snow"),(ClassName="DH_Vehicles.DH_PanzerIIINTank_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_PanzerIIINTank_CamoTwo",VariantName="camotwo"),(ClassName="DH_Vehicles.DH_PanzerIIINTank_CamoThree",VariantName="camothree")))
    Records(47)=(VehicleNames=("panzer4f1","panzer4early","panzer4ausff1","panzer4ausf/f1"),Variants=((ClassName="DH_Vehicles.DH_PanzerIVF1Tank"),(ClassName="DH_Vehicles.DH_PanzerIVF1Tank_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_PanzerIVF1Tank_Sand",VariantName="desert"),(ClassName="DH_Vehicles.DH_PanzerIVF1Tank_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_PanzerIVF1Tank_CamoTwo",VariantName="camotwo")))
    Records(48)=(VehicleNames=("panzer4gearly","panzer4ausfgearly","panzer4ausf/gearly","panzer4gold"),Variants=((ClassName="DH_Vehicles.DH_PanzerIVGEarlyTank"),(ClassName="DH_Vehicles.DH_PanzerIVGEarlyTank_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_PanzerIVGEarlyTank_Sand",VariantName="desert"),(ClassName="DH_Vehicles.DH_PanzerIVGEarlyTank_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_PanzerIVGEarlyTank_CamoTwo",VariantName="camotwo")))
    Records(49)=(VehicleNames=("panzer4glate","panzer4g","panzer4ausfg","panzer4ausf/g","panzer4ausfglate","panzer4ausf/glate"),Variants=((ClassName="DH_Vehicles.DH_PanzerIVGLateTank"),(ClassName="DH_Vehicles.DH_PanzerIVGLateTank_SnowOne",VariantName="snowone"),(ClassName="DH_Vehicles.DH_PanzerIVGLateTank_SnowTwo",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_PanzerIVGLateTank_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_PanzerIVGLateTank_CamoTwo",VariantName="camotwo")))
    Records(50)=(VehicleNames=("panzer4h","panzer4ausfh","panzer4ausf/h"),Variants=((ClassName="DH_Vehicles.DH_PanzerIVHTank"),(ClassName="DH_Vehicles.DH_PanzerIVHTank_SnowOne",VariantName="snowone"),(ClassName="DH_Vehicles.DH_PanzerIVHTank_SnowTwo",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_PanzerIVHTank_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_PanzerIVHTank_CamoTwo",VariantName="camotwo"),(ClassName="DH_Vehicles.DH_PanzerIVHTank_CamoThree",VariantName="camothree"),(ClassName="DH_Vehicles.DH_PanzerIVHTank_21stPanzerDiv_Normandy",VariantName="camofour"),(ClassName="DH_Vehicles.DH_PanzerIVHTank_21stPanzerDiv_Normandy",VariantName="normandy")))
    Records(51)=(VehicleNames=("panzer4j","panzer4ausfj","panzer4ausf/j"),Variants=((ClassName="DH_Vehicles.DH_PanzerIVJTank"),(ClassName="DH_Vehicles.DH_PanzerIVJTank_SnowOne",VariantName="snowone"),(ClassName="DH_Vehicles.DH_PanzerIVJTank_SnowTwo",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_PanzerIVJTank_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_PanzerIVJTank_CamoTwo",VariantName="camotwo")))
    Records(52)=(VehicleNames=("capturedt34","germant34","germant3476","t34747","t34747r","germant34/76"),Variants=((ClassName="DH_Vehicles.DH_T3476Tank_German"),(ClassName="DH_Vehicles.DH_T3476Tank_GermanB",VariantName="b")))
    Records(53)=(VehicleNames=("capturedt3485","germant3485","germant34/85","t3485r"),Variants=((ClassName="DH_Vehicles.DH_T3485Tank_German")))
    
    //--+--

    //heavy tanks
    //Soviet
    Records(54)=(VehicleNames=("is2early","js2early"),Variants=((ClassName="DH_Vehicles.DH_IS2Tank"),(ClassName="DH_Vehicles.DH_IS2Tank_Snow",VariantName="snow")))
    Records(55)=(VehicleNames=("is2","is2late","js2late"),Variants=((ClassName="DH_Vehicles.DH_IS2Tank_Late"),(ClassName="DH_Vehicles.DH_IS2Tank_Late_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_IS2Tank_Late_Green",VariantName="green"),(ClassName="DH_Vehicles.DH_IS2Tank_Berlin",VariantName="berlin")))
    Records(56)=(VehicleNames=("kv1e","kv1early"),Variants=((ClassName="DH_Vehicles.DH_KV1ETank"),(ClassName="DH_Vehicles.DH_KV1ETank_Snow",VariantName="snow")))
    Records(57)=(VehicleNames=("kv1searly"),Variants=((ClassName="DH_Vehicles.DH_KV1sTank"),(ClassName="DH_Vehicles.DH_KV1sTank_Snow",VariantName="snow")))
    Records(58)=(VehicleNames=("kv1s","kv1slate"),Variants=((ClassName="DH_Vehicles.DH_KV1sTank_Late"),(ClassName="DH_Vehicles.DH_KV1sTank_Late_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_KV1sTank_Green",VariantName="green")))
    Records(59)=(VehicleNames=("capturedpanther","t5g","t_5g"),Variants=((ClassName="DH_Vehicles.DH_T_5GTank")))
    //American
    Records(60)=(VehicleNames=("jumbo","shermanjumbo","m4a3e2"),Variants=((ClassName="DH_Vehicles.DH_ShermanTank_M4A3E2_Jumbo")))
    //British
    Records(61)=(VehicleNames=("churchill","churchillmk7","churchill7"),Variants=((ClassName="DH_Vehicles.DH_ChurchillMkVIITank")))
    //German
    Records(62)=(VehicleNames=("pantherg","pantherausfg","pantherausf/g"),Variants=((ClassName="DH_Vehicles.DH_PantherGTank"),(ClassName="DH_Vehicles.DH_PantherGTank_SnowOne",VariantName="snowone"),(ClassName="DH_Vehicles.DH_PantherGTank_SnowTwo",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_PantherGTank_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_PantherGTank_CamoTwo",VariantName="camotwo"),(ClassName="DH_Vehicles.DH_PantherGTank_CamoThree",VariantName="camothree"),(ClassName="DH_VehiclesDH_PantherGTank_ArdennesOne.",VariantName="ardennesone"),(ClassName="DH_Vehicles.DH_PantherGTank_ArdennesTwo",VariantName="ardennestwo")))
    Records(63)=(VehicleNames=("pantherd","pantherausfd","pantherausf/d"),Variants=((ClassName="DH_Vehicles.DH_PantherDTank")))
    Records(64)=(VehicleNames=("tiger1early","tigerearly"),Variants=((ClassName="DH_Vehicles.DH_TigerTank"),(ClassName="DH_Vehicles.DH_TigerTank_Snow",VariantName="snow")))
    Records(65)=(VehicleNames=("tiger1","tigerlate","tiger1late"),Variants=((ClassName="DH_Vehicles.DH_TigerTank_Late"),(ClassName="DH_Vehicles.DH_TigerTank_SnowOne",VariantName="snow"),(ClassName="DH_Vehicles.DH_TigerTank_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_TigerTank_CamoTwo",VariantName="camotwo"),(ClassName="DH_Vehicles.DH_TigerTank_Ardennes",VariantName="ardennes"),(ClassName="DH_Vehicles.DH_TigerTank_Butcher",VariantName="haloween")))
    Records(66)=(VehicleNames=("kingtiger","tiger2","Konigstiger"),Variants=((ClassName="DH_Vehicles.DH_Tiger2BTank"),(ClassName="DH_Vehicles.DH_Tiger2BTank_Snow502",VariantName="snowone"),(ClassName="DH_Vehicles.DH_Tiger2BTank_ArdennesSnow332",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_Tiger2BTank_Ardennes",VariantName="ardennes"),(ClassName="DH_Vehicles.DH_Tiger2BTank_AmbushCamo212",VariantName="ambush")))
    
    //--+--

    //Tank destroyers/self-propelled guns
    //Soviet
    Records(67)=(VehicleNames=("su76"),Variants=((ClassName="DH_Vehicles.DH_SU76Destroyer"),(ClassName="DH_Vehicles.DH_SU76Destroyer_snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_SU76Destroyer_CamoA",VariantName="camo"),(ClassName="DH_Vehicles.DH_SU76Destroyer_Berlin",VariantName="berlin")))
    Records(68)=(VehicleNames=("isu152early"),Variants=((ClassName="DH_Vehicles.DH_ISU152Destroyer"),(ClassName="DH_Vehicles.DH_ISU152Destroyer_Snow",VariantName="snow")))
    Records(69)=(VehicleNames=("isu152","zveroboy"),Variants=((ClassName="DH_Vehicles.DH_ISU152Destroyer_Late"),(ClassName="DH_Vehicles.DH_ISU152Destroyer_Late_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_ISU152Destroyer_Late_Green",VariantName="green"),(ClassName="DH_Vehicles.DH_ISU152Destroyer_Berlin",VariantName="berlin")))
    //American
    Records(70)=(VehicleNames=("hellcat","m18hellcat","m18gmc",),Variants=((ClassName="DH_Vehicles.DH_HellcatTank"),(ClassName="DH_Vehicles.DH_HellcatTank_Snow",VariantName="snow")))
    Records(71)=(VehicleNames=("m10early","wolverineearly"),Variants=((ClassName="DH_Vehicles.DH_WolverineTank_Early")))
    Records(72)=(VehicleNames=("m10gmc","m10wolverine","wolverine"),Variants=((ClassName="DH_Vehicles.DH_WolverineTank"),(ClassName="DH_Vehicles.DH_WolverineTank_Snow",VariantName="snow")))
    Records(73)=(VehicleNames=("jacksonearly","m36early"),Variants=((ClassName="DH_Vehicles.DH_JacksonTank_Early")))
    Records(74)=(VehicleNames=("jackson","m36gmc","m36jackson"),Variants=((ClassName="DH_Vehicles.DH_JacksonTank"),(ClassName="DH_Vehicles.DH_JacksonTank_Snow",VariantName="snow")))
    //British
    Records(75)=(VehicleNames=("wolverinesp","britishwolverine","britishm10"),Variants=((ClassName="DH_Vehicles.DH_WolverineTank_British")))
    Records(76)=(VehicleNames=("achilles","17pdrwolverine"),Variants=((ClassName="DH_Vehicles.DH_AchillesTank")))
    //German
    Records(77)=(VehicleNames=("hetzer","jpz38t"),Variants=((ClassName="DH_Vehicles.DH_HetzerDestroyer"),(ClassName="DH_VehiclesDH_HetzerDestroyer_Snow.",VariantName="snow"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_SnowOne",VariantName="snowone"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_SnowTwo",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_CamoTwo",VariantName="camotwo"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_CamoThree",VariantName="camothree"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_Bushes",VariantName="bushes"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_Snow_Bushes",VariantName="snowbushes"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_SnowOne_Bushes",VariantName="snowonebushes"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_SnowTwo_Bushes",VariantName="snowtwobushes"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_CamoOne_Bushes",VariantName="camoonebushes"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_CamoTwo_Bushes",VariantName="camotwobushes"),(ClassName="DH_Vehicles.DH_HetzerDestroyer_CamoThree_Bushes",VariantName="camothreebushes")))
    Records(78)=(VehicleNames=("jagdpanzer448","jagdpanzer4/48","jpz4/48","jpz448"),Variants=((ClassName="DH_Vehicles.DH_JagdpanzerIVL48Destroyer"),(ClassName="DH_Vehicles.DH_JagdpanzerIVL48Destroyer_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_JagdpanzerIVL48Destroyer_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_JagdpanzerIVL48Destroyer_CamoTwo",VariantName="camotwo")))
    Records(79)=(VehicleNames=("jagdpanzer470","jagdpanzer4/70","jpz470","jpz4/70"),Variants=((ClassName="DH_Vehicles.DH_JagdpanzerIVL70Destroyer"),(ClassName="DH_Vehicles.DH_JagdpanzerIVL70Destroyer_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_JagdpanzerIVL70Destroyer_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_JagdpanzerIVL70Destroyer_CamoTwo",VariantName="camotwo")))
    Records(80)=(VehicleNames=("stuh42","stuh42g","stuh42ausf/g"),Variants=((ClassName="DH_Vehicles.DH_StuH42Destroyer"),(ClassName="DH_Vehicles.DH_StuH42Destroyer_Snow",VariantName="snow")))
    Records(81)=(VehicleNames=("stug3early","stug3gearly"),Variants=((ClassName="DH_Vehicles.DH_Stug3GDestroyer"),(ClassName="DH_Vehicles.DH_Stug3GDestroyer_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_Stug3GDestroyer_SnowOne",VariantName="snowone"),(ClassName="DH_Vehicles.DH_Stug3GDestroyer_CamoOne",VariantName="camoone")))
    Records(82)=(VehicleNames=("stug3","stug3g","stug3glate","stug3ausfg","stug3late","stug3ausf/g"),Variants=((ClassName="DH_Vehicles.DH_Stug3GDestroyer_Late"),(ClassName="DH_Vehicles.DH_Stug3GDestroyer_Late_Snow",VariantName="snow")))
    Records(83)=(VehicleNames=("marder3","marder3m","marder3ausfm","marder3ausf/m"),Variants=((ClassName="DH_Vehicles.DH_Marder3MDestroyer"),(ClassName="DH_Vehicles.DH_Marder3MDestroyer_SnowSolidWhite",VariantName="snowone"),(ClassName="DH_Vehicles.DH_Marder3MDestroyer_SnowPaintedCamo",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_Marder3MDestroyer_CamoOne",VariantName="camoone"),(ClassName="DH_Vehicles.DH_Marder3MDestroyer_CamoTwo",VariantName="camotwo")))
    Records(84)=(VehicleNames=("jagdpanther","jagdpanzer5"),Variants=((ClassName="DH_Vehicles.DH_JagdpantherTank"),(ClassName="DH_Vehicles.DH_JagdpantherTank_Snow",VariantName="snow"),(ClassName="DH_Vehicles.DH_JagdpantherTank_SnowTwo",VariantName="snowtwo"),(ClassName="DH_Vehicles.DH_JagdpantherTank_CamoTwo",VariantName="camotwo"),(ClassName="DH_Vehicles.DH_JagdpantherTank_ArdennesOne",VariantName="ardennes")))
    Records(85)=(VehicleNames=("jagdtiger"),Variants=((ClassName="DH_Vehicles.DH_JagdtigerTank"),(ClassName="DH_Vehicles.DH_JagdtigerTank_Snow",VariantName="snow")))

    //--+--

    //misc. (SPAA, Artillery, other)
    //soviet (none)

    //American
    Records(86)=(VehicleNames=("priest","m7priest"),Variants=((ClassName="DH_Vehicles.DH_M7Priest"),(ClassName="DH_Vehicles.DH_M7Priest_Snow",VariantName="snow")))
    //british (none)
    
    //German
    Records(87)=(VehicleNames=("wirbelwind","flakpanzer4"),Variants=((ClassName="DH_Vehicles.DH_WirbelwindTank"),(ClassName="DH_Vehicles.DH_WirbelwindTank_Snow",VariantName="snow")))
    

    //--+--

    //to be filed. TEMPLATE:Records()=(VehicleNames=(""),Variants=((ClassName="DH_Vehicles."),(ClassName="DH_Vehicles.",VariantName="")))
    //Soviet

    //American

    //British

    //German

    

}

