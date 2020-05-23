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
unit CountryCodeTest;

interface

uses
    System.SysUtils,
    TestFrameWork,
    BaseTestCase,
    Iban4Pas.CountryCode;

type
    TCountryCodeTest = class(TBaseTestCase)
    published
        procedure getAlpha2WithDECodeShouldReturnGermany;
        procedure getAlpha3WithDECodeShouldReturnGermany;
        procedure getByCodeWith4DigitCodeShouldReturnUnknown;
        procedure getByCodeWithAlpha2CodeShouldReturnCountry;
        procedure getByCodeWithAlpha3CodeShouldReturnCountryCode;
        procedure getByCodeWithLowerCaseAlpha2CodeShouldReturnCountry;
        procedure getByCodeWithLowerCaseAlpha3CodeShouldReturnCountry;
        procedure getByCodeWithNullCodeShouldReturnUnknown;
        procedure getByCodeWithUpperCaseAlpha2CodeShouldReturnCountry;
        procedure getByCodeWithUpperCaseAlpha3CodeShouldReturnCountry;
        procedure getByCodeWithWrongAlpha2CodeShouldReturnUnknown;
        procedure getByCodeWithWrongAlpha3CodeShouldReturnUnknown;
        procedure getNameWithDECodeShouldReturnGermany;
    end;

implementation


procedure TCountryCodeTest.getByCodeWithAlpha2CodeShouldReturnCountry();
var
    code: TCountryCode;
    newCode: TCountryCode;
begin
    for code in TCountryCode.values() do
    begin
        newCode := TCountryCode.getByCode(code.getAlpha2());
        Check(newCode = code);
    end;
end;


procedure TCountryCodeTest.getByCodeWithLowerCaseAlpha2CodeShouldReturnCountry();
var
    code: TCountryCode;
    newCode: TCountryCode;
begin
    for code in TCountryCode.values() do
    begin
        newCode := TCountryCode.getByCode(code.getAlpha2().toLower());
        Check(newCode = code);
    end;
end;


procedure TCountryCodeTest.getByCodeWithUpperCaseAlpha2CodeShouldReturnCountry();
var
    code: TCountryCode;
    newCode: TCountryCode;
begin
    for code in TCountryCode.values() do
    begin
        newCode := TCountryCode.getByCode(code.getAlpha2().toUpper());
        Check(newCode = code);
    end;
end;


procedure TCountryCodeTest.getByCodeWithAlpha3CodeShouldReturnCountryCode();
var
    code: TCountryCode;
    newCode: TCountryCode;
begin
    for code in TCountryCode.values() do
    begin
        newCode := TCountryCode.getByCode(code.getAlpha3());
        Check(newCode = code);
    end;
end;


procedure TCountryCodeTest.getByCodeWithLowerCaseAlpha3CodeShouldReturnCountry();
var
    code: TCountryCode;
    newCode: TCountryCode;
begin
    for code in TCountryCode.values() do
    begin
        newCode := TCountryCode.getByCode(code.getAlpha3().toLower());
        Check(newCode = code);
    end;
end;


procedure TCountryCodeTest.getByCodeWithUpperCaseAlpha3CodeShouldReturnCountry();
var
    code: TCountryCode;
    newCode: TCountryCode;
begin
    for code in TCountryCode.values() do
    begin
        newCode := TCountryCode.getByCode(code.getAlpha3().toUpper());
        Check(newCode = code);
    end;
end;


procedure TCountryCodeTest.getByCodeWithNullCodeShouldReturnUnknown();
var
    code: TCountryCode;
begin
    code := TCountryCode.getByCode('');
    Check(code = TCountryCode.UNKNOWN);
end;


procedure TCountryCodeTest.getByCodeWith4DigitCodeShouldReturnUnknown();
var
    code: TCountryCode;
begin
    code := TCountryCode.getByCode('XXXX');
    Check(code = TCountryCode.UNKNOWN);
end;


procedure TCountryCodeTest.getByCodeWithWrongAlpha2CodeShouldReturnUnknown();
var
    code: TCountryCode;
begin
    code := TCountryCode.getByCode('XX');
    Check(code = TCountryCode.UNKNOWN);
end;


procedure TCountryCodeTest.getByCodeWithWrongAlpha3CodeShouldReturnUnknown();
var
    code: TCountryCode;
begin
    code := TCountryCode.getByCode('XXX');
    Check(code = TCountryCode.UNKNOWN);
end;


procedure TCountryCodeTest.getNameWithDECodeShouldReturnGermany();
begin
    Check(TCountryCode.DE.getName() = 'Germany');
end;


procedure TCountryCodeTest.getAlpha2WithDECodeShouldReturnGermany();
begin
    Check(TCountryCode.DE.getAlpha2() = 'DE');
end;


procedure TCountryCodeTest.getAlpha3WithDECodeShouldReturnGermany();
begin
    Check(TCountryCode.DE.getAlpha3() = 'DEU');
end;


initialization
    RegisterTest(TCountryCodeTest.Suite);

end.