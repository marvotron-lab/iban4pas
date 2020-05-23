{*
 * Copyright 2013 Artur Mkrtchyan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
    Pascal port Copyright 2020 yonojoy@gmail.com
}
unit Iban4Pas.CountryCode;

{
    If a country is added, the following places need to be changed:
    * TCountryCodeHelper: add a new constant / definition
    * TCountryCodeEnum: add a new value
    * GetCountryCodeForEnum: add translation for enum value
}

interface

uses
    System.SysUtils,
    System.Classes,
    System.Generics.Collections;

type

    TCountryCodeEnumerator = class;
    TCountryCodeEnumeratorFactory = class;

    {**
     * Country Codes
     *
     * <a href="http://en.wikipedia.org/wiki/ISO_3166-1">ISO 3166-1</a> country code.
     *}
    TCountryCode = record
    private
        FAlpha2: string;
        FName: string;
        FAlpha3: string;
    private
        class var FCountryCodeEnumeratorFactory: TCountryCodeEnumeratorFactory;
        class var FAlpha2Map: TDictionary<string, TCountryCode>;
        class var FAlpha3Map: TDictionary<string, TCountryCode>;
        class procedure buildAlpha2Map; static;
        class procedure buildAlpha3Map; static;
        class function getByAlpha2Code(const code: string): TCountryCode; static;
        class function getByAlpha3Code(const code: string): TCountryCode; static;
        class destructor DestroyClass;
    public
        function toString: string;
        function getAlpha2: string;
        function getAlpha3: string;
        function getName: string;
        function isInvalid: Boolean;

        class operator Equal(a, b: TCountryCode): Boolean;
        class operator Implicit(val: TCountryCode): string;
        class function getByCode(const code: string): TCountryCode; static;
        class function values(): TCountryCodeEnumeratorFactory; static;
    end;

    //helper class is needed otherwise XE4 compiler is complaining
    TCountryCodeHelper = record helper for TCountryCode
    public
        const UNKNOWN: TCountryCode = (FAlpha2: ''; FName: ''; FAlpha3: '');
        const AD: TCountryCode = (FAlpha2: 'AD'; FName: 'Andorra'; FAlpha3: 'AND');
        const AE: TCountryCode = (FAlpha2: 'AE'; FName: 'United Arab Emirates'; FAlpha3: 'ARE');
        const AF: TCountryCode = (FAlpha2: 'AF'; FName: 'Afghanistan'; FAlpha3: 'AFG');
        const AG: TCountryCode = (FAlpha2: 'AG'; FName: 'Antigua and Barbuda'; FAlpha3: 'ATG');
        const AI: TCountryCode = (FAlpha2: 'AI'; FName: 'Anguilla'; FAlpha3: 'AIA');
        const AL: TCountryCode = (FAlpha2: 'AL'; FName: 'Albania'; FAlpha3: 'ALB');
        const AM: TCountryCode = (FAlpha2: 'AM'; FName: 'Armenia'; FAlpha3: 'ARM');
        const AO: TCountryCode = (FAlpha2: 'AO'; FName: 'Angola'; FAlpha3: 'AGO');
        const AQ: TCountryCode = (FAlpha2: 'AQ'; FName: 'Antarctica'; FAlpha3: 'ATA');
        const AR: TCountryCode = (FAlpha2: 'AR'; FName: 'Argentina'; FAlpha3: 'ARG');
        const AS_: TCountryCode = (FAlpha2: 'AS'; FName: 'American Samoa'; FAlpha3: 'ASM');
        const AT: TCountryCode = (FAlpha2: 'AT'; FName: 'Austria'; FAlpha3: 'AUT');
        const AU: TCountryCode = (FAlpha2: 'AU'; FName: 'Australia'; FAlpha3: 'AUS');
        const AW: TCountryCode = (FAlpha2: 'AW'; FName: 'Aruba'; FAlpha3: 'ABW');
        const AX: TCountryCode = (FAlpha2: 'AX'; FName: 'Åland Islands'; FAlpha3: 'ALA');
        const AZ: TCountryCode = (FAlpha2: 'AZ'; FName: 'Azerbaijan'; FAlpha3: 'AZE');
        const BA: TCountryCode = (FAlpha2: 'BA'; FName: 'Bosnia and Herzegovina'; FAlpha3: 'BIH');
        const BB: TCountryCode = (FAlpha2: 'BB'; FName: 'Barbados'; FAlpha3: 'BRB');
        const BD: TCountryCode = (FAlpha2: 'BD'; FName: 'Bangladesh'; FAlpha3: 'BGD');
        const BE: TCountryCode = (FAlpha2: 'BE'; FName: 'Belgium'; FAlpha3: 'BEL');
        const BF: TCountryCode = (FAlpha2: 'BF'; FName: 'Burkina Faso'; FAlpha3: 'BFA');
        const BG: TCountryCode = (FAlpha2: 'BG'; FName: 'Bulgaria'; FAlpha3: 'BGR');
        const BH: TCountryCode = (FAlpha2: 'BH'; FName: 'Bahrain'; FAlpha3: 'BHR');
        const BI: TCountryCode = (FAlpha2: 'BI'; FName: 'Burundi'; FAlpha3: 'BDI');
        const BJ: TCountryCode = (FAlpha2: 'BJ'; FName: 'Benin'; FAlpha3: 'BEN');
        const BL: TCountryCode = (FAlpha2: 'BL'; FName: 'Saint Barthélemy'; FAlpha3: 'BLM');
        const BM: TCountryCode = (FAlpha2: 'BM'; FName: 'Bermuda'; FAlpha3: 'BMU');
        const BN: TCountryCode = (FAlpha2: 'BN'; FName: 'Brunei Darussalam'; FAlpha3: 'BRN');
        const BO: TCountryCode = (FAlpha2: 'BO'; FName: 'Plurinational State of Bolivia'; FAlpha3: 'BOL');
        const BQ: TCountryCode = (FAlpha2: 'BQ'; FName: 'Bonaire, Sint Eustatius and Saba'; FAlpha3: 'BES');
        const BR: TCountryCode = (FAlpha2: 'BR'; FName: 'Brazil'; FAlpha3: 'BRA');
        const BS: TCountryCode = (FAlpha2: 'BS'; FName: 'Bahamas'; FAlpha3: 'BHS');
        const BT: TCountryCode = (FAlpha2: 'BT'; FName: 'Bhutan'; FAlpha3: 'BTN');
        const BV: TCountryCode = (FAlpha2: 'BV'; FName: 'Bouvet Island'; FAlpha3: 'BVT');
        const BW: TCountryCode = (FAlpha2: 'BW'; FName: 'Botswana'; FAlpha3: 'BWA');
        const BY: TCountryCode = (FAlpha2: 'BY'; FName: 'Belarus'; FAlpha3: 'BLR');
        const BZ: TCountryCode = (FAlpha2: 'BZ'; FName: 'Belize'; FAlpha3: 'BLZ');
        const CA: TCountryCode = (FAlpha2: 'CA'; FName: 'Canada'; FAlpha3: 'CAN');
        const CC: TCountryCode = (FAlpha2: 'CC'; FName: 'Cocos Islands'; FAlpha3: 'CCK');
        const CD: TCountryCode = (FAlpha2: 'CD'; FName: 'The Democratic Republic of the Congo'; FAlpha3: 'COD');
        const CF: TCountryCode = (FAlpha2: 'CF'; FName: 'Central African Republic'; FAlpha3: 'CAF');
        const CG: TCountryCode = (FAlpha2: 'CG'; FName: 'Congo'; FAlpha3: 'COG');
        const CH: TCountryCode = (FAlpha2: 'CH'; FName: 'Switzerland'; FAlpha3: 'CHE');
        const CI: TCountryCode = (FAlpha2: 'CI'; FName: 'Côte d''Ivoire'; FAlpha3: 'CIV');
        const CK: TCountryCode = (FAlpha2: 'CK'; FName: 'Cook Islands'; FAlpha3: 'COK');
        const CL: TCountryCode = (FAlpha2: 'CL'; FName: 'Chile'; FAlpha3: 'CHL');
        const CM: TCountryCode = (FAlpha2: 'CM'; FName: 'Cameroon'; FAlpha3: 'CMR');
        const CN: TCountryCode = (FAlpha2: 'CN'; FName: 'China'; FAlpha3: 'CHN');
        const CO: TCountryCode = (FAlpha2: 'CO'; FName: 'Colombia'; FAlpha3: 'COL');
        const CR: TCountryCode = (FAlpha2: 'CR'; FName: 'Costa Rica'; FAlpha3: 'CRI');
        const CU: TCountryCode = (FAlpha2: 'CU'; FName: 'Cuba'; FAlpha3: 'CUB');
        const CV: TCountryCode = (FAlpha2: 'CV'; FName: 'Cape Verde'; FAlpha3: 'CPV');
        const CW: TCountryCode = (FAlpha2: 'CW'; FName: 'Curaçao'; FAlpha3: 'CUW');
        const CX: TCountryCode = (FAlpha2: 'CX'; FName: 'Christmas Island'; FAlpha3: 'CXR');
        const CY: TCountryCode = (FAlpha2: 'CY'; FName: 'Cyprus'; FAlpha3: 'CYP');
        const CZ: TCountryCode = (FAlpha2: 'CZ'; FName: 'Czech Republic'; FAlpha3: 'CZE');
        const DE: TCountryCode = (FAlpha2: 'DE'; FName: 'Germany'; FAlpha3: 'DEU');
        const DJ: TCountryCode = (FAlpha2: 'DJ'; FName: 'Djibouti'; FAlpha3: 'DJI');
        const DK: TCountryCode = (FAlpha2: 'DK'; FName: 'Denmark'; FAlpha3: 'DNK');
        const DM: TCountryCode = (FAlpha2: 'DM'; FName: 'Dominica'; FAlpha3: 'DMA');
        const DO_: TCountryCode = (FAlpha2: 'DO'; FName: 'Dominican Republic'; FAlpha3: 'DOM');
        const DZ: TCountryCode = (FAlpha2: 'DZ'; FName: 'Algeria'; FAlpha3: 'DZA');
        const EC: TCountryCode = (FAlpha2: 'EC'; FName: 'Ecuador'; FAlpha3: 'ECU');
        const EE: TCountryCode = (FAlpha2: 'EE'; FName: 'Estonia'; FAlpha3: 'EST');
        const EG: TCountryCode = (FAlpha2: 'EG'; FName: 'Egypt'; FAlpha3: 'EGY');
        const EH: TCountryCode = (FAlpha2: 'EH'; FName: 'Western Sahara'; FAlpha3: 'ESH');
        const ER: TCountryCode = (FAlpha2: 'ER'; FName: 'Eritrea'; FAlpha3: 'ERI');
        const ES: TCountryCode = (FAlpha2: 'ES'; FName: 'Spain'; FAlpha3: 'ESP');
        const ET: TCountryCode = (FAlpha2: 'ET'; FName: 'Ethiopia'; FAlpha3: 'ETH');
        const FI: TCountryCode = (FAlpha2: 'FI'; FName: 'Finland'; FAlpha3: 'FIN');
        const FJ: TCountryCode = (FAlpha2: 'FJ'; FName: 'Fiji'; FAlpha3: 'FJI');
        const FK: TCountryCode = (FAlpha2: 'FK'; FName: 'Falkland Islands'; FAlpha3: 'FLK');
        const FM: TCountryCode = (FAlpha2: 'FM'; FName: 'Federated States of Micronesia'; FAlpha3: 'FSM');
        const FO: TCountryCode = (FAlpha2: 'FO'; FName: 'Faroe Islands'; FAlpha3: 'FRO');
        const FR: TCountryCode = (FAlpha2: 'FR'; FName: 'France'; FAlpha3: 'FRA');
        const GA: TCountryCode = (FAlpha2: 'GA'; FName: 'Gabon'; FAlpha3: 'GAB');
        const GB: TCountryCode = (FAlpha2: 'GB'; FName: 'United Kingdom'; FAlpha3: 'GBR');
        const GD: TCountryCode = (FAlpha2: 'GD'; FName: 'Grenada'; FAlpha3: 'GRD');
        const GE: TCountryCode = (FAlpha2: 'GE'; FName: 'Georgia'; FAlpha3: 'GEO');
        const GF: TCountryCode = (FAlpha2: 'GF'; FName: 'French Guiana'; FAlpha3: 'GUF');
        const GG: TCountryCode = (FAlpha2: 'GG'; FName: 'Guemsey'; FAlpha3: 'GGY');
        const GH: TCountryCode = (FAlpha2: 'GH'; FName: 'Ghana'; FAlpha3: 'GHA');
        const GI: TCountryCode = (FAlpha2: 'GI'; FName: 'Gibraltar'; FAlpha3: 'GIB');
        const GL: TCountryCode = (FAlpha2: 'GL'; FName: 'Greenland'; FAlpha3: 'GRL');
        const GM: TCountryCode = (FAlpha2: 'GM'; FName: 'Gambia'; FAlpha3: 'GMB');
        const GN: TCountryCode = (FAlpha2: 'GN'; FName: 'Guinea'; FAlpha3: 'GIN');
        const GP: TCountryCode = (FAlpha2: 'GP'; FName: 'Guadeloupe'; FAlpha3: 'GLP');
        const GQ: TCountryCode = (FAlpha2: 'GQ'; FName: 'Equatorial Guinea'; FAlpha3: 'GNQ');
        const GR: TCountryCode = (FAlpha2: 'GR'; FName: 'Greece'; FAlpha3: 'GRC');
        const GS: TCountryCode = (FAlpha2: 'GS'; FName: 'South Georgia and the South Sandwich Islands'; FAlpha3: 'SGS');
        const GT: TCountryCode = (FAlpha2: 'GT'; FName: 'Guatemala'; FAlpha3: 'GTM');
        const GU: TCountryCode = (FAlpha2: 'GU'; FName: 'Guam'; FAlpha3: 'GUM');
        const GW: TCountryCode = (FAlpha2: 'GW'; FName: 'Guinea-Bissau'; FAlpha3: 'GNB');
        const GY: TCountryCode = (FAlpha2: 'GY'; FName: 'Guyana'; FAlpha3: 'GUY');
        const HK: TCountryCode = (FAlpha2: 'HK'; FName: 'Hong Kong'; FAlpha3: 'HKG');
        const HM: TCountryCode = (FAlpha2: 'HM'; FName: 'Heard Island and McDonald Islands'; FAlpha3: 'HMD');
        const HN: TCountryCode = (FAlpha2: 'HN'; FName: 'Honduras'; FAlpha3: 'HND');
        const HR: TCountryCode = (FAlpha2: 'HR'; FName: 'Croatia'; FAlpha3: 'HRV');
        const HT: TCountryCode = (FAlpha2: 'HT'; FName: 'Haiti'; FAlpha3: 'HTI');
        const HU: TCountryCode = (FAlpha2: 'HU'; FName: 'Hungary'; FAlpha3: 'HUN');
        const ID: TCountryCode = (FAlpha2: 'ID'; FName: 'Indonesia'; FAlpha3: 'IDN');
        const IE: TCountryCode = (FAlpha2: 'IE'; FName: 'Ireland'; FAlpha3: 'IRL');
        const IL: TCountryCode = (FAlpha2: 'IL'; FName: 'Israel'; FAlpha3: 'ISR');
        const IM: TCountryCode = (FAlpha2: 'IM'; FName: 'Isle of Man'; FAlpha3: 'IMN');
        const IN_: TCountryCode = (FAlpha2: 'IN'; FName: 'India'; FAlpha3: 'IND');
        const IO: TCountryCode = (FAlpha2: 'IO'; FName: 'British Indian Ocean Territory'; FAlpha3: 'IOT');
        const IQ: TCountryCode = (FAlpha2: 'IQ'; FName: 'Iraq'; FAlpha3: 'IRQ');
        const IR: TCountryCode = (FAlpha2: 'IR'; FName: 'Islamic Republic of Iran'; FAlpha3: 'IRN');
        const IS_: TCountryCode = (FAlpha2: 'IS'; FName: 'Iceland'; FAlpha3: 'ISL');
        const IT: TCountryCode = (FAlpha2: 'IT'; FName: 'Italy'; FAlpha3: 'ITA');
        const JE: TCountryCode = (FAlpha2: 'JE'; FName: 'Jersey'; FAlpha3: 'JEY');
        const JM: TCountryCode = (FAlpha2: 'JM'; FName: 'Jamaica'; FAlpha3: 'JAM');
        const JO: TCountryCode = (FAlpha2: 'JO'; FName: 'Jordan'; FAlpha3: 'JOR');
        const JP: TCountryCode = (FAlpha2: 'JP'; FName: 'Japan'; FAlpha3: 'JPN');
        const KE: TCountryCode = (FAlpha2: 'KE'; FName: 'Kenya'; FAlpha3: 'KEN');
        const KG: TCountryCode = (FAlpha2: 'KG'; FName: 'Kyrgyzstan'; FAlpha3: 'KGZ');
        const KH: TCountryCode = (FAlpha2: 'KH'; FName: 'Cambodia'; FAlpha3: 'KHM');
        const KI: TCountryCode = (FAlpha2: 'KI'; FName: 'Kiribati'; FAlpha3: 'KIR');
        const KM: TCountryCode = (FAlpha2: 'KM'; FName: 'Comoros'; FAlpha3: 'COM');
        const KN: TCountryCode = (FAlpha2: 'KN'; FName: 'Saint Kitts and Nevis'; FAlpha3: 'KNA');
        const KP: TCountryCode = (FAlpha2: 'KP'; FName: 'Democratic People''s Republic of Korea'; FAlpha3: 'PRK');
        const KR: TCountryCode = (FAlpha2: 'KR'; FName: 'Republic of Korea'; FAlpha3: 'KOR');
        const KW: TCountryCode = (FAlpha2: 'KW'; FName: 'Kuwait'; FAlpha3: 'KWT');
        const KY: TCountryCode = (FAlpha2: 'KY'; FName: 'Cayman Islands'; FAlpha3: 'CYM');
        const KZ: TCountryCode = (FAlpha2: 'KZ'; FName: 'Kazakhstan'; FAlpha3: 'KAZ');
        const LA: TCountryCode = (FAlpha2: 'LA'; FName: 'Lao People''s Democratic Republic'; FAlpha3: 'LAO');
        const LB: TCountryCode = (FAlpha2: 'LB'; FName: 'Lebanon'; FAlpha3: 'LBN');
        const LC: TCountryCode = (FAlpha2: 'LC'; FName: 'Saint Lucia'; FAlpha3: 'LCA');
        const LI: TCountryCode = (FAlpha2: 'LI'; FName: 'Liechtenstein'; FAlpha3: 'LIE');
        const LK: TCountryCode = (FAlpha2: 'LK'; FName: 'Sri Lanka'; FAlpha3: 'LKA');
        const LR: TCountryCode = (FAlpha2: 'LR'; FName: 'Liberia'; FAlpha3: 'LBR');
        const LS: TCountryCode = (FAlpha2: 'LS'; FName: 'Lesotho'; FAlpha3: 'LSO');
        const LT: TCountryCode = (FAlpha2: 'LT'; FName: 'Lithuania'; FAlpha3: 'LTU');
        const LU: TCountryCode = (FAlpha2: 'LU'; FName: 'Luxembourg'; FAlpha3: 'LUX');
        const LV: TCountryCode = (FAlpha2: 'LV'; FName: 'Latvia'; FAlpha3: 'LVA');
        const LY: TCountryCode = (FAlpha2: 'LY'; FName: 'Libya'; FAlpha3: 'LBY');
        const MA: TCountryCode = (FAlpha2: 'MA'; FName: 'Morocco'; FAlpha3: 'MAR');
        const MC: TCountryCode = (FAlpha2: 'MC'; FName: 'Monaco'; FAlpha3: 'MCO');
        const MD: TCountryCode = (FAlpha2: 'MD'; FName: 'Republic of Moldova'; FAlpha3: 'MDA');
        const ME: TCountryCode = (FAlpha2: 'ME'; FName: 'Montenegro'; FAlpha3: 'MNE');
        const MF: TCountryCode = (FAlpha2: 'MF'; FName: 'Saint Martin'; FAlpha3: 'MAF');
        const MG: TCountryCode = (FAlpha2: 'MG'; FName: 'Madagascar'; FAlpha3: 'MDG');
        const MH: TCountryCode = (FAlpha2: 'MH'; FName: 'Marshall Islands'; FAlpha3: 'MHL');
        const MK: TCountryCode = (FAlpha2: 'MK'; FName: 'The former Yugoslav Republic of Macedonia'; FAlpha3: 'MKD');
        const ML: TCountryCode = (FAlpha2: 'ML'; FName: 'Mali'; FAlpha3: 'MLI');
        const MM: TCountryCode = (FAlpha2: 'MM'; FName: 'Myanmar'; FAlpha3: 'MMR');
        const MN: TCountryCode = (FAlpha2: 'MN'; FName: 'Mongolia'; FAlpha3: 'MNG');
        const MO: TCountryCode = (FAlpha2: 'MO'; FName: 'Macao'; FAlpha3: 'MAC');
        const MP: TCountryCode = (FAlpha2: 'MP'; FName: 'Northern Mariana Islands'; FAlpha3: 'MNP');
        const MQ: TCountryCode = (FAlpha2: 'MQ'; FName: 'Martinique'; FAlpha3: 'MTQ');
        const MR: TCountryCode = (FAlpha2: 'MR'; FName: 'Mauritania'; FAlpha3: 'MRT');
        const MS: TCountryCode = (FAlpha2: 'MS'; FName: 'Montserrat'; FAlpha3: 'MSR');
        const MT: TCountryCode = (FAlpha2: 'MT'; FName: 'Malta'; FAlpha3: 'MLT');
        const MU: TCountryCode = (FAlpha2: 'MU'; FName: 'Mauritius'; FAlpha3: 'MUS');
        const MV: TCountryCode = (FAlpha2: 'MV'; FName: 'Maldives'; FAlpha3: 'MDV');
        const MW: TCountryCode = (FAlpha2: 'MW'; FName: 'Malawi'; FAlpha3: 'MWI');
        const MX: TCountryCode = (FAlpha2: 'MX'; FName: 'Mexico'; FAlpha3: 'MEX');
        const MY: TCountryCode = (FAlpha2: 'MY'; FName: 'Malaysia'; FAlpha3: 'MYS');
        const MZ: TCountryCode = (FAlpha2: 'MZ'; FName: 'Mozambique'; FAlpha3: 'MOZ');
        const NA: TCountryCode = (FAlpha2: 'NA'; FName: 'Namibia'; FAlpha3: 'NAM');
        const NC: TCountryCode = (FAlpha2: 'NC'; FName: 'New Caledonia'; FAlpha3: 'NCL');
        const NE: TCountryCode = (FAlpha2: 'NE'; FName: 'Niger'; FAlpha3: 'NER');
        const NF: TCountryCode = (FAlpha2: 'NF'; FName: 'Norfolk Island'; FAlpha3: 'NFK');
        const NG: TCountryCode = (FAlpha2: 'NG'; FName: 'Nigeria'; FAlpha3: 'NGA');
        const NI: TCountryCode = (FAlpha2: 'NI'; FName: 'Nicaragua'; FAlpha3: 'NIC');
        const NL: TCountryCode = (FAlpha2: 'NL'; FName: 'Netherlands'; FAlpha3: 'NLD');
        const NO: TCountryCode = (FAlpha2: 'NO'; FName: 'Norway'; FAlpha3: 'NOR');
        const NP: TCountryCode = (FAlpha2: 'NP'; FName: 'Nepal'; FAlpha3: 'NPL');
        const NR: TCountryCode = (FAlpha2: 'NR'; FName: 'Nauru'; FAlpha3: 'NRU');
        const NU: TCountryCode = (FAlpha2: 'NU'; FName: 'Niue'; FAlpha3: 'NIU');
        const NZ: TCountryCode = (FAlpha2: 'NZ'; FName: 'New Zealand'; FAlpha3: 'NZL');
        const OM: TCountryCode = (FAlpha2: 'OM'; FName: 'Oman'; FAlpha3: 'OMN');
        const PA: TCountryCode = (FAlpha2: 'PA'; FName: 'Panama'; FAlpha3: 'PAN');
        const PE: TCountryCode = (FAlpha2: 'PE'; FName: 'Peru'; FAlpha3: 'PER');
        const PF: TCountryCode = (FAlpha2: 'PF'; FName: 'French Polynesia'; FAlpha3: 'PYF');
        const PG: TCountryCode = (FAlpha2: 'PG'; FName: 'Papua New Guinea'; FAlpha3: 'PNG');
        const PH: TCountryCode = (FAlpha2: 'PH'; FName: 'Philippines'; FAlpha3: 'PHL');
        const PK: TCountryCode = (FAlpha2: 'PK'; FName: 'Pakistan'; FAlpha3: 'PAK');
        const PL: TCountryCode = (FAlpha2: 'PL'; FName: 'Poland'; FAlpha3: 'POL');
        const PM: TCountryCode = (FAlpha2: 'PM'; FName: 'Saint Pierre and Miquelon'; FAlpha3: 'SPM');
        const PN: TCountryCode = (FAlpha2: 'PN'; FName: 'Pitcairn'; FAlpha3: 'PCN');
        const PR: TCountryCode = (FAlpha2: 'PR'; FName: 'Puerto Rico'; FAlpha3: 'PRI');
        const PS: TCountryCode = (FAlpha2: 'PS'; FName: 'Occupied Palestinian Territory'; FAlpha3: 'PSE');
        const PT: TCountryCode = (FAlpha2: 'PT'; FName: 'Portugal'; FAlpha3: 'PRT');
        const PW: TCountryCode = (FAlpha2: 'PW'; FName: 'Palau'; FAlpha3: 'PLW');
        const PY: TCountryCode = (FAlpha2: 'PY'; FName: 'Paraguay'; FAlpha3: 'PRY');
        const QA: TCountryCode = (FAlpha2: 'QA'; FName: 'Qatar'; FAlpha3: 'QAT');
        const RE: TCountryCode = (FAlpha2: 'RE'; FName: 'Réunion'; FAlpha3: 'REU');
        const RO: TCountryCode = (FAlpha2: 'RO'; FName: 'Romania'; FAlpha3: 'ROU');
        const RS: TCountryCode = (FAlpha2: 'RS'; FName: 'Serbia'; FAlpha3: 'SRB');
        const RU: TCountryCode = (FAlpha2: 'RU'; FName: 'Russian Federation'; FAlpha3: 'RUS');
        const RW: TCountryCode = (FAlpha2: 'RW'; FName: 'Rwanda'; FAlpha3: 'RWA');
        const SA: TCountryCode = (FAlpha2: 'SA'; FName: 'Saudi Arabia'; FAlpha3: 'SAU');
        const SB: TCountryCode = (FAlpha2: 'SB'; FName: 'Solomon Islands'; FAlpha3: 'SLB');
        const SC: TCountryCode = (FAlpha2: 'SC'; FName: 'Seychelles'; FAlpha3: 'SYC');
        const SD: TCountryCode = (FAlpha2: 'SD'; FName: 'Sudan'; FAlpha3: 'SDN');
        const SE: TCountryCode = (FAlpha2: 'SE'; FName: 'Sweden'; FAlpha3: 'SWE');
        const SG: TCountryCode = (FAlpha2: 'SG'; FName: 'Singapore'; FAlpha3: 'SGP');
        const SH: TCountryCode = (FAlpha2: 'SH'; FName: 'Saint Helena, Ascension and Tristan da Cunha'; FAlpha3: 'SHN');
        const SI: TCountryCode = (FAlpha2: 'SI'; FName: 'Slovenia'; FAlpha3: 'SVN');
        const SJ: TCountryCode = (FAlpha2: 'SJ'; FName: 'Svalbard and Jan Mayen'; FAlpha3: 'SJM');
        const SK: TCountryCode = (FAlpha2: 'SK'; FName: 'Slovakia'; FAlpha3: 'SVK');
        const SL: TCountryCode = (FAlpha2: 'SL'; FName: 'Sierra Leone'; FAlpha3: 'SLE');
        const SM: TCountryCode = (FAlpha2: 'SM'; FName: 'San Marino'; FAlpha3: 'SMR');
        const SN: TCountryCode = (FAlpha2: 'SN'; FName: 'Senegal'; FAlpha3: 'SEN');
        const SO: TCountryCode = (FAlpha2: 'SO'; FName: 'Somalia'; FAlpha3: 'SOM');
        const SR: TCountryCode = (FAlpha2: 'SR'; FName: 'Suriname'; FAlpha3: 'SUR');
        const SS: TCountryCode = (FAlpha2: 'SS'; FName: 'South Sudan'; FAlpha3: 'SSD');
        const ST: TCountryCode = (FAlpha2: 'ST'; FName: 'Sao Tome and Principe'; FAlpha3: 'STP');
        const SV: TCountryCode = (FAlpha2: 'SV'; FName: 'El Salvador'; FAlpha3: 'SLV');
        const SX: TCountryCode = (FAlpha2: 'SX'; FName: 'Sint Maarten'; FAlpha3: 'SXM');
        const SY: TCountryCode = (FAlpha2: 'SY'; FName: 'Syrian Arab Republic'; FAlpha3: 'SYR');
        const SZ: TCountryCode = (FAlpha2: 'SZ'; FName: 'Swaziland'; FAlpha3: 'SWZ');
        const TC: TCountryCode = (FAlpha2: 'TC'; FName: 'Turks and Caicos Islands'; FAlpha3: 'TCA');
        const TD: TCountryCode = (FAlpha2: 'TD'; FName: 'Chad'; FAlpha3: 'TCD');
        const TF: TCountryCode = (FAlpha2: 'TF'; FName: 'French Southern Territories'; FAlpha3: 'ATF');
        const TG: TCountryCode = (FAlpha2: 'TG'; FName: 'Togo'; FAlpha3: 'TGO');
        const TH: TCountryCode = (FAlpha2: 'TH'; FName: 'Thailand'; FAlpha3: 'THA');
        const TJ: TCountryCode = (FAlpha2: 'TJ'; FName: 'Tajikistan'; FAlpha3: 'TJK');
        const TK: TCountryCode = (FAlpha2: 'TK'; FName: 'Tokelau'; FAlpha3: 'TKL');
        const TL: TCountryCode = (FAlpha2: 'TL'; FName: 'Timor-Leste'; FAlpha3: 'TLS');
        const TM: TCountryCode = (FAlpha2: 'TM'; FName: 'Turkmenistan'; FAlpha3: 'TKM');
        const TN: TCountryCode = (FAlpha2: 'TN'; FName: 'Tunisia'; FAlpha3: 'TUN');
        const TO_: TCountryCode = (FAlpha2: 'TO'; FName: 'Tonga'; FAlpha3: 'TON');
        const TR: TCountryCode = (FAlpha2: 'TR'; FName: 'Turkey'; FAlpha3: 'TUR');
        const TT: TCountryCode = (FAlpha2: 'TT'; FName: 'Trinidad and Tobago'; FAlpha3: 'TTO');
        const TV: TCountryCode = (FAlpha2: 'TV'; FName: 'Tuvalu'; FAlpha3: 'TUV');
        const TW: TCountryCode = (FAlpha2: 'TW'; FName: 'Taiwan, Province of China'; FAlpha3: 'TWN');
        const TZ: TCountryCode = (FAlpha2: 'TZ'; FName: 'United Republic of Tanzania'; FAlpha3: 'TZA');
        const UA: TCountryCode = (FAlpha2: 'UA'; FName: 'Ukraine'; FAlpha3: 'UKR');
        const UG: TCountryCode = (FAlpha2: 'UG'; FName: 'Uganda'; FAlpha3: 'UGA');
        const UM: TCountryCode = (FAlpha2: 'UM'; FName: 'United States Minor Outlying Islands'; FAlpha3: 'UMI');
        const US: TCountryCode = (FAlpha2: 'US'; FName: 'United States'; FAlpha3: 'USA');
        const UY: TCountryCode = (FAlpha2: 'UY'; FName: 'Uruguay'; FAlpha3: 'URY');
        const UZ: TCountryCode = (FAlpha2: 'UZ'; FName: 'Uzbekistan'; FAlpha3: 'UZB');
        const VA: TCountryCode = (FAlpha2: 'VA'; FName: 'Holy See'; FAlpha3: 'VAT');
        const VC: TCountryCode = (FAlpha2: 'VC'; FName: 'Saint Vincent and the Grenadines'; FAlpha3: 'VCT');
        const VE: TCountryCode = (FAlpha2: 'VE'; FName: 'Bolivarian Republic of Venezuela'; FAlpha3: 'VEN');
        const VG: TCountryCode = (FAlpha2: 'VG'; FName: 'British Virgin Islands'; FAlpha3: 'VGB');
        const VI: TCountryCode = (FAlpha2: 'VI'; FName: 'Virgin Islands, U.S.'; FAlpha3: 'VIR');
        const VN: TCountryCode = (FAlpha2: 'VN'; FName: 'Viet Nam'; FAlpha3: 'VNM');
        const VU: TCountryCode = (FAlpha2: 'VU'; FName: 'Vanuatu'; FAlpha3: 'VUT');
        const WF: TCountryCode = (FAlpha2: 'WF'; FName: 'Wallis and Futuna'; FAlpha3: 'WLF');
        const WS: TCountryCode = (FAlpha2: 'WS'; FName: 'Samoa'; FAlpha3: 'WSM');
        const XK: TCountryCode = (FAlpha2: 'XK'; FName: 'Kosovo'; FAlpha3: 'UNK');
        const YE: TCountryCode = (FAlpha2: 'YE'; FName: 'Yemen'; FAlpha3: 'YEM');
        const YT: TCountryCode = (FAlpha2: 'YT'; FName: 'Mayotte'; FAlpha3: 'MYT');
        const ZA: TCountryCode = (FAlpha2: 'ZA'; FName: 'South Africa'; FAlpha3: 'ZAF');
        const ZM: TCountryCode = (FAlpha2: 'ZM'; FName: 'Zambia'; FAlpha3: 'ZMB');
        const ZW: TCountryCode = (FAlpha2: 'ZW'; FName: 'Zimbabwe'; FAlpha3: 'ZWE');
    end;

    TCountryCodeEnumerator = class
    private
        FIndex: Integer;
    protected
        function GetCurrent: TCountryCode;
    public
        function MoveNext: Boolean;
        property Current: TCountryCode read GetCurrent;
    end;

    TCountryCodeEnumeratorFactory = class
        function GetEnumerator: TCountryCodeEnumerator;
    end;


