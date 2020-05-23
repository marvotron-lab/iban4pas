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
unit Iban4Pas.BicUtil;


interface

uses
    Iban4Pas.Exceptions,
    Iban4Pas.UnsupportedCountryException,
    Iban4Pas.BicFormatException,
    Iban4Pas.CountryCode;

type

    {**
     * Bic Utility Class
     *}
    TBicUtil = class
    private
        const BIC8_LENGTH = 8;
        const BIC11_LENGTH = 11;
        const BANK_CODE_INDEX = 0;  //substring is zero-based
        const BANK_CODE_LENGTH = 4;
        const COUNTRY_CODE_INDEX = BANK_CODE_INDEX + BANK_CODE_LENGTH;
        const COUNTRY_CODE_LENGTH = 2;
        const LOCATION_CODE_INDEX = COUNTRY_CODE_INDEX + COUNTRY_CODE_LENGTH;
        const LOCATION_CODE_LENGTH = 2;
        const BRANCH_CODE_INDEX = LOCATION_CODE_INDEX + LOCATION_CODE_LENGTH;
        const BRANCH_CODE_LENGTH = 3;

    protected
        class procedure validateBankCode(const bic: string);
        class procedure validateBranchCode(const bic: string);
        class procedure validateCase(const bic: string);
        class procedure validateCountryCode(const bic: string);
        class procedure validateEmpty(const bic: string);
        class procedure validateLength(const bic: string);
        class procedure validateLocationCode(const bic: string);

    public
        class procedure validate(const bic: string);
        class function getBankCode(const bic: string): string;
        class function getBranchCode(const bic: string): string;
        class function getCountryCode(const bic: string): string;
        class function getLocationCode(const bic: string): string;
        class function hasBranchCode(const bic: string): Boolean;
    end;

    //Convenience declarations
    EIban4PasException = Iban4Pas.Exceptions.EIban4PasException;
    EUnsupportedCountryException = Iban4Pas.UnsupportedCountryException.EUnsupportedCountryException;
    EBicFormatException = Iban4Pas.BicFormatException.EBicFormatException;

implementation

uses
    System.SysUtils,
    System.Character;



{**
 * Validates bic.
 *
 * @param bic to be validated.
 * @throws BicFormatException if bic is invalid.
 *         UnsupportedCountryException if bic's country is not supported.
 *}
class procedure TBicUtil.validate(const bic: string);
begin
    try
        validateEmpty(bic);
        validateLength(bic);
        validateCase(bic);
        validateBankCode(bic);
        validateCountryCode(bic);
        validateLocationCode(bic);

        if hasBranchCode(bic) then
            validateBranchCode(bic);

    except
        on E: EUnsupportedCountryException do
          raise;
        on E: Exception do
          raise EBicFormatException.Create(UNKNOWN, E.Message);
    end;
end;

class procedure TBicUtil.validateEmpty(const bic: string);
begin
    if bic.IsEmpty then
        raise EBicFormatException.Create(BIC_NOT_EMPTY,
          'Empty string can''t be a valid Bic.');
end;

class procedure TBicUtil.validateLength(const bic: string);
begin
    if (bic.length <> BIC8_LENGTH) and (bic.length <> BIC11_LENGTH) then
    begin
        raise EBicFormatException.Create(BIC_LENGTH_8_OR_11,
          Format('Bic length must be %d or %d',
          [BIC8_LENGTH, BIC11_LENGTH]));
    end;
end;

class procedure TBicUtil.validateCase(const bic: string);
begin
    if not bic.equals(bic.toUpper()) then
    begin
        raise EBicFormatException.Create(BIC_ONLY_UPPER_CASE_LETTERS,
          'Bic must contain only upper case letters.');
    end;
end;

class procedure TBicUtil.validateBankCode(const bic: string);
var
    bankCode: string;
    ch: Char;
begin
    bankCode := getBankCode(bic);
    for ch in bankCode do
    begin
        if not ch.isLetter then
        begin
            raise EBicFormatException.Create(BANK_CODE_ONLY_LETTERS, ch,
                    'Bank code must contain only letters.');
        end;
    end;
end;

class procedure TBicUtil.validateCountryCode(const bic: string);
var
    countryCode: string;
begin
    countryCode := getCountryCode(bic);
    if (countryCode.trim().Length < COUNTRY_CODE_LENGTH) or
            not countryCode.equals(countryCode.toUpper()) or
            not Char(countryCode[1]).isLetter or    //!Character.isLetter(countryCode.charAt(0)) ||
            not Char(countryCode[2]).isLetter then //!Character.isLetter(countryCode.charAt(1))) {
    begin
        raise EBicFormatException.Create(COUNTRY_CODE_ONLY_UPPER_CASE_LETTERS,
                countryCode,
                'Bic country code must contain upper case letters');
    end;

    if TCountryCode.getByCode(countryCode) = TCountryCode.UNKNOWN then
    begin
        raise EUnsupportedCountryException.Create(countryCode,
                'Country code is not supported.');
    end;
end;

class procedure TBicUtil.validateLocationCode(const bic: string);
var
    locationCode: string;
    ch: Char;
begin
    locationCode := getLocationCode(bic);
    for ch in locationCode do
    begin
        if not ch.isLetterOrDigit() then
        begin
            raise EBicFormatException.Create(LOCATION_CODE_ONLY_LETTERS_OR_DIGITS,
                    ch, 'Location code must contain only letters or digits.');
        end;
    end;
end;

class procedure TBicUtil.validateBranchCode(const bic: string);
var
    branchCode: string;
    ch: Char;
begin
    branchCode := getBranchCode(bic);
    for ch in branchCode do
    begin
        if not ch.isLetterOrDigit() then
        begin
            raise EBicFormatException.Create(BRANCH_CODE_ONLY_LETTERS_OR_DIGITS,
                    ch, 'Branch code must contain only letters or digits.');
        end;
    end;
end;

class function TBicUtil.getBankCode(const bic: string): string;
begin
    Result := bic.substring(BANK_CODE_INDEX, BANK_CODE_LENGTH);
end;

class function TBicUtil.getCountryCode(const bic: string): string;
begin
    Result := bic.substring(COUNTRY_CODE_INDEX, COUNTRY_CODE_LENGTH);
end;

class function TBicUtil.getLocationCode(const bic: string): string;
begin
    Result := bic.substring(LOCATION_CODE_INDEX, LOCATION_CODE_LENGTH);
end;

class function TBicUtil.getBranchCode(const bic: string): string;
begin
    Result := bic.substring(BRANCH_CODE_INDEX, BRANCH_CODE_LENGTH);
end;

class function TBicUtil.hasBranchCode(const bic: string): Boolean;
begin
    Result := bic.length = BIC11_LENGTH;
end;

end.
