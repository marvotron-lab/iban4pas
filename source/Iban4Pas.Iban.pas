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
unit Iban4Pas.Iban;

{
    TODO:
    * implement random / Builder.buildRandom
}

interface

uses
    Iban4Pas.BaseTypes,
    Iban4Pas.Exceptions,
    Iban4Pas.IbanFormatException,
    Iban4Pas.InvalidCheckDigitException,
    Iban4Pas.UnsupportedCountryException,
    Iban4Pas.BbanStructure,
    Iban4Pas.BbanStructureEntry,
    Iban4Pas.CountryCode,
    Iban4Pas.IbanUtil;


type
    {**
     * International Bank Account Number
     *
     * <a href="http://en.wikipedia.org/wiki/ISO_13616">ISO_13616</a>.
     *}
    IIban = interface
    ['{7074CFDE-34D5-4B25-B6EF-464693B28315}']
        function equals(obj: IIban): Boolean;
        function getAccountNumber: string;
        function getAccountType: string;
        function getBankCode: string;
        function getBban: string;
        function getBranchCode: string;
        function getCheckDigit: string;
        function getCountryCode: TCountryCode;
        function getIdentificationNumber: string;
        function getNationalCheckDigit: string;
        function getOwnerAccountType: string;
        function toFormattedString: string;
        function toString: string;
    end;

    IIbanBuilder = interface
    ['{A2951D53-B7B5-4D7D-9C20-9CFB55CB0233}']
        function accountNumber(const accountNumber: string): IIbanBuilder;
        function accountType(const accountType: string): IIbanBuilder;
        function bankCode(const bankCode: string): IIbanBuilder;
        function branchCode(const branchCode: string): IIbanBuilder;
        function build: IIban; overload;
        function build(validate: Boolean): IIban; overload;
        function countryCode(const countryCode: TCountryCode): IIbanBuilder;
        function identificationNumber(const identificationNumber: string): IIbanBuilder;
        function nationalCheckDigit(const nationalCheckDigit: string): IIbanBuilder;
        function ownerAccountType(const ownerAccountType: string): IIbanBuilder;
    end;

    //This class is used to generate instances of IIban
    TIban = class(TInterfacedObject)
    public
        const DEFAULT_CHECK_DIGIT = '00';
        class function valueOf(const iban: string): IIban; overload;
        class function valueOf(const iban: string; const format: TIbanFormat): IIban; overload;
        class function Builder(): IIbanBuilder;
    end;

    //convenience declarations
    EIban4PasException = Iban4Pas.Exceptions.EIban4PasException;
    EIbanFormatException = Iban4Pas.IbanFormatException.EIbanFormatException;
    EInvalidCheckDigitException = Iban4Pas.InvalidCheckDigitException.EInvalidCheckDigitException;
    EUnsupportedCountryException = Iban4Pas.UnsupportedCountryException.EUnsupportedCountryException;
    TIbanFormat = Iban4Pas.BaseTypes.TIbanFormat;

implementation

uses
    System.SysUtils;

type

    //the implementation of IIban is hidden:
    TIIban = class(TIban, IIban)
    private
        // Cache string value of the iban
        FValue: string;
    private
        constructor Create(const value: string);
    protected   //public via interface
        function equals(obj: IIban): Boolean; reintroduce;
        function getAccountNumber: string;
        function getAccountType: string;
        function getBankCode: string;
        function getBban: string;
        function getBranchCode: string;
        function getCheckDigit: string;
        function getCountryCode: TCountryCode;
        function getIdentificationNumber: string;
        function getNationalCheckDigit: string;
        function getOwnerAccountType: string;
        function toFormattedString: string;
        function toString: string; reintroduce;
    end;


    {**
     * Iban Builder Class
     *}
    TIIbanBuilder = class(TInterfacedObject, IIbanBuilder)
    private
        FCountryCode: TCountryCode;
        FBankCode: string;
        FBranchCode: string;
        FNationalCheckDigit: string;
        FAccountType: string;
        FAccountNumber: string;
        FOwnerAccountType: string;
        FIdentificationNumber: string;
        //private final Random random = new Random();
        function formatBban: string;
        function formatIban: string;
        procedure require(const countryCode: TCountryCode; const bankCode, accountNumber: string);
    protected   //access via Interface
        constructor Create;
        function accountNumber(const accountNumber: string): IIbanBuilder;
        function accountType(const accountType: string): IIbanBuilder;
        function bankCode(const bankCode: string): IIbanBuilder;
        function branchCode(const branchCode: string): IIbanBuilder;
        function build: IIban; overload;
        function build(validate: Boolean): IIban; overload;
        function countryCode(const countryCode: TCountryCode): IIbanBuilder;
        function identificationNumber(const identificationNumber: string): IIbanBuilder;
        function nationalCheckDigit(const nationalCheckDigit: string): IIbanBuilder;
        function ownerAccountType(const ownerAccountType: string): IIbanBuilder;
    end;