implementation

type
    //this exists to allow to iterate automatically over all items
    TCountryCodeEnum = (
        AD,
        AE,
        AF,
        AG,
        AI,
        AL,
        AM,
        AO,
        AQ,
        AR,
        AS_,
        AT,
        AU,
        AW,
        AX,
        AZ,
        BA,
        BB,
        BD,
        BE,
        BF,
        BG,
        BH,
        BI,
        BJ,
        BL,
        BM,
        BN,
        BO,
        BQ,
        BR,
        BS,
        BT,
        BV,
        BW,
        BY,
        BZ,
        CA,
        CC,
        CD,
        CF,
        CG,
        CH,
        CI,
        CK,
        CL,
        CM,
        CN,
        CO,
        CR,
        CU,
        CV,
        CW,
        CX,
        CY,
        CZ,
        DE,
        DJ,
        DK,
        DM,
        DO_,
        DZ,
        EC,
        EE,
        EG,
        EH,
        ER,
        ES,
        ET,
        FI,
        FJ,
        FK,
        FM,
        FO,
        FR,
        GA,
        GB,
        GD,
        GE,
        GF,
        GG,
        GH,
        GI,
        GL,
        GM,
        GN,
        GP,
        GQ,
        GR,
        GS,
        GT,
        GU,
        GW,
        GY,
        HK,
        HM,
        HN,
        HR,
        HT,
        HU,
        ID,
        IE,
        IL,
        IM,
        IN_,
        IO,
        IQ,
        IR,
        IS_,
        IT,
        JE,
        JM,
        JO,
        JP,
        KE,
        KG,
        KH,
        KI,
        KM,
        KN,
        KP,
        KR,
        KW,
        KY,
        KZ,
        LA,
        LB,
        LC,
        LI,
        LK,
        LR,
        LS,
        LT,
        LU,
        LV,
        LY,
        MA,
        MC,
        MD,
        ME,
        MF,
        MG,
        MH,
        MK,
        ML,
        MM,
        MN,
        MO,
        MP,
        MQ,
        MR,
        MS,
        MT,
        MU,
        MV,
        MW,
        MX,
        MY,
        MZ,
        NA,
        NC,
        NE,
        NF,
        NG,
        NI,
        NL,
        NO,
        NP,
        NR,
        NU,
        NZ,
        OM,
        PA,
        PE,
        PF,
        PG,
        PH,
        PK,
        PL,
        PM,
        PN,
        PR,
        PS,
        PT,
        PW,
        PY,
        QA,
        RE,
        RO,
        RS,
        RU,
        RW,
        SA,
        SB,
        SC,
        SD,
        SE,
        SG,
        SH,
        SI,
        SJ,
        SK,
        SL,
        SM,
        SN,
        SO,
        SR,
        SS,
        ST,
        SV,
        SX,
        SY,
        SZ,
        TC,
        TD,
        TF,
        TG,
        TH,
        TJ,
        TK,
        TL,
        TM,
        TN,
        TO_,
        TR,
        TT,
        TV,
        TW,
        TZ,
        UA,
        UG,
        UM,
        US,
        UY,
        UZ,
        VA,
        VC,
        VE,
        VG,
        VI,
        VN,
        VU,
        WF,
        WS,
        XK,
        YE,
        YT,
        ZA,
        ZM,
        ZW
    );

