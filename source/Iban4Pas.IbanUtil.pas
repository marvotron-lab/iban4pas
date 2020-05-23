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
unit Iban4Pas.IbanUtil;

interface

uses
    Iban4Pas.BaseTypes,
    Iban4Pas.Exceptions,
    Iban4Pas.IbanFormatException,
    Iban4Pas.InvalidCheckDigitException,
    Iban4Pas.UnsupportedCountryException,
    Iban4Pas.BbanStructure,
    Iban4Pas.BbanStructureEntry,
    Iban4Pas.CountryCode;

type
    {**
     * Iban Utility Class
     *}
    TIbanUtil = class
    private
        const COUNTRY_CODE_INDEX = 0;   //substring is zero-based
        const COUNTRY_CODE_LENGTH = 2;
        const CHECK_DIGIT_INDEX = COUNTRY_CODE_INDEX + COUNTRY_CODE_LENGTH;
        const CHECK_DIGIT_LENGTH = 2;
        const BBAN_INDEX = CHECK_DIGIT_INDEX + CHECK_DIGIT_LENGTH;

        const ASSERT_UPPER_LETTERS = '[%s] must contain only upper case letters.';
        const ASSERT_DIGITS_AND_LETTERS = '[%s] must contain only digits or letters.';
        const ASSERT_DIGITS = '[%s] must contain only digits.';

    protected
        class function calculateMod(const iban: string): Integer;
        class function extractBbanEntry(const iban: string; const entryType: TBbanEntryType): string;
        class function getBbanStructure(const iban: string): TBbanStructure; overload;
        class function getBbanStructure(countryCode: TCountryCode): TBbanStructure; overload;
        class procedure validateBbanEntries(const iban: string; const structure: TBbanStructure);
        class procedure validateBbanEntryCharacterType(const entry: TBbanStructureEntry; const entryValue: string);
        class procedure validateBbanLength(const iban: string; const structure: TBbanStructure);
        class procedure validateCheckDigit(const iban: string);
        class procedure validateCheckDigitPresence(const iban: string);
        class procedure validateCountryCode(const iban: string);
        class procedure validateEmpty(const iban: string);

    public
        class function calculateCheckDigit(const iban: string): string;
        //class function calculateCheckDigit(const iban: IIban): string;
        class function getAccountNumber(const iban: string): string;
        class function getAccountType(const iban: string): string;
        class function getBankCode(const iban: string): string;
        class function getBban(const iban: string): string;
        class function getBranchCode(const iban: string): string;
        class function getCheckDigit(const iban: string): string;
        class function getCountryCode(const iban: string): string;
        class function getCountryCodeAndCheckDigit(const iban: string): string;
        class function getIbanLength(const countryCode: TCountryCode): Integer;
        class function getIdentificationNumber(const iban: string): string;
        class function getNationalCheckDigit(const iban: string): string;
        class function getOwnerAccountType(const iban: string): string;
        class function isSupportedCountry(const countryCode: TCountryCode): Boolean;
        class function replaceCheckDigit(const iban, checkDigit: string): string;
        class function toFormattedString(const iban: string): string;
        class procedure validate(const iban: string); overload;
        class procedure validate(const iban: string; const format: TIbanFormat); overload;
    end;

    //convenience declarations
    EIban4PasException = Iban4Pas.Exceptions.EIban4PasException;
    EIbanFormatException = Iban4Pas.IbanFormatException.EIbanFormatException;
    EInvalidCheckDigitException = Iban4Pas.InvalidCheckDigitException.EInvalidCheckDigitException;
    EUnsupportedCountryException = Iban4Pas.UnsupportedCountryException.EUnsupportedCountryException;
    TIbanFormat = Iban4Pas.BaseTypes.TIbanFormat;

implementation

uses
    System.SysUtils,
    System.Character,
    Iban4Pas.Iban;  //TIban.DEFAULT_CHECK_DIGIT


{**
 * Calculates Iban
 * <a href="http://en.wikipedia.org/wiki/ISO_13616#Generating_IBAN_check_digits">Check Digit</a>.
 *
 * @param iban string value
 * @throws IbanFormatException if iban contains invalid character.
 *
 * @return check digit as String
 *}
