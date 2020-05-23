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
unit Iban4Pas.BbanStructure;

{
    TODO:
    * add supportedCountries
}


interface

uses
    System.Generics.Collections,
    Iban4Pas.BbanStructureEntry,
    Iban4Pas.CountryCode;

type
    {**
     * Class which represents bban structure
     *}
    TBbanStructure = class
    private
        class var FStructures: TObjectDictionary<string, TBbanStructure>;
        class function getStructures(): TObjectDictionary<string, TBbanStructure>;
    private
        FEntries: TBbanStructureEntryArray;
        constructor CreateIntern(entryCount: Integer; entry1, entry2, entry3, entry4, entry5: TBbanStructureEntry);
    protected
        constructor Create(entry1, entry2, entry3, entry4: TBbanStructureEntry); overload;
        constructor Create(entry1, entry2, entry3, entry4, entry5: TBbanStructureEntry); overload;
        constructor Create(entry1, entry2, entry3: TBbanStructureEntry); overload;
        constructor Create(entry1, entry2: TBbanStructureEntry); overload;
        class destructor DestroyClass;
    public
        function getBbanLength(): Integer;
        class function forCountry(const countryCode: TCountryCode): TBbanStructure;
        function getEntries: TBbanStructureEntryArray;
    end;

implementation

uses
    System.SysUtils;


constructor TBbanStructure.CreateIntern(entryCount: Integer;
  entry1, entry2, entry3, entry4, entry5: TBbanStructureEntry);
begin
    Assert(entryCount <= 5);
    //---
    inherited Create;
    SetLength(FEntries, entryCount);
    FEntries[0] := entry1;
    FEntries[1] := entry2;
    if entryCount > 2 then
    begin
        FEntries[2] := entry3;
        if entryCount > 3 then
        begin
            FEntries[3] := entry4;
            if entryCount > 4 then
            FEntries[4] := entry5;
        end;
    end;
end;

//This does not work (E2001/E2010): constructor Create(entries: TBbanStructureEntryArray);
//therefore 4 constructors:
constructor TBbanStructure.Create(entry1, entry2, entry3, entry4, entry5: TBbanStructureEntry);
begin
    CreateIntern(5, entry1, entry2, entry3, entry4, entry5);
end;
constructor TBbanStructure.Create(entry1, entry2, entry3, entry4: TBbanStructureEntry);
begin
    CreateIntern(4, entry1, entry2, entry3, entry4, TBbanStructureEntry.EMPTY);
end;
constructor TBbanStructure.Create(entry1, entry2, entry3: TBbanStructureEntry);
begin
    CreateIntern(3, entry1, entry2, entry3, TBbanStructureEntry.EMPTY, TBbanStructureEntry.EMPTY);
end;
constructor TBbanStructure.Create(entry1, entry2: TBbanStructureEntry);
begin
    CreateIntern(2, entry1, entry2, TBbanStructureEntry.EMPTY, TBbanStructureEntry.EMPTY, TBbanStructureEntry.EMPTY);
end;