const
    APPROXIMATE_NUMBER_OF_ENTRIES = 260;    //for initialization of map / 250 atm

function GetCountryCodeForEnum(const cc: TCountryCodeEnum): TCountryCode;
begin
    case cc of
        TCountryCodeEnum.AD: Result := TCountryCode.AD;
        TCountryCodeEnum.AE: Result := TCountryCode.AE;
        TCountryCodeEnum.AF: Result := TCountryCode.AF;
        TCountryCodeEnum.AG: Result := TCountryCode.AG;
        TCountryCodeEnum.AI: Result := TCountryCode.AI;
        TCountryCodeEnum.AL: Result := TCountryCode.AL;
        TCountryCodeEnum.AM: Result := TCountryCode.AM;
        TCountryCodeEnum.AO: Result := TCountryCode.AO;
        TCountryCodeEnum.AQ: Result := TCountryCode.AQ;
        TCountryCodeEnum.AR: Result := TCountryCode.AR;
        TCountryCodeEnum.AS_: Result := TCountryCode.AS_;
        TCountryCodeEnum.AT: Result := TCountryCode.AT;
        TCountryCodeEnum.AU: Result := TCountryCode.AU;
        TCountryCodeEnum.AW: Result := TCountryCode.AW;
        TCountryCodeEnum.AX: Result := TCountryCode.AX;
        TCountryCodeEnum.AZ: Result := TCountryCode.AZ;
        TCountryCodeEnum.BA: Result := TCountryCode.BA;
        TCountryCodeEnum.BB: Result := TCountryCode.BB;
        TCountryCodeEnum.BD: Result := TCountryCode.BD;
        TCountryCodeEnum.BE: Result := TCountryCode.BE;
        TCountryCodeEnum.BF: Result := TCountryCode.BF;
        TCountryCodeEnum.BG: Result := TCountryCode.BG;
        TCountryCodeEnum.BH: Result := TCountryCode.BH;
        TCountryCodeEnum.BI: Result := TCountryCode.BI;
        TCountryCodeEnum.BJ: Result := TCountryCode.BJ;
        TCountryCodeEnum.BL: Result := TCountryCode.BL;
        TCountryCodeEnum.BM: Result := TCountryCode.BM;
        TCountryCodeEnum.BN: Result := TCountryCode.BN;
        TCountryCodeEnum.BO: Result := TCountryCode.BO;
        TCountryCodeEnum.BQ: Result := TCountryCode.BQ;
        TCountryCodeEnum.BR: Result := TCountryCode.BR;
        TCountryCodeEnum.BS: Result := TCountryCode.BS;
        TCountryCodeEnum.BT: Result := TCountryCode.BT;
        TCountryCodeEnum.BV: Result := TCountryCode.BV;
        TCountryCodeEnum.BW: Result := TCountryCode.BW;
        TCountryCodeEnum.BY: Result := TCountryCode.BY;
        TCountryCodeEnum.BZ: Result := TCountryCode.BZ;
        TCountryCodeEnum.CA: Result := TCountryCode.CA;
        TCountryCodeEnum.CC: Result := TCountryCode.CC;
        TCountryCodeEnum.CD: Result := TCountryCode.CD;
        TCountryCodeEnum.CF: Result := TCountryCode.CF;
        TCountryCodeEnum.CG: Result := TCountryCode.CG;
        TCountryCodeEnum.CH: Result := TCountryCode.CH;
        TCountryCodeEnum.CI: Result := TCountryCode.CI;
        TCountryCodeEnum.CK: Result := TCountryCode.CK;
        TCountryCodeEnum.CL: Result := TCountryCode.CL;
        TCountryCodeEnum.CM: Result := TCountryCode.CM;
        TCountryCodeEnum.CN: Result := TCountryCode.CN;
        TCountryCodeEnum.CO: Result := TCountryCode.CO;
        TCountryCodeEnum.CR: Result := TCountryCode.CR;
        TCountryCodeEnum.CU: Result := TCountryCode.CU;
        TCountryCodeEnum.CV: Result := TCountryCode.CV;
        TCountryCodeEnum.CW: Result := TCountryCode.CW;
        TCountryCodeEnum.CX: Result := TCountryCode.CX;
        TCountryCodeEnum.CY: Result := TCountryCode.CY;
        TCountryCodeEnum.CZ: Result := TCountryCode.CZ;
        TCountryCodeEnum.DE: Result := TCountryCode.DE;
        TCountryCodeEnum.DJ: Result := TCountryCode.DJ;
        TCountryCodeEnum.DK: Result := TCountryCode.DK;
        TCountryCodeEnum.DM: Result := TCountryCode.DM;
        TCountryCodeEnum.DO_: Result := TCountryCode.DO_;
        TCountryCodeEnum.DZ: Result := TCountryCode.DZ;
        TCountryCodeEnum.EC: Result := TCountryCode.EC;
        TCountryCodeEnum.EE: Result := TCountryCode.EE;
        TCountryCodeEnum.EG: Result := TCountryCode.EG;
        TCountryCodeEnum.EH: Result := TCountryCode.EH;
        TCountryCodeEnum.ER: Result := TCountryCode.ER;
        TCountryCodeEnum.ES: Result := TCountryCode.ES;
        TCountryCodeEnum.ET: Result := TCountryCode.ET;
        TCountryCodeEnum.FI: Result := TCountryCode.FI;
        TCountryCodeEnum.FJ: Result := TCountryCode.FJ;
        TCountryCodeEnum.FK: Result := TCountryCode.FK;
        TCountryCodeEnum.FM: Result := TCountryCode.FM;
        TCountryCodeEnum.FO: Result := TCountryCode.FO;
        TCountryCodeEnum.FR: Result := TCountryCode.FR;
        TCountryCodeEnum.GA: Result := TCountryCode.GA;
        TCountryCodeEnum.GB: Result := TCountryCode.GB;
        TCountryCodeEnum.GD: Result := TCountryCode.GD;
        TCountryCodeEnum.GE: Result := TCountryCode.GE;
        TCountryCodeEnum.GF: Result := TCountryCode.GF;
        TCountryCodeEnum.GG: Result := TCountryCode.GG;
        TCountryCodeEnum.GH: Result := TCountryCode.GH;
        TCountryCodeEnum.GI: Result := TCountryCode.GI;
        TCountryCodeEnum.GL: Result := TCountryCode.GL;
        TCountryCodeEnum.GM: Result := TCountryCode.GM;
        TCountryCodeEnum.GN: Result := TCountryCode.GN;
        TCountryCodeEnum.GP: Result := TCountryCode.GP;
        TCountryCodeEnum.GQ: Result := TCountryCode.GQ;
        TCountryCodeEnum.GR: Result := TCountryCode.GR;
        TCountryCodeEnum.GS: Result := TCountryCode.GS;
        TCountryCodeEnum.GT: Result := TCountryCode.GT;
        TCountryCodeEnum.GU: Result := TCountryCode.GU;
        TCountryCodeEnum.GW: Result := TCountryCode.GW;
        TCountryCodeEnum.GY: Result := TCountryCode.GY;
        TCountryCodeEnum.HK: Result := TCountryCode.HK;
        TCountryCodeEnum.HM: Result := TCountryCode.HM;
        TCountryCodeEnum.HN: Result := TCountryCode.HN;
        TCountryCodeEnum.HR: Result := TCountryCode.HR;
        TCountryCodeEnum.HT: Result := TCountryCode.HT;
        TCountryCodeEnum.HU: Result := TCountryCode.HU;
        TCountryCodeEnum.ID: Result := TCountryCode.ID;
        TCountryCodeEnum.IE: Result := TCountryCode.IE;
        TCountryCodeEnum.IL: Result := TCountryCode.IL;
        TCountryCodeEnum.IM: Result := TCountryCode.IM;
        TCountryCodeEnum.IN_: Result := TCountryCode.IN_;
        TCountryCodeEnum.IO: Result := TCountryCode.IO;
        TCountryCodeEnum.IQ: Result := TCountryCode.IQ;
        TCountryCodeEnum.IR: Result := TCountryCode.IR;
        TCountryCodeEnum.IS_: Result := TCountryCode.IS_;
        TCountryCodeEnum.IT: Result := TCountryCode.IT;
        TCountryCodeEnum.JE: Result := TCountryCode.JE;
        TCountryCodeEnum.JM: Result := TCountryCode.JM;
        TCountryCodeEnum.JO: Result := TCountryCode.JO;
        TCountryCodeEnum.JP: Result := TCountryCode.JP;
        TCountryCodeEnum.KE: Result := TCountryCode.KE;
        TCountryCodeEnum.KG: Result := TCountryCode.KG;
        TCountryCodeEnum.KH: Result := TCountryCode.KH;
        TCountryCodeEnum.KI: Result := TCountryCode.KI;
        TCountryCodeEnum.KM: Result := TCountryCode.KM;
        TCountryCodeEnum.KN: Result := TCountryCode.KN;
        TCountryCodeEnum.KP: Result := TCountryCode.KP;
        TCountryCodeEnum.KR: Result := TCountryCode.KR;
        TCountryCodeEnum.KW: Result := TCountryCode.KW;
        TCountryCodeEnum.KY: Result := TCountryCode.KY;
        TCountryCodeEnum.KZ: Result := TCountryCode.KZ;
        TCountryCodeEnum.LA: Result := TCountryCode.LA;
        TCountryCodeEnum.LB: Result := TCountryCode.LB;
        TCountryCodeEnum.LC: Result := TCountryCode.LC;
        TCountryCodeEnum.LI: Result := TCountryCode.LI;
        TCountryCodeEnum.LK: Result := TCountryCode.LK;
        TCountryCodeEnum.LR: Result := TCountryCode.LR;
        TCountryCodeEnum.LS: Result := TCountryCode.LS;
        TCountryCodeEnum.LT: Result := TCountryCode.LT;
        TCountryCodeEnum.LU: Result := TCountryCode.LU;
        TCountryCodeEnum.LV: Result := TCountryCode.LV;
        TCountryCodeEnum.LY: Result := TCountryCode.LY;
        TCountryCodeEnum.MA: Result := TCountryCode.MA;
        TCountryCodeEnum.MC: Result := TCountryCode.MC;
        TCountryCodeEnum.MD: Result := TCountryCode.MD;
        TCountryCodeEnum.ME: Result := TCountryCode.ME;
        TCountryCodeEnum.MF: Result := TCountryCode.MF;
        TCountryCodeEnum.MG: Result := TCountryCode.MG;
        TCountryCodeEnum.MH: Result := TCountryCode.MH;
        TCountryCodeEnum.MK: Result := TCountryCode.MK;
        TCountryCodeEnum.ML: Result := TCountryCode.ML;
        TCountryCodeEnum.MM: Result := TCountryCode.MM;
        TCountryCodeEnum.MN: Result := TCountryCode.MN;
        TCountryCodeEnum.MO: Result := TCountryCode.MO;
        TCountryCodeEnum.MP: Result := TCountryCode.MP;
        TCountryCodeEnum.MQ: Result := TCountryCode.MQ;
        TCountryCodeEnum.MR: Result := TCountryCode.MR;
        TCountryCodeEnum.MS: Result := TCountryCode.MS;
        TCountryCodeEnum.MT: Result := TCountryCode.MT;
        TCountryCodeEnum.MU: Result := TCountryCode.MU;
        TCountryCodeEnum.MV: Result := TCountryCode.MV;
        TCountryCodeEnum.MW: Result := TCountryCode.MW;
        TCountryCodeEnum.MX: Result := TCountryCode.MX;
        TCountryCodeEnum.MY: Result := TCountryCode.MY;
        TCountryCodeEnum.MZ: Result := TCountryCode.MZ;
        TCountryCodeEnum.NA: Result := TCountryCode.NA;
        TCountryCodeEnum.NC: Result := TCountryCode.NC;
        TCountryCodeEnum.NE: Result := TCountryCode.NE;
        TCountryCodeEnum.NF: Result := TCountryCode.NF;
        TCountryCodeEnum.NG: Result := TCountryCode.NG;
        TCountryCodeEnum.NI: Result := TCountryCode.NI;
        TCountryCodeEnum.NL: Result := TCountryCode.NL;
        TCountryCodeEnum.NO: Result := TCountryCode.NO;
        TCountryCodeEnum.NP: Result := TCountryCode.NP;
        TCountryCodeEnum.NR: Result := TCountryCode.NR;
        TCountryCodeEnum.NU: Result := TCountryCode.NU;
        TCountryCodeEnum.NZ: Result := TCountryCode.NZ;
        TCountryCodeEnum.OM: Result := TCountryCode.OM;
        TCountryCodeEnum.PA: Result := TCountryCode.PA;
        TCountryCodeEnum.PE: Result := TCountryCode.PE;
        TCountryCodeEnum.PF: Result := TCountryCode.PF;
        TCountryCodeEnum.PG: Result := TCountryCode.PG;
        TCountryCodeEnum.PH: Result := TCountryCode.PH;
        TCountryCodeEnum.PK: Result := TCountryCode.PK;
        TCountryCodeEnum.PL: Result := TCountryCode.PL;
        TCountryCodeEnum.PM: Result := TCountryCode.PM;
        TCountryCodeEnum.PN: Result := TCountryCode.PN;
        TCountryCodeEnum.PR: Result := TCountryCode.PR;
        TCountryCodeEnum.PS: Result := TCountryCode.PS;
        TCountryCodeEnum.PT: Result := TCountryCode.PT;
        TCountryCodeEnum.PW: Result := TCountryCode.PW;
        TCountryCodeEnum.PY: Result := TCountryCode.PY;
        TCountryCodeEnum.QA: Result := TCountryCode.QA;
        TCountryCodeEnum.RE: Result := TCountryCode.RE;
        TCountryCodeEnum.RO: Result := TCountryCode.RO;
        TCountryCodeEnum.RS: Result := TCountryCode.RS;
        TCountryCodeEnum.RU: Result := TCountryCode.RU;
        TCountryCodeEnum.RW: Result := TCountryCode.RW;
        TCountryCodeEnum.SA: Result := TCountryCode.SA;
        TCountryCodeEnum.SB: Result := TCountryCode.SB;
        TCountryCodeEnum.SC: Result := TCountryCode.SC;
        TCountryCodeEnum.SD: Result := TCountryCode.SD;
        TCountryCodeEnum.SE: Result := TCountryCode.SE;
        TCountryCodeEnum.SG: Result := TCountryCode.SG;
        TCountryCodeEnum.SH: Result := TCountryCode.SH;
        TCountryCodeEnum.SI: Result := TCountryCode.SI;
        TCountryCodeEnum.SJ: Result := TCountryCode.SJ;
        TCountryCodeEnum.SK: Result := TCountryCode.SK;
        TCountryCodeEnum.SL: Result := TCountryCode.SL;
        TCountryCodeEnum.SM: Result := TCountryCode.SM;
        TCountryCodeEnum.SN: Result := TCountryCode.SN;
        TCountryCodeEnum.SO: Result := TCountryCode.SO;
        TCountryCodeEnum.SR: Result := TCountryCode.SR;
        TCountryCodeEnum.SS: Result := TCountryCode.SS;
        TCountryCodeEnum.ST: Result := TCountryCode.ST;
        TCountryCodeEnum.SV: Result := TCountryCode.SV;
        TCountryCodeEnum.SX: Result := TCountryCode.SX;
        TCountryCodeEnum.SY: Result := TCountryCode.SY;
        TCountryCodeEnum.SZ: Result := TCountryCode.SZ;
        TCountryCodeEnum.TC: Result := TCountryCode.TC;
        TCountryCodeEnum.TD: Result := TCountryCode.TD;
        TCountryCodeEnum.TF: Result := TCountryCode.TF;
        TCountryCodeEnum.TG: Result := TCountryCode.TG;
        TCountryCodeEnum.TH: Result := TCountryCode.TH;
        TCountryCodeEnum.TJ: Result := TCountryCode.TJ;
        TCountryCodeEnum.TK: Result := TCountryCode.TK;
        TCountryCodeEnum.TL: Result := TCountryCode.TL;
        TCountryCodeEnum.TM: Result := TCountryCode.TM;
        TCountryCodeEnum.TN: Result := TCountryCode.TN;
        TCountryCodeEnum.TO_: Result := TCountryCode.TO_;
        TCountryCodeEnum.TR: Result := TCountryCode.TR;
        TCountryCodeEnum.TT: Result := TCountryCode.TT;
        TCountryCodeEnum.TV: Result := TCountryCode.TV;
        TCountryCodeEnum.TW: Result := TCountryCode.TW;
        TCountryCodeEnum.TZ: Result := TCountryCode.TZ;
        TCountryCodeEnum.UA: Result := TCountryCode.UA;
        TCountryCodeEnum.UG: Result := TCountryCode.UG;
        TCountryCodeEnum.UM: Result := TCountryCode.UM;
        TCountryCodeEnum.US: Result := TCountryCode.US;
        TCountryCodeEnum.UY: Result := TCountryCode.UY;
        TCountryCodeEnum.UZ: Result := TCountryCode.UZ;
        TCountryCodeEnum.VA: Result := TCountryCode.VA;
        TCountryCodeEnum.VC: Result := TCountryCode.VC;
        TCountryCodeEnum.VE: Result := TCountryCode.VE;
        TCountryCodeEnum.VG: Result := TCountryCode.VG;
        TCountryCodeEnum.VI: Result := TCountryCode.VI;
        TCountryCodeEnum.VN: Result := TCountryCode.VN;
        TCountryCodeEnum.VU: Result := TCountryCode.VU;
        TCountryCodeEnum.WF: Result := TCountryCode.WF;
        TCountryCodeEnum.WS: Result := TCountryCode.WS;
        TCountryCodeEnum.XK: Result := TCountryCode.XK;
        TCountryCodeEnum.YE: Result := TCountryCode.YE;
        TCountryCodeEnum.YT: Result := TCountryCode.YT;
        TCountryCodeEnum.ZA: Result := TCountryCode.ZA;
        TCountryCodeEnum.ZM: Result := TCountryCode.ZM;
        TCountryCodeEnum.ZW: Result := TCountryCode.ZW;
    else
        raise Exception.Create('Internal Error: Unexpected TCountryCodeEnum value: ' + IntToStr(Integer(cc)));
    end;
