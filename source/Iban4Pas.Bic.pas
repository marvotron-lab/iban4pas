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
unit Iban4Pas.Bic;

interface

uses
    Iban4Pas.Exceptions,
    Iban4Pas.UnsupportedCountryException,
    Iban4Pas.BicFormatException,
    Iban4Pas.CountryCode;

type

    {**
     * Business Identifier Codes (also known as SWIFT-BIC, BIC code, SWIFT ID or SWIFT code).
     *
     * <a href="http://en.wikipedia.org/wiki/ISO_9362">ISO_9362</a>.
     *}
    IBic = interface
    ['{DD24A6A4-EE66-463B-A6CD-312150371453}']
        function equals(other: IBic): Boolean;
        function getBankCode: string;
        function getBranchCode: string;
        function getCountryCode: TCountryCode;
        function getLocationCode: string;
        //function hashCode: string;
        function toString: string;
    end;

    //This class is used to generate instances of IBic
    TBic = class(TInterfacedObject)
    public
        class function valueOf(const bic: string): IBic;
    end;

    //Convenience declarations
    EIban4PasException = Iban4Pas.Exceptions.EIban4PasException;
    EUnsupportedCountryException = Iban4Pas.UnsupportedCountryException.EUnsupportedCountryException;
    EBicFormatException = Iban4Pas.BicFormatException.EBicFormatException;


implementation

uses
    System.SysUtils,
    Iban4Pas.BicUtil;

type
    TIBic = class(TBic, IBic)
    private
        FValue: string;
    protected   //public via interface
        function equals(other: IBic): Boolean; reintroduce;
        function toString: string; reintroduce;
        function getBankCode: string;
        function getBranchCode: string;
        function getCountryCode: TCountryCode;
        function getLocationCode: string;
        //function hashCode: string;
        constructor Create(const value: string);
    end;



constructor TIBic.Create(const value: string);
begin
    FValue := value;
end;

{**
 * Returns a Bic object holding the value of the specified String.
 *
 * @param bic the String to be parsed.
 * @return a Bic object holding the value represented by the string argument.
 * @throws BicFormatException if the String doesn't contain parsable Bic.
 *         UnsupportedCountryException if bic's country is not supported.
 *}
class function TBic.valueOf(const bic: string): IBic;
begin
    TBicUtil.validate(bic);
    Result := TIBic.Create(bic);
end;

{**
 * Returns the bank code from the Bic.
 *
 * @return string representation of Bic's institution code.
 *}
function TIBic.getBankCode(): string;
begin
    Result := TBicUtil.getBankCode(FValue);
end;

{**
 * Returns the country code from the Bic.
 *
 * @return CountryCode representation of Bic's country code.
 *}
function TIBic.getCountryCode(): TCountryCode;
begin
    Result := TCountryCode.getByCode(TBicUtil.getCountryCode(FValue));
end;

{**
 * Returns the location code from the Bic.
 *
 * @return string representation of Bic's location code.
 *}
function TIBic.getLocationCode(): string;
begin
    Result := TBicUtil.getLocationCode(FValue);
end;

{**
 * Returns the branch code from the Bic.
 *
 * @return string representation of Bic's branch code, null if Bic has no branch code.
 *}
function TIBic.getBranchCode(): string;
begin
    if TBicUtil.hasBranchCode(FValue) then
      Result := TBicUtil.getBranchCode(FValue)
    else
      Result := '';
end;

function TIBic.equals(other: IBic): Boolean;
begin
    if Assigned(other) then
      Result := FValue = other.toString()
    else
      Result := False;
end;


function TIBic.toString(): string;
begin
    Result := FValue;
end;

end.