class function TIbanUtil.calculateCheckDigit(const iban: string): string;
var
    reformattedIban: string;
    modResult: Integer;
    checkDigitIntValue: Integer;
    checkDigit: string;
begin
    reformattedIban := replaceCheckDigit(iban,
            TIban.DEFAULT_CHECK_DIGIT);
    modResult := calculateMod(reformattedIban);
    checkDigitIntValue := (98 - modResult);
    checkDigit := IntToStr(checkDigitIntValue);
    if checkDigitIntValue > 9 then
      Result := checkDigit
    else
      Result := '0' + checkDigit;
end;

{**
 * Validates iban.
 *
 * @param iban to be validated.
 * @throws IbanFormatException if iban is invalid.
 *         UnsupportedCountryException if iban's country is not supported.
 *         InvalidCheckDigitException if iban has invalid check digit.
 *}
class procedure TIbanUtil.validate(const iban: string);
var
    structure: TBbanStructure;
begin
    try
        validateEmpty(iban);
        validateCountryCode(iban);
        validateCheckDigitPresence(iban);

        structure := getBbanStructure(iban);

        validateBbanLength(iban, structure);
        validateBbanEntries(iban, structure);

        validateCheckDigit(iban);
    except
        on E: EIban4PasException do
          raise;
        on E: Exception do
          raise EIbanFormatException.Create(UNKNOWN, E.Message);
    end;
end;

{**
 * Validates iban.
 *
 * @param iban to be validated.
 * @param format to be used in validation.
 * @throws IbanFormatException if iban is invalid.
 *         UnsupportedCountryException if iban's country is not supported.
 *         InvalidCheckDigitException if iban has invalid check digit.
 *}
class procedure TIbanUtil.validate(const iban: string; const format: TIbanFormat);
var
    ibanWithoutSpaces: string;
begin
    case format of
        TIbanFormat.Default:
            begin
                ibanWithoutSpaces := iban.replace(' ', '');
                validate(ibanWithoutSpaces);
                if not (toFormattedString(ibanWithoutSpaces) = iban) then
                begin
                    raise EIbanFormatException.Create(IBAN_FORMATTING,
                            System.SysUtils.Format('Iban must be formatted using 4 characters and space combination. ' +
                                    'Instead of [%s]', [iban]));
                end;
            end;
        else
            validate(iban);
    end;
end;

{**
 * Checks whether country is supporting iban.
 * @param countryCode begin@link org.iban4j.CountryCodeend;
 *
 * @return boolean true if country supports iban, false otherwise.
 *}
class function TIbanUtil.isSupportedCountry(const countryCode: TCountryCode): Boolean;
begin
    Result := TBbanStructure.forCountry(countryCode) <> nil;
end;

{**
 * Returns iban length for the specified country.
 *
 * @param countryCode begin@link org.iban4j.CountryCodeend;
 * @return the length of the iban for the specified country.
 *}
class function TIbanUtil.getIbanLength(const countryCode: TCountryCode): Integer;
var
    structure: TBbanStructure;
begin
    structure := getBbanStructure(countryCode);
    Result := COUNTRY_CODE_LENGTH + CHECK_DIGIT_LENGTH + structure.getBbanLength();
end;

{**
 * Returns iban's check digit.
 *
 * @param iban String
 * @return checkDigit String
 *}
class function TIbanUtil.getCheckDigit(const iban: string): string;
begin
    Result := iban.substring(CHECK_DIGIT_INDEX, CHECK_DIGIT_LENGTH);
end;

{**
 * Returns iban's country code.
 *
 * @param iban String
 * @return countryCode String
 *}
class function TIbanUtil.getCountryCode(const iban: string): string;
begin
    Result := iban.substring(COUNTRY_CODE_INDEX, COUNTRY_CODE_LENGTH);
end;

{**
 * Returns iban's country code and check digit.
 *
 * @param iban String
 * @return countryCodeAndCheckDigit String
 *}
class function TIbanUtil.getCountryCodeAndCheckDigit(const iban: string): string;
begin
    Result := iban.substring(COUNTRY_CODE_INDEX, COUNTRY_CODE_LENGTH + CHECK_DIGIT_LENGTH);
end;