end;


{**
 * Country alpha2 code map, maps alpha2 codes to country codes
 *}
class procedure TCountryCode.buildAlpha2Map();
var
    cc: TCountryCodeEnum;
    code: TCountryCode;
begin
    FAlpha2Map :=  TDictionary<string, TCountryCode>.Create(APPROXIMATE_NUMBER_OF_ENTRIES);
    for cc := Low(TCountryCodeEnum) to High(TCountryCodeEnum) do
    begin
        code := GetCountryCodeForEnum(cc);
        FAlpha2Map.Add(code.getAlpha2, code);
    end;
end;

{**
 * Country alpha3 code map, maps alpha3 codes to country codes
 *}
class procedure TCountryCode.buildAlpha3Map;
var
    cc: TCountryCodeEnum;
    code: TCountryCode;
begin
    FAlpha3Map :=  TDictionary<string, TCountryCode>.Create(APPROXIMATE_NUMBER_OF_ENTRIES);
    for cc := Low(TCountryCodeEnum) to High(TCountryCodeEnum) do
    begin
        code := GetCountryCodeForEnum(cc);
        FAlpha3Map.Add(code.getAlpha3, code);
    end;
end;

class destructor TCountryCode.DestroyClass;
begin
    FreeAndNil(FAlpha2Map);
    FreeAndNil(FAlpha3Map);
    FreeAndNil(FCountryCodeEnumeratorFactory);