class function TBbanStructure.getStructures(): TObjectDictionary<string, TBbanStructure>;
begin
    if not Assigned(FStructures) then
    begin
        FStructures := TObjectDictionary<string, TBbanStructure>.Create([doOwnsValues]);

        FStructures.Add(TCountryCode.AL,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.branchCode(4, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(1, 'n'),
                        TBbanStructureEntry.accountNumber(16, 'c')));

        FStructures.Add(TCountryCode.AD,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.branchCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(12, 'c')));

        FStructures.Add(TCountryCode.AT,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(11, 'n')));


        FStructures.Add(TCountryCode.AZ,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.accountNumber(20, 'c')));

        FStructures.Add(TCountryCode.BH,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.accountNumber(14, 'c')));

        FStructures.Add(TCountryCode.BE,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(7, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.BA,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.branchCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(8, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.BR,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(8, 'n'),
                        TBbanStructureEntry.branchCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(10, 'n'),
                        TBbanStructureEntry.accountType(1, 'a'),
                        TBbanStructureEntry.ownerAccountNumber(1, 'c')));

        FStructures.Add(TCountryCode.BG,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.branchCode(4, 'n'),
                        TBbanStructureEntry.accountType(2, 'n'),
                        TBbanStructureEntry.accountNumber(8, 'c')));

        FStructures.Add(TCountryCode.CR,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(14, 'n')));

        FStructures.Add(TCountryCode.DE,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(8, 'n'),
                        TBbanStructureEntry.accountNumber(10, 'n')));

        FStructures.Add(TCountryCode.HR,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(7, 'n'),
                        TBbanStructureEntry.accountNumber(10, 'n')));

        FStructures.Add(TCountryCode.CY,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.branchCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(16, 'c')));

        FStructures.Add(TCountryCode.CZ,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(16, 'n')));

        FStructures.Add(TCountryCode.DK,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(10, 'n')));

        //DO is not supported as constant nam in Delphi --> DO_
        FStructures.Add(TCountryCode.DO_,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'c'),
                        TBbanStructureEntry.accountNumber(20, 'n')));

        FStructures.Add(TCountryCode.EE,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(2, 'n'),
                        TBbanStructureEntry.branchCode(2, 'n'),
                        TBbanStructureEntry.accountNumber(11, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(1, 'n')));

        FStructures.Add(TCountryCode.FO,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(9, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(1, 'n')));

        FStructures.Add(TCountryCode.FI,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(6, 'n'),
                        TBbanStructureEntry.accountNumber(7, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(1, 'n')));

        FStructures.Add(TCountryCode.FR,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(5, 'n'),
                        TBbanStructureEntry.branchCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(11, 'c'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.GE,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(2, 'a'),
                        TBbanStructureEntry.accountNumber(16, 'n')));

        FStructures.Add(TCountryCode.GI,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.accountNumber(15, 'c')));

        FStructures.Add(TCountryCode.GL,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(10, 'n')));

        FStructures.Add(TCountryCode.GR,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.branchCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(16, 'c')));

        FStructures.Add(TCountryCode.GT,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'c'),
                        TBbanStructureEntry.accountNumber(20, 'c')));

        FStructures.Add(TCountryCode.HU,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.branchCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(16, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(1, 'n')));

        //IS is not supported as constant nam in Delphi --> IS_
        FStructures.Add(TCountryCode.IS_,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.branchCode(2, 'n'),
                        TBbanStructureEntry.accountNumber(6, 'n'),
                        TBbanStructureEntry.identificationNumber(10, 'n')));

        FStructures.Add(TCountryCode.IE,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.branchCode(6, 'n'),
                        TBbanStructureEntry.accountNumber(8, 'n')));

        FStructures.Add(TCountryCode.IL,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.branchCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(13, 'n')));

        FStructures.Add(TCountryCode.IR,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(19, 'n')));

        FStructures.Add(TCountryCode.IT,
                TBbanStructure.Create(
                        TBbanStructureEntry.nationalCheckDigit(1, 'a'),
                        TBbanStructureEntry.bankCode(5, 'n'),
                        TBbanStructureEntry.branchCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(12, 'c')));

        FStructures.Add(TCountryCode.JO,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.branchCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(18, 'c')));

        FStructures.Add(TCountryCode.KZ,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(13, 'c')));

        FStructures.Add(TCountryCode.KW,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.accountNumber(22, 'c')));

        FStructures.Add(TCountryCode.LV,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.accountNumber(13, 'c')));

        FStructures.Add(TCountryCode.LB,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(20, 'c')));

        FStructures.Add(TCountryCode.LI,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(12, 'c')));

        FStructures.Add(TCountryCode.LT,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(11, 'n')));

        FStructures.Add(TCountryCode.LU,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(13, 'c')));

        FStructures.Add(TCountryCode.MK,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(10, 'c'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.MT,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.branchCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(18, 'c')));

        FStructures.Add(TCountryCode.MR,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(5, 'n'),
                        TBbanStructureEntry.branchCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(11, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.MU,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(6, 'c'),
                        TBbanStructureEntry.branchCode(2, 'n'),
                        TBbanStructureEntry.accountNumber(18, 'c')));

        FStructures.Add(TCountryCode.MD,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(2, 'c'),
                        TBbanStructureEntry.accountNumber(18, 'c')));

        FStructures.Add(TCountryCode.MC,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(5, 'n'),
                        TBbanStructureEntry.branchCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(11, 'c'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.ME,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(13, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.NL,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.accountNumber(10, 'n')));

        FStructures.Add(TCountryCode.NO,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(6, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(1, 'n')));

        FStructures.Add(TCountryCode.PK,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'c'),
                        TBbanStructureEntry.accountNumber(16, 'n')));

        FStructures.Add(TCountryCode.PS,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.accountNumber(21, 'c')));

        FStructures.Add(TCountryCode.PL,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.branchCode(4, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(1, 'n'),
                        TBbanStructureEntry.accountNumber(16, 'n')));

        FStructures.Add(TCountryCode.PT,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.branchCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(11, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.RO,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.accountNumber(16, 'c')));

        FStructures.Add(TCountryCode.QA,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.accountNumber(21, 'c')));

        FStructures.Add(TCountryCode.SM,
                TBbanStructure.Create(
                        TBbanStructureEntry.nationalCheckDigit(1, 'a'),
                        TBbanStructureEntry.bankCode(5, 'n'),
                        TBbanStructureEntry.branchCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(12, 'c')));

        FStructures.Add(TCountryCode.SA,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(2, 'n'),
                        TBbanStructureEntry.accountNumber(18, 'c')));

        FStructures.Add(TCountryCode.RS,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(13, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.SK,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.accountNumber(16, 'n')));

        FStructures.Add(TCountryCode.SI,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(2, 'n'),
                        TBbanStructureEntry.branchCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(8, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.ES,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'n'),
                        TBbanStructureEntry.branchCode(4, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n'),
                        TBbanStructureEntry.accountNumber(10, 'n')));

        FStructures.Add(TCountryCode.SE,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(17, 'n')));

        FStructures.Add(TCountryCode.CH,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(5, 'n'),
                        TBbanStructureEntry.accountNumber(12, 'c')));

        FStructures.Add(TCountryCode.TN,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(2, 'n'),
                        TBbanStructureEntry.branchCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(15, 'c')));

        FStructures.Add(TCountryCode.TR,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(5, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(1, 'c'),
                        TBbanStructureEntry.accountNumber(16, 'c')));

        FStructures.Add(TCountryCode.UA,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(6, 'n'),
                        TBbanStructureEntry.accountNumber(19, 'n')));

        FStructures.Add(TCountryCode.GB,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'a'),
                        TBbanStructureEntry.branchCode(6, 'n'),
                        TBbanStructureEntry.accountNumber(8, 'n')));

        FStructures.Add(TCountryCode.AE,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(16, 'c')));

        FStructures.Add(TCountryCode.VG,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(4, 'c'),
                        TBbanStructureEntry.accountNumber(16, 'n')));

        FStructures.Add(TCountryCode.TL,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(3, 'n'),
                        TBbanStructureEntry.accountNumber(14, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));

        FStructures.Add(TCountryCode.XK,
                TBbanStructure.Create(
                        TBbanStructureEntry.bankCode(2, 'n'),
                        TBbanStructureEntry.branchCode(2, 'n'),
                        TBbanStructureEntry.accountNumber(10, 'n'),
                        TBbanStructureEntry.nationalCheckDigit(2, 'n')));
    end;
    Result := FStructures;