{**
 * Creates iban instance.
 *
 * @param value String
 *}
constructor TIIban.Create(const value: string);
begin
    FValue := value;
end;

{**
 * Returns iban's country code.
 *
 * @return countryCode CountryCode
 *}
function TIIban.getCountryCode(): TCountryCode;
begin
    Result := TCountryCode.getByCode(TIbanUtil.getCountryCode(FValue));
end;

{**
 * Returns iban's check digit.
 *
 * @return checkDigit String
 *}
function TIIban.getCheckDigit(): string;
begin
    Result := TIbanUtil.getCheckDigit(FValue);
end;

{**
 * Returns iban's account number.
 *
 * @return accountNumber String
 *}
function TIIban.getAccountNumber(): string;
begin
    Result := TIbanUtil.getAccountNumber(FValue);
end;

{**
 * Returns iban's bank code.
 *
 * @return bankCode String
 *}
function TIIban.getBankCode(): string;
begin
    Result := TIbanUtil.getBankCode(FValue);
end;

{**
 * Returns iban's branch code.
 *
 * @return branchCode String
 *}
function TIIban.getBranchCode(): string;
begin
    Result := TIbanUtil.getBranchCode(FValue);
end;

{**
 * Returns iban's national check digit.
 *
 * @return nationalCheckDigit String
 *}
function TIIban.getNationalCheckDigit(): string;
begin
    Result := TIbanUtil.getNationalCheckDigit(FValue);
end;

{**
 * Returns iban's account type.
 *
 * @return accountType String
 *}
function TIIban.getAccountType(): string;
begin
    Result := TIbanUtil.getAccountType(FValue);
end;

{**
 * Returns iban's owner account type.
 *
 * @return ownerAccountType String
 *}
function TIIban.getOwnerAccountType(): string;
begin
    Result := TIbanUtil.getOwnerAccountType(FValue);
end;

{**
 * Returns iban's identification number.
 *
 * @return identificationNumber String
 *}
function TIIban.getIdentificationNumber(): string;
begin
    Result := TIbanUtil.getIdentificationNumber(FValue);
end;

{**
 * Returns iban's bban (Basic Bank Account Number).
 *
 * @return bban String
 *}
function TIIban.getBban(): string;
begin
    Result := TIbanUtil.getBban(FValue);
end;

{**
 * Returns an Iban object holding the value of the specified String.
 *
 * @param iban the String to be parsed.
 * @return an Iban object holding the value represented by the string argument.
 * @throws IbanFormatException if the String doesn't contain parsable Iban
 *         InvalidCheckDigitException if Iban has invalid check digit
 *         UnsupportedCountryException if Iban's Country is not supported.
 *
 *}
class function TIban.valueOf(const iban: string): IIban;
begin
    TIbanUtil.validate(iban);
    Result := TIIban.Create(iban);
end;

{**
 * Returns an Iban object holding the value of the specified String.
 *
 * @param iban the String to be parsed.
 * @param format the format of the Iban.
 * @return an Iban object holding the value represented by the string argument.
 * @throws IbanFormatException if the String doesn't contain parsable Iban
 *         InvalidCheckDigitException if Iban has invalid check digit
 *         UnsupportedCountryException if Iban's Country is not supported.
 *
 *}
class function TIban.valueOf(const iban: string; const format: TIbanFormat): IIban;
var
    ibanWithoutSpaces: string;
    ibanObj: IIban;
begin
    case format of
        TIbanFormat.Default:
            begin
                ibanWithoutSpaces := iban.replace(' ', '');
                ibanObj := valueOf(ibanWithoutSpaces);
                if ibanObj.toFormattedString() = iban then
                  Result := ibanObj
                else
                  raise EIbanFormatException.Create(IBAN_FORMATTING,
                        System.SysUtils.Format('Iban must be formatted using 4 characters and space combination. ' +
                                'Instead of [%s]', [iban]));
            end;
        else
            Result := valueOf(iban);
    end;
end;

function TIIban.ToString(): string;
begin
    Result := FValue;
end;

{**
 * Returns formatted version of Iban.
 *
 * @return A string representing formatted Iban for printing.
 *}