end;


{**
 * Get the country name.
 *
 * @return The country name.
 *}
function TCountryCode.getName(): string;
begin
    Result := FName;
end;

{**
 * Get the <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2">ISO 3166-1 alpha-2</a> code.
 *
 * @return The <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2">ISO 3166-1 alpha-2</a> code.
 *}
function TCountryCode.getAlpha2(): string;
begin
    Result := FAlpha2;
end;
function TCountryCode.toString: string;
begin
    Result := FAlpha2;
end;

{**
 * Get the <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3">ISO 3166-1 alpha-3</a> code.
 *
 * @return The <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3">ISO 3166-1 alpha-3</a> code.
 *}
function TCountryCode.getAlpha3(): string;
begin
    Result := FAlpha3;
end;


{**
 * Get a CountryCode that corresponds to the given ISO 3166-1
 * <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2">alpha-2</a> or
 * <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3">alpha-3</a> code.
 *
 * @param code An ISO 3166-1 <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2">alpha-2</a> or
 *             <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3">alpha-3</a> code.
 * @return A CountryCode instance, or null if not found.
 *}
class function TCountryCode.getByCode(const code: string): TCountryCode;
begin
    case code.length of
        2:
            Result := getByAlpha2Code(code.toUpper());

        3:
            Result := getByAlpha3Code(code.toUpper());

        else
            Result := TCountryCode.UNKNOWN;
    end;