{**
 * Returns iban's bban (Basic Bank Account Number).
 *
 * @param iban String
 * @return bban String
 *}
class function TIbanUtil.getBban(const iban: string): string;
begin
    Result := iban.substring(BBAN_INDEX);
end;

{**
 * Returns iban's account number.
 *
 * @param iban String
 * @return accountNumber String
 *}
class function TIbanUtil.getAccountNumber(const iban: string): string;
begin
    Result := extractBbanEntry(iban, TBbanEntryType.account_number);
end;

{**
 * Returns iban's bank code.
 *
 * @param iban String
 * @return bankCode String
 *}
class function TIbanUtil.getBankCode(const iban: string): string;
begin
    Result := extractBbanEntry(iban, TBbanEntryType.bank_code);
end;


{**
 * Returns iban's branch code.
 *
 * @param iban String
 * @return branchCode String
 *}
class function TIbanUtil.getBranchCode(const iban: string): string;
begin
    Result := extractBbanEntry(iban, TBbanEntryType.branch_code);
end;

{**
 * Returns iban's national check digit.
 *
 * @param iban String
 * @return nationalCheckDigit String
 *}
class function TIbanUtil.getNationalCheckDigit(const iban: string): string;
begin
    Result := extractBbanEntry(iban, TBbanEntryType.national_check_digit);
end;

{**
 * Returns iban's account type.
 *
 * @param iban String
 * @return accountType String
 *}
class function TIbanUtil.getAccountType(const iban: string): string;
begin
    Result := extractBbanEntry(iban, TBbanEntryType.account_type);
end;

{**
 * Returns iban's owner account type.
 *
 * @param iban String
 * @return ownerAccountType String
 *}
class function TIbanUtil.getOwnerAccountType(const iban: string): string;
begin
    Result := extractBbanEntry(iban, TBbanEntryType.owner_account_number);
end;

{**
 * Returns iban's identification number.
 *
 * @param iban String
 * @return identificationNumber String
 *}
class function TIbanUtil.getIdentificationNumber(const iban: string): string;
begin
    Result := extractBbanEntry(iban, TBbanEntryType.identification_number);
end;

//class function TIbanUtil.calculateCheckDigit(const iban: IIban): string;
//begin
//    Result := calculateCheckDigit(iban.toString());
//end;

{**
 * Returns an iban with replaced check digit.
 *
 * @param iban The iban
 * @return The iban without the check digit
 *}
class function TIbanUtil.replaceCheckDigit(const iban: string; const checkDigit: string): string;
begin
    Result := getCountryCode(iban) + checkDigit + getBban(iban);
end;

{**
 * Returns formatted version of Iban.
 *
 * @return A string representing formatted Iban for printing.
 *}
class function TIbanUtil.toFormattedString(const iban: string): string;
var
    ibanBuffer: TStringBuilder;
    len: Integer;
    i: Integer;
begin
    ibanBuffer := TStringBuilder.Create(iban);
    try
        len := ibanBuffer.Length;

        for i := 0 to (len div 4) - 1 do
        begin
            //original: ibanBuffer.insert((i + 1) * 4 + i, " ");
            ibanBuffer.insert((i + 1) * 4 + i , ' ');
        end;

        Result := ibanBuffer.toString().trim();
    finally
        ibanBuffer.Free;
    end;
end;

class procedure TIbanUtil.validateCheckDigit(const iban: string);
var
    checkDigit: string;
    expectedCheckDigit: string;
begin
    if calculateMod(iban) <> 1 then
    begin
        checkDigit := getCheckDigit(iban);
        expectedCheckDigit := calculateCheckDigit(iban);
        raise EInvalidCheckDigitException.Create(
                checkDigit, expectedCheckDigit,
                Format('[%s] has invalid check digit: %s, ' +
                                'expected check digit is: %s',
                        [iban, checkDigit, expectedCheckDigit]));
    end;
end;

class procedure TIbanUtil.validateEmpty(const iban: string);
begin
    if iban.isEmpty then
    begin
        raise EIbanFormatException.Create(IBAN_NOT_EMPTY,
                'Empty string can''t be a valid Iban.');
    end;
end;

class procedure TIbanUtil.validateCountryCode(const iban: string);
var
    countryCode: string;
    structure: TBbanStructure;