function TIIban.toFormattedString(): string;
begin
    Result := TIbanUtil.toFormattedString(FValue);
end;

//public static Iban random() begin
//    Result := new Iban.Builder().buildRandom();
//end;

//public static Iban random(CountryCode cc) begin
//    Result := new Iban.Builder().countryCode(cc).buildRandom();
//end;

function TIIban.equals(obj: IIban): Boolean;
begin
    if Assigned(obj) then
      Result := FValue = obj.toString()
    else
      Result := False;
end;

//public int hashCode() begin
//    Result := value.hashCode();
//end;

class function TIban.Builder: IIbanBuilder;
begin
    Result := TIIbanBuilder.Create();
end;


{**
 * Creates an Iban Builder instance.
 *}
constructor TIIbanBuilder.Create();
begin
    inherited;
end;

{**
 * Sets iban's country code.
 *
 * @param countryCode CountryCode
 * @return builder Builder
 *}
function TIIbanBuilder.countryCode(const countryCode: TCountryCode): IIbanBuilder;
begin
    FCountryCode := countryCode;
    Result := Self;
end;

{**
 * Sets iban's bank code.
 *
 * @param bankCode String
 * @return builder Builder
 *}
function TIIbanBuilder.bankCode(const bankCode: string): IIbanBuilder;
begin
    FBankCode := bankCode;
    Result := Self;
end;

{**
 * Sets iban's branch code.
 *
 * @param branchCode String
 * @return builder Builder
 *}
function TIIbanBuilder.branchCode(const branchCode: string): IIbanBuilder;
begin
    FBranchCode := branchCode;
    Result := Self;
end;

{**
 * Sets iban's account number.
 *
 * @param accountNumber String
 * @return builder Builder
 *}
function TIIbanBuilder.accountNumber(const accountNumber: string): IIbanBuilder;
begin
    FAccountNumber := accountNumber;
    Result := Self;
end;

{**
 * Sets iban's national check digit.
 *
 * @param nationalCheckDigit String
 * @return builder Builder
 *}
function TIIbanBuilder.nationalCheckDigit(const nationalCheckDigit: string): IIbanBuilder;
begin
    FNationalCheckDigit := nationalCheckDigit;
    Result := Self;
end;

{**
 * Sets iban's account type.
 *
 * @param accountType String
 * @return builder Builder
 *}
function TIIbanBuilder.accountType(const accountType: string): IIbanBuilder;
begin
    FAccountType := accountType;
    Result := Self;
end;

{**
 * Sets iban's owner account type.
 *
 * @param ownerAccountType String
 * @return builder Builder
 *}
function TIIbanBuilder.ownerAccountType(const ownerAccountType: string): IIbanBuilder;
begin
    FOwnerAccountType := ownerAccountType;
    Result := Self;
end;

{**
 * Sets iban's identification number.
 *
 * @param identificationNumber String
 * @return builder Builder
 *}
function TIIbanBuilder.identificationNumber(const identificationNumber: string): IIbanBuilder;
begin
    FIdentificationNumber := identificationNumber;
    Result := Self;
end;

{**
 * Builds new iban instance. This methods validates the generated IBAN.
 *
 * @return new iban instance.
 * @exception IbanFormatException if values are not parsable by Iban Specification
 *  <a href="http://en.wikipedia.org/wiki/ISO_13616">ISO_13616</a>
 * @exception UnsupportedCountryException if country is not supported
 *}
function TIIbanBuilder.build(): IIban;
begin
    Result := build(true);  //true = validate
end;

{**
 * Builds new iban instance.
 *
 * @param validate boolean indicates if the generated IBAN needs to be
 *  validated after generation
 * @return new iban instance.
 * @exception IbanFormatException if values are not parsable by Iban Specification
 *  <a href="http://en.wikipedia.org/wiki/ISO_13616">ISO_13616</a>
 * @exception UnsupportedCountryException if country is not supported
 *}
function TIIbanBuilder.build(validate: Boolean): IIban;
var
    formattedIban: string;
    checkDigit: string;
    ibanValue: string;
begin

    // null checks
    require(FCountryCode, FBankCode, FAccountNumber);

    // iban is formatted with default check digit.
    formattedIban := formatIban();

    checkDigit := TIbanUtil.calculateCheckDigit(formattedIban);

    // replace default check digit with calculated check digit
    ibanValue := TIbanUtil.replaceCheckDigit(formattedIban, checkDigit);

    if validate then
        TIbanUtil.validate(ibanValue);

    Result := TIIban.Create(ibanValue);
end;