end;

{**
 * Get a CountryCode that corresponds to the given ISO 3166-1
 * <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2">alpha-2</a> code.
 *
 * @param code An ISO 3166-1 <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2">alpha-2</a> code.
 * @return A CountryCode instance, or null if not found.
 *}
class function TCountryCode.getByAlpha2Code(const code: string): TCountryCode;
begin
    if not Assigned(FAlpha2Map) then
      buildAlpha2Map();
    Assert(Assigned(FAlpha2Map));
    if not FAlpha2Map.TryGetValue(code, Result) then
      Result := TCountryCode.UNKNOWN;
end;

{**
 * Get a CountryCode that corresponds to the given ISO 3166-1
 * <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3">alpha-3</a> code.
 *
 * @param code An ISO 3166-1 <a href="http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3">alpha-3</a> code.
 * @return A CountryCode instance, or null if not found.
 *}
class function TCountryCode.getByAlpha3Code(const code: string): TCountryCode;
begin
    if not Assigned(FAlpha3Map) then
      buildAlpha3Map();
    Assert(Assigned(FAlpha3Map));
    if not FAlpha3Map.TryGetValue(code, Result) then
      Result := TCountryCode.UNKNOWN;
end;

function TCountryCode.isInvalid: Boolean;
begin
    Result := FAlpha2.IsEmpty;