begin
    // check if iban contains 2 char country code
    if iban.Length < COUNTRY_CODE_LENGTH then
    begin
        raise EIbanFormatException.Create(COUNTRY_CODE_TWO_LETTERS, iban,
                'Iban must contain 2 char country code.');
    end;

    countryCode := getCountryCode(iban);

    // check case sensitivity
    if not (countryCode = countryCode.toUpper()) or
        not Char(countryCode[1]).isLetter or
        not Char(countryCode[1]).isLetter then
    begin
        raise EIbanFormatException.Create(COUNTRY_CODE_UPPER_CASE_LETTERS, countryCode,
                'Iban country code must contain upper case letters.');
    end;

    if TCountryCode.getByCode(countryCode).isInvalid then
    begin
        raise EIbanFormatException.Create(COUNTRY_CODE_EXISTS, countryCode,
                'Iban contains non existing country code.');
    end;

    // check if country is supported
    structure := TBbanStructure.forCountry(
            TCountryCode.getByCode(countryCode));
    if structure = nil then
    begin
        raise EUnsupportedCountryException.Create(countryCode,
                'Country code is not supported.');
    end;
end;

class procedure TIbanUtil.validateCheckDigitPresence(const iban: string);
var
    checkDigit: string;
begin
    // check if iban contains 2 digit check digit
    if iban.length < COUNTRY_CODE_LENGTH + CHECK_DIGIT_LENGTH then
    begin
        raise EIbanFormatException.Create(CHECK_DIGIT_TWO_DIGITS,
                iban.substring(COUNTRY_CODE_LENGTH),
                'Iban must contain 2 digit check digit.');
    end;

    checkDigit := getCheckDigit(iban);

    // check digits
    if not Char(checkDigit[1]).isDigit() or
       not Char(checkDigit[2]).isDigit() then
    begin
        raise EIbanFormatException.Create(CHECK_DIGIT_ONLY_DIGITS, checkDigit,
                'Iban''s check digit should contain only digits.');
    end;
end;

class procedure TIbanUtil.validateBbanLength(const iban: string;
                                       const structure: TBbanStructure);
var
    expectedBbanLength: Integer;
    bban: string;
    bbanLength: Integer;
begin
    expectedBbanLength := structure.getBbanLength();
    bban := getBban(iban);
    bbanLength := bban.Length;
    if expectedBbanLength <> bbanLength then
    begin
        raise EIbanFormatException.Create(BBAN_LENGTH,
                IntToStr(bbanLength), IntToStr(expectedBbanLength),
                Format('[%s] length is %d, expected BBAN length is: %d',
                        [bban, bbanLength, expectedBbanLength]));
    end;
end;

class procedure TIbanUtil.validateBbanEntries(const iban: string;
                                       const structure: TBbanStructure);
var
    bban: string;
    bbanEntryOffset: Integer;
    entry: TBbanStructureEntry;
    entryLength: Integer;
    entryValue: string;
begin
    bban := getBban(iban);
    bbanEntryOffset := 0;
    //for(final BbanStructureEntry entry : structure.getEntries()) {
    for entry in structure.getEntries() do
    begin
        entryLength := entry.getLength();
        entryValue := bban.substring(bbanEntryOffset, entryLength);

        bbanEntryOffset := bbanEntryOffset + entryLength;

        // validate character type
        validateBbanEntryCharacterType(entry, entryValue);
    end;
end;

class procedure TIbanUtil.validateBbanEntryCharacterType(const entry: TBbanStructureEntry;
                                                   const entryValue: string);
var
    ch: Char;
begin
    case entry.getCharacterType() of
        TEntryCharacterType.a:
            //for(char ch: entryValue.toCharArray()) {
            for ch in entryValue do
            begin
                if not ch.isUpper() then
                begin
                    raise EIbanFormatException.Create(BBAN_ONLY_UPPER_CASE_LETTERS,
                            entry.getEntryType(), entryValue, ch,
                            Format(ASSERT_UPPER_LETTERS, [entryValue]));
                end;
            end;
        TEntryCharacterType.c:
            for ch in entryValue do
            begin
                if not ch.isLetterOrDigit() then
                begin
                    raise EIbanFormatException.Create(BBAN_ONLY_DIGITS_OR_LETTERS,
                            entry.getEntryType(), entryValue, ch,
                            Format(ASSERT_DIGITS_AND_LETTERS, [entryValue]));
                end;
            end;
        TEntryCharacterType.n:
            for ch in entryValue do
            begin
                if not ch.isDigit() then
                begin
                    raise EIbanFormatException.Create(BBAN_ONLY_DIGITS,
                            entry.getEntryType(), entryValue, ch,
                            Format(ASSERT_DIGITS, [entryValue]));
                end;
            end;
    end;