//{**
// * Builds random iban instance.
// *
// * @return random iban instance.
// * @exception IbanFormatException if values are not parsable by Iban Specification
// *  <a href="http://en.wikipedia.org/wiki/ISO_13616">ISO_13616</a>
// * @exception UnsupportedCountryException if country is not supported
// *
// *}
//public Iban buildRandom() throws IbanFormatException,
//        IllegalArgumentException, UnsupportedCountryException begin
//    if (countryCode == null) begin
//        List<CountryCode> countryCodes = BbanStructure.supportedCountries();
//        this.countryCode(countryCodes.get(random.nextInt(countryCodes.size())));
//    end;
//    fillMissingFieldsRandomly();
//    Result := build();
//end;

{**
 * Returns formatted bban string.
 *}
function TIIbanBuilder.formatBban(): string;
var
    sb: TStringBuilder;
    structure: TBbanStructure;
    entry: TBbanStructureEntry;
begin
    sb := TStringBuilder.Create();
    try
        structure := TBbanStructure.forCountry(FCountryCode);

        if structure = nil then
            raise EUnsupportedCountryException.Create(FCountryCode.toString(),
                    'Country code is not supported.');

        //for(final BbanStructureEntry entry : structure.getEntries()) {
        for entry in structure.getEntries() do
        begin
            case entry.getEntryType() of
                TBbanEntryType.bank_code:
                    sb.append(FBankCode);
                TBbanEntryType.branch_code:
                    sb.append(FBranchCode);
                TBbanEntryType.account_number:
                    sb.append(FAccountNumber);
                TBbanEntryType.national_check_digit:
                    sb.append(FNationalCheckDigit);
                TBbanEntryType.account_type:
                    sb.append(FAccountType);
                TBbanEntryType.owner_account_number:
                    sb.append(FOwnerAccountType);
                TBbanEntryType.identification_number:
                    sb.append(FIdentificationNumber);
            else
                raise Exception.Create('Internal error: unexpected TBbanEntryType');
            end;
        end;
        Result := sb.toString();
    finally
        sb.Free;
    end;
end;

{**
 * Returns formatted iban string with default check digit.
 *}
function TIIbanBuilder.formatIban(): string;
var
    sb: TStringBuilder;
begin
    sb := TStringBuilder.Create();
    try
        sb.append(FCountryCode.getAlpha2());
        sb.append(TIban.DEFAULT_CHECK_DIGIT);
        sb.append(formatBban());
        Result := sb.toString();
    finally
        sb.Free;
    end;
end;

//throws IbanFormatException
procedure TIIbanBuilder.require(const countryCode: TCountryCode;
                     const bankCode: string;
                     const accountNumber: string);
begin
    if countryCode.isInvalid then
        raise EIbanFormatException.Create(COUNTRY_CODE_NOT_NULL,
                'countryCode is required; it cannot be empty');

    if bankCode = '' then
        raise EIbanFormatException.Create(BANK_CODE_NOT_NULL,
                'bankCode is required; it cannot be null');

    if accountNumber = '' then
        raise EIbanFormatException.Create(ACCOUNT_NUMBER_NOT_NULL,
                'accountNumber is required; it cannot be null');
end;


//private void fillMissingFieldsRandomly() begin
//    final BbanStructure structure = BbanStructure.forCountry(countryCode);
//
//    if (structure == null) begin
//        throw new UnsupportedCountryException(countryCode.toString(),
//                'Country code is not supported.');
//    end;
//
//    for(final BbanStructureEntry entry : structure.getEntries()) begin
//        switch (entry.getEntryType()) begin
//            case bank_code:
//                if (bankCode == null) begin
//                    bankCode = entry.getRandom();
//                end;
//                break;
//            case branch_code:
//                if (branchCode == null) begin
//                    branchCode = entry.getRandom();
//                end;
//                break;
//            case account_number:
//                if (accountNumber == null) begin
//                    accountNumber = entry.getRandom();
//                end;
//                break;
//            case national_check_digit:
//                if (nationalCheckDigit == null) begin
//                    nationalCheckDigit = entry.getRandom();
//                end;
//                break;
//            case account_type:
//                if (accountType == null) begin
//                    accountType = entry.getRandom();
//                end;
//                break;
//            case owner_account_number:
//                if (ownerAccountType == null) begin
//                    ownerAccountType = entry.getRandom();
//                end;
//                break;
//            case identification_number:
//                if (identificationNumber == null) begin
//                    identificationNumber = entry.getRandom();
//                end;
//                break;
//        end;
//    end;
//end;


end.