end;

class operator TCountryCode.Implicit(val: TCountryCode): string;
begin
    Result := val.toString();
end;

class operator TCountryCode.Equal(a, b: TCountryCode): Boolean;
begin
    Result := a.FAlpha2 = b.FAlpha2;
end;

//Enumerator related stuff
// for x in TCountryCode.values do ...

//see https://www.thedelphigeek.com/2007/03/fun-with-enumerators-part-2-multiple.html
class function TCountryCode.values: TCountryCodeEnumeratorFactory;
begin
    if not Assigned(FCountryCodeEnumeratorFactory) then
      FCountryCodeEnumeratorFactory := TCountryCodeEnumeratorFactory.Create;
    Result := FCountryCodeEnumeratorFactory;
end;

function TCountryCodeEnumeratorFactory.GetEnumerator: TCountryCodeEnumerator;
begin
    Result := TCountryCodeEnumerator.Create;
end;

{ TCountryCodeEnumerator }

function TCountryCodeEnumerator.GetCurrent: TCountryCode;
begin
    Result := GetCountryCodeForEnum(TCountryCodeEnum(FIndex));
end;

function TCountryCodeEnumerator.MoveNext: Boolean;
begin
    if FIndex = Integer(High(TCountryCodeEnum)) then
      Result := False
    else begin
        Result := True;
        Inc(FIndex);
    end;
end;


end.