end;

class destructor TBbanStructure.DestroyClass;
begin
    FreeAndNil(FStructures);
end;


//Note regarding Delphi port:
//TBbanStructure is a reference to a privately hold variable and may not be freed externally!
{**
 * @param countryCode the country code.
 * @return BbanStructure for specified country or null if country is not supported.
 *}
class function TBbanStructure.forCountry(const countryCode: TCountryCode): TBbanStructure;
begin
    if countryCode.isInvalid then
      Result := nil
    else if not getStructures.TryGetValue(countryCode.getAlpha2(), Result) then
      Result := nil;
end;


function TBbanStructure.getEntries: TBbanStructureEntryArray;
begin
    //TODO: Check if TList is better
    Result := FEntries;
end;

//public static List<CountryCode> supportedCountries() begin
//    final List<CountryCode> countryCodes = new ArrayList<CountryCode>(structures.size());
//    countryCodes.addAll(structures.keySet());
//    Result := Collections.unmodifiableList(countryCodes);
//end;

{**
 * Returns the length of bban.
 *
 * @return int length
 *}
function TBbanStructure.getBbanLength(): Integer;
var
    entry: TBbanStructureEntry;
begin
    Result := 0;

    // for (BbanStructureEntry entry : entries) {
    for entry in FEntries do
        Result := Result + entry.getLength();
end;


end.