end;

{**
 * Calculates
 * <a href="http://en.wikipedia.org/wiki/ISO_13616#Modulo_operation_on_IBAN">Iban Modulo</a>.
 *
 * @param iban String value
 * @return modulo 97
 *}
//original java source code:
//class procedure TIbanUtil.calculateMod(const iban: string): Integer;
//var
//    reformattedIban: string;
//    total: Integer;
//    i: Integer;
//    numericValue: Integer;
//begin
//    reformattedIban := getBban(iban) + getCountryCodeAndCheckDigit(iban);
//    total := 0;
//    //for i = 0; i < reformattedIban.length(); i++) {
//    for i := 1 to reformattedIban.length() do
//    begin
//        //final int numericValue = Character.getNumericValue(reformattedIban.charAt(i));
//        numericValue = Character.getNumericValue(reformattedIban.charAt(i));
//        if (numericValue < 0 || numericValue > 35) begin
//            throw new IbanFormatException(IBAN_VALID_CHARACTERS, null, null,
//                    reformattedIban.charAt(i),
//                    String.format('Invalid Character[%d] = ''%d''', i, numericValue));
//        end;
//        total = (numericValue > 9 ? total * 100 : total * 10) + numericValue;
//
//        if (total > MAX) begin
//            total = (total % MOD);
//        end;
//
//    end;
//    Result := (int) (total % MOD);
//end;
//aus https://www.delphipraxis.net/159320-iban-ueberpruefen.html
class function TIbanUtil.calculateMod(const iban: string): Integer;
const
    M36: string = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
    counter, pruef: Integer;
    reformattedIban: string;
begin
    reformattedIban := getBban(iban) + getCountryCodeAndCheckDigit(iban);
    Result := 0;

    for Counter := 1 to Length(reformattedIban) do
    begin
        Pruef := Pos(reformattedIban[Counter], M36) ;

        if (Pruef = 0) then
        begin
            raise EIbanFormatException.Create(IBAN_VALID_CHARACTERS,
                    reformattedIban[Counter], '',
                    Format('Invalid Character[%d] = ''%s''', [Counter, reformattedIban[Counter]]));
        end;

        Dec(Pruef);

        if (Pruef > 9) then
        begin
            Result := Result * 10 + (Pruef div 10);
            Pruef := Pruef mod 10;
        end;

        Result := Result * 10 + Pruef;
        Result := Result mod 97;
    end;
end;


class function TIbanUtil.getBbanStructure(const iban: string): TBbanStructure;
var
    countryCode: string;
begin
    countryCode := getCountryCode(iban);
    Result := getBbanStructure(TCountryCode.getByCode(countryCode));
end;

class function TIbanUtil.getBbanStructure(countryCode: TCountryCode): TBbanStructure;
begin
    Result := TBbanStructure.forCountry(countryCode);
end;

class function TIbanUtil.extractBbanEntry(const iban: string; const entryType: TBbanEntryType): string;
var
    bban: string;
    structure: TBbanStructure;
    bbanEntryOffset: Integer;
    entry: TBbanStructureEntry;
    entryLength: Integer;
    entryValue: string;
begin
    Result := '';
    bban := getBban(iban);
    structure := getBbanStructure(iban);
    bbanEntryOffset := 0;   //substring is zero-based
    for entry in structure.getEntries() do
    begin
        entryLength := entry.getLength();
        entryValue := bban.substring(bbanEntryOffset, entryLength);

        bbanEntryOffset := bbanEntryOffset + entryLength;
        if entry.getEntryType() = entryType then
        begin
            Result := entryValue;
        end;
    end;
end;

end.
