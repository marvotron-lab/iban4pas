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
unit Iban4Pas.BbanStructureEntry;

{
    TODO: implement getRandom
}

interface

uses
    Iban4Pas.BaseTypes;


type

    {$SCOPEDENUMS ON}
    TEntryCharacterType = (
        n,  // Digits (numeric characters 0 to 9 only)
        a,  // Upper case letters (alphabetic characters A-Z only)
        c  // upper and lower case alphanumeric characters (A-Z, a-z and 0-9)
    );
    {$SCOPEDENUMS OFF}

    {**
     * Bban Structure Entry representation.
     *}
    TBbanStructureEntry = record
    private
        FEntryType: TBbanEntryType;
        FCharacterType: TEntryCharacterType;
        FLength: Integer;
    public
        class function EMPTY: TBbanStructureEntry; static;
        class function accountNumber(const length: Integer; const characterType: Char): TBbanStructureEntry; static;
        class function accountType(const length: Integer; const characterType: Char): TBbanStructureEntry; static;
        class function bankCode(const length: Integer; const characterType: Char): TBbanStructureEntry; static;
        class function branchCode(const length: Integer; const characterType: Char): TBbanStructureEntry; static;
        class function identificationNumber(const length: Integer; const characterType: Char): TBbanStructureEntry; static;
        class function nationalCheckDigit(const length: Integer; const characterType: Char): TBbanStructureEntry; static;
        class function ownerAccountNumber(const length: Integer; const characterType: Char): TBbanStructureEntry; static;

        function getCharacterType: TEntryCharacterType;
        function getEntryType: TBbanEntryType;
        function getLength: Integer;
    end;

    TBbanStructureEntryArray = array of TBbanStructureEntry;

implementation

uses
    System.SysUtils;


//original (automodified) java code:
//    private static Map<EntryCharacterType, char[]> charByCharacterType;
//    private final Random random = new Random();
//
//    static begin
//        charByCharacterType = new HashMap<EntryCharacterType, char[]>();
//        StringBuilder charTypeN = new StringBuilder();
//        for (char ch = '0'; ch <= '9'; ch++) begin
//            charTypeN.append(ch);
//        end;
//        charByCharacterType.put(EntryCharacterType.n, charTypeN.toString().toCharArray());
//
//        StringBuilder charTypeA = new StringBuilder();
//        for (char ch = 'A'; ch <= 'Z'; ++ch) begin
//            charTypeA.append(ch);
//        end;
//        charByCharacterType.put(EntryCharacterType.a, charTypeA.toString().toCharArray());
//
//        charByCharacterType.put(EntryCharacterType.c, (charTypeN.toString() + charTypeA.toString()).toCharArray());
//    end;
//
//    private BbanStructureEntry(final BbanEntryType entryType,
//                       final EntryCharacterType characterType,
//                       final int length) begin
//        this.entryType = entryType;
//        this.characterType = characterType;
//        this.length = length;
//    end;

function EntryCharacterTypeValueOf(c: Char): TEntryCharacterType;
begin
    case c of
        'n': Result := TEntryCharacterType.n;
        'a': Result := TEntryCharacterType.a;
        'c': Result := TEntryCharacterType.c;
    else
        raise Exception.Create('Internal Error: invalid character type: ' + c);
    end;
end;

class function TBbanStructureEntry.EMPTY: TBbanStructureEntry;
begin
    Result.FEntryType := TBbanEntryType.national_check_digit;
    Result.FCharacterType := TEntryCharacterType.n;
    Result.FLength := 0;    //this identifies the empty record
end;

class function TBbanStructureEntry.bankCode(const length: Integer; const characterType: Char): TBbanStructureEntry;
begin
    Result.FEntryType := TBbanEntryType.bank_code;
    Result.FCharacterType := EntryCharacterTypeValueOf(characterType);
    Result.FLength := length;
end;

class function TBbanStructureEntry.branchCode(const length: Integer; const characterType: Char): TBbanStructureEntry;
begin
    Result.FEntryType := TBbanEntryType.branch_code;
    Result.FCharacterType := EntryCharacterTypeValueOf(characterType);
    Result.FLength := length;
end;

class function TBbanStructureEntry.accountNumber(const length: Integer; const characterType: Char): TBbanStructureEntry;
begin
    Result.FEntryType := TBbanEntryType.account_number;
    Result.FCharacterType := EntryCharacterTypeValueOf(characterType);
    Result.FLength := length;
end;

class function TBbanStructureEntry.nationalCheckDigit(const length: Integer; const characterType: Char): TBbanStructureEntry;
begin
    Result.FEntryType := TBbanEntryType.national_check_digit;
    Result.FCharacterType := EntryCharacterTypeValueOf(characterType);
    Result.FLength := length;
end;

class function TBbanStructureEntry.accountType(const length: Integer; const characterType: Char): TBbanStructureEntry;
begin
    Result.FEntryType := TBbanEntryType.account_type;
    Result.FCharacterType := EntryCharacterTypeValueOf(characterType);
    Result.FLength := length;
end;

class function TBbanStructureEntry.ownerAccountNumber(const length: Integer; const characterType: Char): TBbanStructureEntry;
begin
    Result.FEntryType := TBbanEntryType.owner_account_number;
    Result.FCharacterType := EntryCharacterTypeValueOf(characterType);
    Result.FLength := length;
end;

class function TBbanStructureEntry.identificationNumber(const length: Integer; const characterType: Char): TBbanStructureEntry;
begin
    Result.FEntryType := TBbanEntryType.identification_number;
    Result.FCharacterType := EntryCharacterTypeValueOf(characterType);
    Result.FLength := length;
end;

function TBbanStructureEntry.getEntryType(): TBbanEntryType;
begin
    Result := FEntryType;
end;

function TBbanStructureEntry.getCharacterType(): TEntryCharacterType;
begin
    Result := FCharacterType;
end;

function TBbanStructureEntry.getLength(): Integer;
begin
    Result := FLength;
end;

//public String getRandom() begin
//    StringBuilder s = new StringBuilder("");
//    char[] charChoices = charByCharacterType.get(characterType);
//    if (charChoices == null) begin
//        throw new RuntimeException(String.format("programmer has not implemented choices for character type %s",
//                characterType.name()));
//    end;
//    for (int i = 0; i < getLength(); i++) begin
//        s.append(charChoices[random.nextInt(charChoices.length)]);
//    end;
//    Result := s.toString();
//end;

end.

